import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';
import 'package:mochi_moon/features/recap/domain/monthly_recap.dart';

final _october = DateTime(2026, 10);

MonthlyRecap _build({
  List<DateTime> ritual = const [],
  List<DayMood> moods = const [],
  List<({String quoteId, DateTime savedAt})> saved = const [],
}) => buildMonthlyRecap(
  month: _october,
  ritualDays: ritual,
  moods: moods,
  saved: saved,
);

void main() {
  test('lastMonthOf is the first of the month before, across a year', () {
    expect(lastMonthOf(DateTime(2026, 11, 2)), DateTime(2026, 10));
    expect(lastMonthOf(DateTime(2027, 1, 15)), DateTime(2026, 12));
  });

  test('counts each day she showed up once, only inside the month', () {
    final recap = _build(
      ritual: [
        DateTime(2026, 9, 30),
        DateTime(2026, 10, 3, 8),
        DateTime(2026, 10, 3, 21),
        DateTime(2026, 10, 31),
        DateTime(2026, 11),
      ],
    );

    expect(recap.daysShownUp, 2);
    expect(recap.daysInMonth, 31);
    expect(recap.isWelcomeBack, isFalse);
  });

  test('the top mood is the one logged on most days', () {
    final recap = _build(
      ritual: [DateTime(2026, 10)],
      moods: [
        DayMood(day: DateTime(2026, 10), mood: Mood.calm),
        DayMood(day: DateTime(2026, 10, 2), mood: Mood.sad),
        DayMood(day: DateTime(2026, 10, 3), mood: Mood.sad),
        DayMood(day: DateTime(2026, 9, 3), mood: Mood.happy),
        DayMood(day: DateTime(2026, 9, 4), mood: Mood.happy),
        DayMood(day: DateTime(2026, 9, 5), mood: Mood.happy),
      ],
    );

    expect(recap.topMood, Mood.sad);
  });

  test('no mood that month means no top mood', () {
    expect(_build(ritual: [DateTime(2026, 10)]).topMood, isNull);
  });

  test('the favourite is the card saved last that month', () {
    final recap = _build(
      ritual: [DateTime(2026, 10)],
      saved: [
        (quoteId: 'early', savedAt: DateTime(2026, 10, 2)),
        (quoteId: 'late', savedAt: DateTime(2026, 10, 20)),
        (quoteId: 'november', savedAt: DateTime(2026, 11, 2)),
      ],
    );

    expect(recap.favouriteQuoteId, 'late');
  });

  test('no card saved that month means no favourite', () {
    final recap = _build(
      saved: [(quoteId: 'old', savedAt: DateTime(2026, 9, 2))],
    );

    expect(recap.favouriteQuoteId, isNull);
  });

  test('a month with no days shown up is the welcome-back variant', () {
    final recap = _build(
      moods: [DayMood(day: DateTime(2026, 10, 2), mood: Mood.calm)],
    );

    expect(recap.daysShownUp, 0);
    expect(recap.isWelcomeBack, isTrue);
  });
}
