import 'package:flutter/foundation.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';

/// The weekly letter from Mochi (PRD §6.24): what the server wrote, or the
/// bundled fallback when it could not be reached.
@immutable
class WeeklyLetter {
  const WeeklyLetter({
    required this.weekStart,
    required this.lang,
    required this.version,
    required this.title,
    required this.body,
  });

  /// Monday of the week the letter is about, `YYYY-MM-DD`.
  final String weekStart;
  final String lang;
  final int version;
  final String title;
  final String body;

  /// The first sentence, used as the teaser line.
  String get firstLine {
    final text = body.trim();
    final end = text.indexOf(RegExp(r'[.!?](\s|$)'));
    return end < 0 ? text : text.substring(0, end + 1);
  }

  @override
  bool operator ==(Object other) =>
      other is WeeklyLetter &&
      other.weekStart == weekStart &&
      other.lang == lang &&
      other.version == version &&
      other.title == title &&
      other.body == body;

  @override
  int get hashCode => Object.hash(weekStart, lang, version, title, body);
}

/// A letter to show, and whether it is the bundled fallback.
@immutable
class WeeklyLetterView {
  const WeeklyLetterView({required this.letter, this.isFallback = false});

  final WeeklyLetter letter;
  final bool isFallback;
}

/// The Monday of the week that holds [day], at local midnight.
DateTime mondayOf(DateTime day) {
  final date = DateTime(day.year, day.month, day.day);
  return DateTime(date.year, date.month, date.day - (date.weekday - 1));
}

/// `YYYY-MM-DD` of the local day of [day].
String weekDateKey(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-'
    '${day.month.toString().padLeft(2, '0')}-'
    '${day.day.toString().padLeft(2, '0')}';

/// The week the letter is about at [now]: on Sunday the week that ends today,
/// on any other day the week that ended last Sunday (PRD §6.24).
DateTime letterWeekStart(DateTime now) {
  final monday = mondayOf(now);
  return now.weekday == DateTime.sunday
      ? monday
      : DateTime(monday.year, monday.month, monday.day - 7);
}

/// What the server may be told about one week. **Counts and ids only**: there
/// is no field that could hold something she wrote (CLAUDE.md §9), and the
/// request test fails if one is added.
@immutable
class WeekAggregates {
  const WeekAggregates({
    required this.weekStart,
    required this.moodCounts,
    required this.ritualDays,
    required this.questsCompleted,
    this.journeyId,
    this.journeyDay,
    this.focusAreas = const [],
  });

  /// Monday of the week.
  final DateTime weekStart;

  /// Days with each mood; every mood is present.
  final Map<Mood, int> moodCounts;
  final int ritualDays;
  final int questsCompleted;
  final String? journeyId;
  final int? journeyDay;
  final List<String> focusAreas;

  /// A week with nothing in it at all.
  bool get isEmpty =>
      ritualDays == 0 &&
      questsCompleted == 0 &&
      moodCounts.values.every((n) => n == 0);

  /// The `POST /v1/letters/weekly` body (PRD §8.2).
  Map<String, Object?> toRequest(String lang) => {
    'lang': lang,
    'weekStart': weekDateKey(weekStart),
    'moodCounts': {for (final mood in Mood.values) mood.id: moodCounts[mood]},
    'ritualDays': ritualDays,
    'questsCompleted': questsCompleted,
    'journey': journeyId == null ? null : {'id': journeyId, 'day': journeyDay},
    'focusAreas': focusAreas,
  };
}

/// Counts the week that starts on [weekStart] (a Monday) from her own data.
/// [moods] and [ritualDays] may hold any dates; only the seven days count.
WeekAggregates buildWeekAggregates({
  required DateTime weekStart,
  required Iterable<DayMood> moods,
  required Iterable<DateTime> ritualDays,
  required Iterable<String> questDoneDays,
  String? journeyId,
  int? journeyDay,
  Iterable<String> focusAreas = const [],
}) {
  final days = {
    for (var i = 0; i < 7; i++)
      weekDateKey(DateTime(weekStart.year, weekStart.month, weekStart.day + i)),
  };
  final counts = {for (final mood in Mood.values) mood: 0};
  for (final entry in moods) {
    if (days.contains(weekDateKey(entry.day))) {
      counts[entry.mood] = counts[entry.mood]! + 1;
    }
  }
  return WeekAggregates(
    weekStart: weekStart,
    moodCounts: counts,
    ritualDays: {
      for (final day in ritualDays)
        if (days.contains(weekDateKey(day))) weekDateKey(day),
    }.length,
    questsCompleted: questDoneDays.toSet().where(days.contains).length,
    journeyId: journeyId,
    journeyDay: journeyId == null ? null : (journeyDay ?? 1).clamp(1, 14),
    focusAreas: focusAreas.toList(growable: false),
  );
}
