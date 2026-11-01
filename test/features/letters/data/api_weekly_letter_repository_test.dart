import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/network/network_providers.dart';
import 'package:mochi_moon/core/network/readings_api.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/letters/data/api_weekly_letter_repository.dart';
import 'package:mochi_moon/features/letters/data/drift_weekly_letter_cache.dart';
import 'package:mochi_moon/features/letters/domain/weekly_letter.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';

import '../../../core/network/fake_http_adapter.dart';

WeekAggregates _week(DateTime monday) => buildWeekAggregates(
  weekStart: monday,
  moods: [DayMood(day: monday, mood: Mood.calm)],
  ritualDays: [monday],
  questDoneDays: const [],
);

void main() {
  late AppDatabase db;
  late FakeHttpAdapter adapter;
  late ApiWeeklyLetterRepository repository;
  final monday = DateTime(2026, 10, 26);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    adapter = FakeHttpAdapter((options) async {
      final body = options.data! as Map<String, Object?>;
      return jsonResponse({
        'weekStart': body['weekStart'],
        'lang': body['lang'],
        'version': 1,
        'title': 'Title ${body['lang']}',
        'body': 'Body for ${body['weekStart']}.',
        'generatedBy': 'ai',
      });
    });
    final dio = createReadingsDio('https://api.example.com/v1', () async => 't')
      ..httpClientAdapter = adapter;
    repository = ApiWeeklyLetterRepository(
      api: ReadingsApi(dio),
      cache: DriftWeeklyLetterCache(db),
    );
  });
  tearDown(() => db.close());

  test(
    'posts the week counts to letters/weekly and keeps the letter',
    () async {
      final letter = await repository.letter(week: _week(monday), lang: 'en');

      expect(letter.title, 'Title en');
      final request = adapter.requests.single;
      expect(request.path, 'letters/weekly');
      expect((request.data! as Map).keys.toSet(), {
        'lang',
        'weekStart',
        'moodCounts',
        'ritualDays',
        'questsCompleted',
        'journey',
        'focusAreas',
      });
      expect(
        await repository.cached(lang: 'en', weekStart: '2026-10-26'),
        letter,
      );
    },
  );

  test('asks the server once per week and language', () async {
    await repository.letter(week: _week(monday), lang: 'en');
    await repository.letter(week: _week(monday), lang: 'en');
    expect(adapter.requests, hasLength(1));

    await repository.letter(week: _week(monday), lang: 'my');
    expect(adapter.requests, hasLength(2));

    await repository.letter(week: _week(DateTime(2026, 10, 19)), lang: 'en');
    expect(adapter.requests, hasLength(3));
  });

  test('nothing is cached for a week that was never fetched', () async {
    expect(
      await repository.cached(lang: 'en', weekStart: '2026-10-26'),
      isNull,
    );
  });

  test('a failed call saves nothing and throws', () async {
    adapter.handler = (options) async =>
        errorResponse(500, 'generation_failed');

    await expectLater(
      repository.letter(week: _week(monday), lang: 'en'),
      throwsA(isA<ReadingsApiException>()),
    );
    expect(
      await repository.cached(lang: 'en', weekStart: '2026-10-26'),
      isNull,
    );
  });

  test('an answer with the wrong shape is refused and not saved', () async {
    adapter.handler = (options) async => jsonResponse({'title': 1});

    await expectLater(
      repository.letter(week: _week(monday), lang: 'en'),
      throwsA(isA<FormatException>()),
    );
    expect(
      await repository.cached(lang: 'en', weekStart: '2026-10-26'),
      isNull,
    );
  });
}
