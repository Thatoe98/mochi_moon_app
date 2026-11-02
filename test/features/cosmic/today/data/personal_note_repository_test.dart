import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/network/network_providers.dart';
import 'package:mochi_moon/core/network/readings_api.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/today/data/api_personal_note_repository.dart';
import 'package:mochi_moon/features/cosmic/today/data/personal_note_codec.dart';

import '../../../../core/network/fake_http_adapter.dart';

NatalChart _chart() => computeNatalChart(
  BirthData(
    birthDate: DateTime(1998, 11, 8),
    birthMinutes: 8 * 60 + 30,
    tzId: 'Asia/Bangkok',
    latitude: 13.75,
    longitude: 100.5,
  ),
);

Map<String, Object?> _answer() => {
  'date': '2026-11-02',
  'lang': 'en',
  'version': 1,
  'title': 'A tender day',
  'body': 'Go gently.',
};

void main() {
  final date = DateTime(2026, 11, 2);

  group('personalNoteRequest', () {
    test('holds placements and transits only, no birth data', () {
      final body = personalNoteRequest(chart: _chart(), date: date, lang: 'en');
      final text = jsonEncode(body);
      expect(body.keys, {'lang', 'date', 'moonSign', 'placements', 'transits'});
      expect(body['date'], '2026-11-02');
      expect(text, isNot(contains('1998')));
      expect(text, isNot(contains('13.75')));
      expect(text, isNot(contains('Asia/Bangkok')));
    });

    test('has at most six transits and degrees below 30', () {
      final body = personalNoteRequest(chart: _chart(), date: date, lang: 'en');
      expect((body['transits']! as List).length, lessThanOrEqualTo(6));
      for (final p in body['placements']! as List) {
        expect((p as Map<String, Object?>)['degree']! as double, lessThan(30));
        expect(p.containsKey('house'), isFalse);
      }
    });

    test('is the same for the same day and differs for another', () {
      final a = personalNoteRequest(chart: _chart(), date: date, lang: 'en');
      final b = personalNoteRequest(chart: _chart(), date: date, lang: 'en');
      final c = personalNoteRequest(
        chart: _chart(),
        date: DateTime(2026, 11, 20),
        lang: 'en',
      );
      expect(jsonEncode(a), jsonEncode(b));
      expect(jsonEncode(a), isNot(jsonEncode(c)));
    });
  });

  group('ApiPersonalNoteRepository', () {
    late AppDatabase db;
    late FakeHttpAdapter adapter;
    late ApiPersonalNoteRepository repository;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      adapter = FakeHttpAdapter((_) async => jsonResponse(_answer()));
      final dio = createReadingsDio(
        'https://api.example.com/v1',
        () async => 't',
      )..httpClientAdapter = adapter;
      repository = ApiPersonalNoteRepository(
        api: ReadingsApi(dio),
        cache: DriftPersonalNoteCache(db),
      );
    });
    tearDown(() => db.close());

    test('asks once a day, then serves the saved note', () async {
      expect(await repository.cached(date: date, lang: 'en'), isNull);
      final first = await repository.note(
        chart: _chart(),
        date: date,
        lang: 'en',
      );
      expect(first.title, 'A tender day');
      expect(adapter.requests.single.path, 'daily/personal');

      adapter.requests.clear();
      expect(await repository.cached(date: date, lang: 'en'), isNotNull);
      await repository.note(chart: _chart(), date: date, lang: 'en');
      expect(adapter.requests, isEmpty);

      await repository.note(
        chart: _chart(),
        date: DateTime(2026, 11, 3),
        lang: 'en',
      );
      expect(adapter.requests, hasLength(1));
    });

    test('a 402 reaches the caller as Premium-required', () async {
      adapter.handler = (_) async => jsonResponse({
        'error': {'code': 'premium_required', 'message': 'Premium'},
      }, status: 402);
      await expectLater(
        repository.note(chart: _chart(), date: date, lang: 'en'),
        throwsA(
          isA<ReadingsApiException>().having(
            (e) => e.isPremiumRequired,
            'isPremiumRequired',
            isTrue,
          ),
        ),
      );
    });

    test('a wrong shape is not saved', () async {
      adapter.handler = (_) async => jsonResponse({'title': 1});
      await expectLater(
        repository.note(chart: _chart(), date: date, lang: 'en'),
        throwsFormatException,
      );
      expect(await repository.cached(date: date, lang: 'en'), isNull);
    });
  });
}
