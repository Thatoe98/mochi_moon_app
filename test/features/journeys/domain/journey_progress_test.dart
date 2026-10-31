import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/journey.dart';
import 'package:mochi_moon/core/content/quest.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/features/journeys/domain/journey_progress.dart';

final _journey = Journey(
  id: 'confidence',
  days: 3,
  title: const {'en': 'Confidence'},
  summary: const {'en': 'Three days'},
  illustrationId: 'ill_journey_confidence',
  daysPlan: [
    for (var day = 1; day <= 3; day++)
      JourneyDayPlan(
        day: day,
        quoteIds: ['a$day', 'b$day', 'missing'],
        questId: 'k$day',
        reflection: {'en': 'Reflect $day'},
      ),
  ],
);

final _start = DateTime(2026, 11, 2, 8);
JourneyProgress _fresh() => startJourney(_journey, _start);

void main() {
  test('starts on day 1 with nothing done', () {
    final run = _fresh();
    expect(run.currentDay, 1);
    expect(run.completedDays, isEmpty);
    expect(run.isFinished, isFalse);
  });

  test('finishing a day moves to the next one', () {
    final run = _fresh().completeDay(
      DateTime(2026, 11, 2, 9),
      totalDays: 3,
      reflection: '  I did well  ',
    );
    expect(run.currentDay, 2);
    expect(run.completedDays, [1]);
    expect(run.reflections, {1: 'I did well'});
  });

  test('only one day can be finished per calendar day', () {
    final today = DateTime(2026, 11, 2, 9);
    final once = _fresh().completeDay(today, totalDays: 3);
    final twice = once.completeDay(DateTime(2026, 11, 2, 23), totalDays: 3);

    expect(twice, once);
    expect(once.canCompleteDay(today), isFalse);
    expect(once.canCompleteDay(DateTime(2026, 11, 3, 7)), isTrue);
  });

  test('skipped days pause the journey and never reset it', () {
    final monday = _fresh().completeDay(DateTime(2026, 11, 2), totalDays: 3);
    // She is away for a week, then comes back.
    final back = DateTime(2026, 11, 12, 9);

    expect(monday.canCompleteDay(back), isTrue);
    final resumed = monday.completeDay(back, totalDays: 3);
    expect(resumed.currentDay, 3);
    expect(resumed.completedDays, [1, 2]);
    expect(resumed.startedAt, _start);
  });

  test('a blank reflection is not kept', () {
    final run = _fresh().completeDay(
      DateTime(2026, 11, 2),
      totalDays: 3,
      reflection: '   ',
    );
    expect(run.reflections, isEmpty);
  });

  test('finishing the last day completes the journey for good', () {
    var run = _fresh();
    for (var day = 0; day < 3; day++) {
      run = run.completeDay(DateTime(2026, 11, 2 + day), totalDays: 3);
    }
    expect(run.isFinished, isTrue);
    expect(run.completedDays, [1, 2, 3]);
    expect(run.currentDay, 3);
    expect(run.completedAt, DateTime(2026, 11, 4));

    final after = run.completeDay(DateTime(2026, 11, 9), totalDays: 3);
    expect(after, run);
  });

  test('she runs one journey at a time', () {
    final going = _fresh();
    final done = JourneyProgress(
      journeyId: 'old',
      startedAt: _start,
      completedAt: _start,
    );

    expect(canStartJourney(const []), isTrue);
    expect(canStartJourney([done]), isTrue);
    expect(canStartJourney([done, going]), isFalse);
    expect(activeJourney([done, going]), going);
    expect(activeJourney([done]), isNull);
  });

  test('day n resolves to its quotes and quest, skipping unknown ids', () {
    final quotes = [
      for (final id in ['a2', 'b2', 'zz'])
        Quote(id: id, text: {'en': id}, category: 'confidence'),
    ];
    final quests = [
      for (final id in ['k1', 'k2']) Quest(id: id, text: {'en': id}),
    ];

    final day = resolveJourneyDay(_journey, 2, quotes, quests)!;
    expect(day.quotes.map((q) => q.id), ['a2', 'b2']);
    expect(day.quest?.id, 'k2');
    expect(day.reflection['en'], 'Reflect 2');

    expect(resolveJourneyDay(_journey, 4, quotes, quests), isNull);
    expect(resolveJourneyDay(_journey, 3, quotes, quests)?.quest, isNull);
  });
}
