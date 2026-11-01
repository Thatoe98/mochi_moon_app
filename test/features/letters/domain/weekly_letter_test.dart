import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/letters/domain/weekly_letter.dart';
import 'package:mochi_moon/features/letters/domain/weekly_letter_notifier.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';

// Monday 26 Oct 2026 .. Sunday 1 Nov 2026.
final _monday = DateTime(2026, 10, 26);

WeekAggregates _week({
  Iterable<DayMood> moods = const [],
  Iterable<DateTime> ritual = const [],
  Iterable<String> quests = const [],
  String? journeyId,
  int? journeyDay,
  Iterable<String> focus = const [],
}) => buildWeekAggregates(
  weekStart: _monday,
  moods: moods,
  ritualDays: ritual,
  questDoneDays: quests,
  journeyId: journeyId,
  journeyDay: journeyDay,
  focusAreas: focus,
);

void main() {
  group('letterWeekStart', () {
    test('on Sunday it is the week that ends today', () {
      expect(letterWeekStart(DateTime(2026, 11, 1, 20)), _monday);
    });

    test('on any other day it is the week that ended last Sunday', () {
      expect(letterWeekStart(DateTime(2026, 11, 2)), _monday);
      expect(letterWeekStart(DateTime(2026, 11, 5, 9)), _monday);
      expect(letterWeekStart(DateTime(2026, 10, 31)), DateTime(2026, 10, 19));
    });
  });

  group('buildWeekAggregates', () {
    test('counts only the seven days of the week', () {
      final week = _week(
        moods: [
          DayMood(day: DateTime(2026, 10, 25), mood: Mood.sad), // before
          DayMood(day: DateTime(2026, 10, 26), mood: Mood.happy),
          DayMood(day: DateTime(2026, 11), mood: Mood.happy),
          DayMood(day: DateTime(2026, 11, 2), mood: Mood.happy), // after
        ],
        ritual: [
          DateTime(2026, 10, 26, 8),
          DateTime(2026, 10, 26, 21), // same day twice
          DateTime(2026, 10, 28),
          DateTime(2026, 11, 3),
        ],
        quests: ['2026-10-27', '2026-10-27', '2026-10-24'],
      );

      expect(week.moodCounts[Mood.happy], 2);
      expect(week.moodCounts[Mood.sad], 0);
      expect(week.ritualDays, 2);
      expect(week.questsCompleted, 1);
      expect(week.isEmpty, isFalse);
    });

    test('every mood is present and an empty week says so', () {
      final week = _week();
      expect(week.moodCounts.keys, Mood.values);
      expect(week.isEmpty, isTrue);
    });

    test('a quest alone is enough to make the week count', () {
      expect(_week(quests: ['2026-10-30']).isEmpty, isFalse);
    });

    test('keeps the journey day inside 1..14', () {
      expect(_week(journeyId: 'j', journeyDay: 30).journeyDay, 14);
      expect(_week(journeyId: 'j', journeyDay: 0).journeyDay, 1);
      expect(_week().journeyDay, isNull);
    });
  });

  group('toRequest', () {
    test('has exactly the allowed keys and no text field', () {
      final body = _week(
        moods: [DayMood(day: _monday, mood: Mood.inLove)],
        ritual: [_monday],
        journeyId: 'kind_to_me',
        journeyDay: 3,
        focus: ['calm', 'confidence'],
      ).toRequest('en');

      // If a field that could hold her own words is added, this fails.
      expect(body.keys.toSet(), {
        'lang',
        'weekStart',
        'moodCounts',
        'ritualDays',
        'questsCompleted',
        'journey',
        'focusAreas',
      });
      expect(body['weekStart'], '2026-10-26');
      expect((body['moodCounts']! as Map).keys.toSet(), {
        'happy',
        'calm',
        'tired',
        'sad',
        'anxious',
        'in_love',
      });
      expect((body['moodCounts']! as Map)['in_love'], 1);
      expect(body['journey'], {'id': 'kind_to_me', 'day': 3});
      expect(body['focusAreas'], ['calm', 'confidence']);
    });

    test('has a null journey when none is active', () {
      expect(_week().toRequest('en')['journey'], isNull);
    });
  });

  group('WeeklyLetter.firstLine', () {
    WeeklyLetter letter(String body) => WeeklyLetter(
      weekStart: '2026-10-26',
      lang: 'en',
      version: 1,
      title: 't',
      body: body,
    );

    test('is the first sentence', () {
      expect(letter('You showed up. That counts.').firstLine, 'You showed up.');
    });

    test('is the whole text when there is no full stop', () {
      expect(letter('Soft week').firstLine, 'Soft week');
    });
  });

  group('upcomingLetterSundays', () {
    test('lists the next four Sundays at 18:00', () {
      final sundays = upcomingLetterSundays(DateTime(2026, 11, 2, 9));
      expect(sundays, [
        DateTime(2026, 11, 8, 18),
        DateTime(2026, 11, 15, 18),
        DateTime(2026, 11, 22, 18),
        DateTime(2026, 11, 29, 18),
      ]);
    });

    test('starts today when it is Sunday before 18:00', () {
      expect(
        upcomingLetterSundays(DateTime(2026, 11, 1, 10)).first,
        DateTime(2026, 11, 1, 18),
      );
    });

    test('skips to next Sunday once 18:00 has passed', () {
      expect(
        upcomingLetterSundays(DateTime(2026, 11, 1, 19)).first,
        DateTime(2026, 11, 8, 18),
      );
    });
  });
}
