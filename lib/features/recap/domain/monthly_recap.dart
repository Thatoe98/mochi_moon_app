import 'package:flutter/foundation.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';

/// What the monthly glow recap (PRD §6.25) says about one month. Only counts,
/// a mood and the id of a bundled card: nothing she wrote can end up here.
@immutable
class MonthlyRecap {
  const MonthlyRecap({
    required this.month,
    required this.daysShownUp,
    required this.daysInMonth,
    this.topMood,
    this.favouriteQuoteId,
  });

  /// The first day of the month, at local midnight.
  final DateTime month;
  final int daysShownUp;
  final int daysInMonth;

  /// The mood she logged on most days, or null when she logged none.
  final Mood? topMood;

  /// The card she saved most recently that month, or null when none.
  final String? favouriteQuoteId;

  /// She did not show up at all: the recap becomes a warm welcome back.
  bool get isWelcomeBack => daysShownUp == 0;
}

/// The first day of the month before the one that holds [now].
DateTime lastMonthOf(DateTime now) => DateTime(now.year, now.month - 1);

/// The recap for the month that starts on [month]. [ritualDays], [moods] and
/// [saved] may hold any dates; only that month counts.
MonthlyRecap buildMonthlyRecap({
  required DateTime month,
  required Iterable<DateTime> ritualDays,
  required Iterable<DayMood> moods,
  required Iterable<({String quoteId, DateTime savedAt})> saved,
}) {
  final first = DateTime(month.year, month.month);
  bool inMonth(DateTime day) =>
      day.year == first.year && day.month == first.month;

  final shown = {
    for (final day in ritualDays)
      if (inMonth(day)) DateTime(day.year, day.month, day.day),
  };

  final counts = <Mood, int>{};
  for (final entry in moods) {
    if (inMonth(entry.day)) counts[entry.mood] = (counts[entry.mood] ?? 0) + 1;
  }
  Mood? top;
  for (final mood in Mood.values) {
    final n = counts[mood] ?? 0;
    if (n > 0 && (top == null || n > counts[top]!)) top = mood;
  }

  String? favourite;
  DateTime? latest;
  for (final entry in saved) {
    if (!inMonth(entry.savedAt)) continue;
    if (latest == null || entry.savedAt.isAfter(latest)) {
      latest = entry.savedAt;
      favourite = entry.quoteId;
    }
  }

  return MonthlyRecap(
    month: first,
    daysShownUp: shown.length,
    daysInMonth: DateTime(first.year, first.month + 1, 0).day,
    topMood: top,
    favouriteQuoteId: favourite,
  );
}
