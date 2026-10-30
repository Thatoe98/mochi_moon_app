import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/network/network_providers.dart';
import 'package:mochi_moon/core/network/readings_api.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';
import 'package:mochi_moon/features/cosmic/today/data/api_daily_reading_repository.dart';
import 'package:mochi_moon/features/cosmic/today/data/daily_reading_codec.dart';
import 'package:mochi_moon/features/cosmic/today/data/drift_daily_reading_cache.dart';
import 'package:mochi_moon/features/cosmic/today/domain/daily_reading.dart';
import 'package:mochi_moon/features/cosmic/today/domain/daily_reading_repository.dart';

import '../../../../core/network/fake_http_adapter.dart';

Map<String, Object?> _json(String headline, {String lang = 'en'}) => {
  'date': '2026-10-30',
  'sign': 'scorpio',
  'lang': lang,
  'version': 1,
  'headline': headline,
  'body': 'Body of $headline.',
  'energy': 'Energy',
  'love': 'Love',
  'avoid': ['a', 'b', 'c'],
  'luckyNumber': 7,
  'generatedBy': 'ai',
  'reviewed': false,
};

class _Bundled implements DailyReadingRepository {
  final asked = <String>[];

  @override
  Future<DailyReading> readingFor({
    required ZodiacSign sign,
    required DateTime date,
    required String lang,
  }) async {
    asked.add(lang);
    return DailyReading(
      headline: 'Bundled',
      body: 'Bundled body.',
      energy: 'Energy',
      love: 'Love',
      avoid: const ['a', 'b', 'c'],
      lang: lang,
      isFallback: true,
    );
  }
}

void main() {
  late AppDatabase db;
  late FakeHttpAdapter adapter;
  late _Bundled bundled;
  late DateTime now;
  late ApiDailyReadingRepository repository;

  final date = DateTime(2026, 10, 30);

  Future<ResponseBody> answer(RequestOptions options) async {
    final lang = options.queryParameters['lang']! as String;
    return jsonResponse(_json('Server $lang', lang: lang));
  }

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    now = DateTime.utc(2026, 10, 30, 8);
    adapter = FakeHttpAdapter(answer);
    final dio = createReadingsDio('https://api.example.com/v1', () async => 't')
      ..httpClientAdapter = adapter;
    bundled = _Bundled();
    repository = ApiDailyReadingRepository(
      api: ReadingsApi(dio),
      cache: DriftDailyReadingCache(db, () => now),
      fallback: bundled,
      now: () => now,
    );
  });
  tearDown(() => db.close());

  Future<DailyReading> read({String lang = 'en'}) =>
      repository.readingFor(sign: ZodiacSign.scorpio, date: date, lang: lang);

  test(
    'asks the server with the sign, the date and the language only',
    () async {
      final reading = await read(lang: 'my');

      expect(reading.headline, 'Server my');
      expect(reading.isFallback, isFalse);
      final request = adapter.requests.single;
      expect(request.path, 'daily');
      expect(request.queryParameters, {
        'sign': 'scorpio',
        'date': '2026-10-30',
        'lang': 'my',
      });
      expect(request.data, isNull);
    },
  );

  test('shows the cached reading without asking again', () async {
    await read();
    adapter.requests.clear();

    final again = await read();

    expect(again.headline, 'Server en');
    expect(adapter.requests, isEmpty);
  });

  test('a cached reading still shows offline', () async {
    await read();
    adapter.handler = (options) async => throw DioException.connectionError(
      requestOptions: options,
      reason: 'x',
    );
    now = now.add(const Duration(days: 1));

    // The same day key is still in the cache.
    expect((await read()).headline, 'Server en');
  });

  test(
    'an old cached reading is shown at once and fetched again behind',
    () async {
      await read();
      adapter.handler = (options) async => jsonResponse(_json('Newer'));
      now = now.add(dailyReadingRefreshAfter + const Duration(minutes: 1));

      final shown = await read();
      await pumpEventQueue();

      expect(shown.headline, 'Server en');
      expect(adapter.requests, hasLength(2));
      expect((await read()).headline, 'Newer');
    },
  );

  test('a failed refresh keeps the old reading', () async {
    await read();
    adapter.handler = (_) async => errorResponse(500, 'server_error');
    now = now.add(dailyReadingRefreshAfter + const Duration(minutes: 1));

    await read();
    await pumpEventQueue();

    expect((await read()).headline, 'Server en');
  });

  test('a language the server lacks falls back to English', () async {
    adapter.handler = (options) async => options.queryParameters['lang'] == 'my'
        ? errorResponse(404, 'not_found')
        : jsonResponse(_json('Server en'));

    final reading = await read(lang: 'my');

    expect(reading.headline, 'Server en');
    expect(reading.lang, 'en');
    expect(reading.isFallback, isFalse);
    expect(adapter.requests.map((r) => r.queryParameters['lang']), [
      'my',
      'en',
    ]);
    expect(bundled.asked, isEmpty);
  });

  test('cached English is used before a second request for English', () async {
    await read();
    adapter.requests.clear();
    adapter.handler = (_) async => errorResponse(404, 'not_found');

    final reading = await read(lang: 'my');

    expect(reading.lang, 'en');
    expect(adapter.requests.map((r) => r.queryParameters['lang']), ['my']);
  });

  test('when even English is missing it uses the bundled text', () async {
    adapter.handler = (_) async => errorResponse(404, 'not_found');

    final reading = await read(lang: 'my');

    expect(reading.isFallback, isTrue);
    expect(bundled.asked, ['my']);
  });

  test('offline it uses the bundled text in the asked language', () async {
    adapter.handler = (options) async => throw DioException.connectionError(
      requestOptions: options,
      reason: 'x',
    );

    final reading = await read(lang: 'my');

    expect(reading.isFallback, isTrue);
    expect(bundled.asked, ['my']);
    expect(adapter.requests, hasLength(1));
  });

  test('a server error uses the bundled text', () async {
    adapter.handler = (_) async => errorResponse(500, 'server_error');

    expect((await read()).isFallback, isTrue);
  });

  test('a reading with a missing field is ignored and not cached', () async {
    adapter.handler = (_) async =>
        jsonResponse(<String, Object?>{..._json('Broken'), 'body': ''});

    expect((await read()).isFallback, isTrue);
    expect(await db.select(db.cachedReadings).get(), isEmpty);
  });

  test(
    'without a sign-in it uses the bundled text and sends nothing',
    () async {
      final dio = createReadingsDio(
        'https://api.example.com/v1',
        () async => null,
      )..httpClientAdapter = adapter;
      final signedOut = ApiDailyReadingRepository(
        api: ReadingsApi(dio),
        cache: DriftDailyReadingCache(db),
        fallback: bundled,
      );

      final reading = await signedOut.readingFor(
        sign: ZodiacSign.scorpio,
        date: date,
        lang: 'en',
      );

      expect(reading.isFallback, isTrue);
      expect(adapter.requests, isEmpty);
    },
  );

  test('each language and day is cached on its own', () async {
    await read();
    await read(lang: 'my');
    await repository.readingFor(
      sign: ZodiacSign.scorpio,
      date: DateTime(2026, 10, 31),
      lang: 'en',
    );

    expect(adapter.requests, hasLength(3));
    expect(await db.select(db.cachedReadings).get(), hasLength(3));
  });

  group('codec', () {
    test('round-trips a reading and its version', () {
      final parsed = dailyReadingFromJson(_json('Hello'));
      final again = dailyReadingFromJson(
        dailyReadingToJson(parsed.reading, parsed.version),
      );

      expect(again, parsed);
      expect(parsed.version, 1);
    });

    test('rejects a wrong type or a missing field', () {
      for (final broken in [
        <String, Object?>{..._json('x'), 'avoid': 'nope'},
        <String, Object?>{..._json('x'), 'avoid': <String>[]},
        <String, Object?>{..._json('x'), 'version': '1'},
        <String, Object?>{..._json('x'), 'headline': null},
        <String, Object?>{..._json('x'), 'lang': ' '},
      ]) {
        expect(() => dailyReadingFromJson(broken), throwsFormatException);
      }
    });
  });

  group('cache', () {
    test('a damaged row reads as missing', () async {
      await read();
      await db
          .update(db.cachedReadings)
          .write(const CachedReadingsCompanion(json: Value('{not json')));

      final cache = DriftDailyReadingCache(db);
      expect(
        await cache.find(date: '2026-10-30', sign: 'scorpio', lang: 'en'),
        isNull,
      );
    });

    test('deleteBefore forgets earlier days', () async {
      await read();
      await repository.readingFor(
        sign: ZodiacSign.scorpio,
        date: DateTime(2026, 10, 31),
        lang: 'en',
      );

      await DriftDailyReadingCache(db).deleteBefore('2026-10-31');

      final rows = await db.select(db.cachedReadings).get();
      expect(rows.map((r) => r.date), ['2026-10-31']);
    });
  });
}
