import 'package:flutter/foundation.dart';
import 'package:mochi_moon/core/content/journey.dart';
import 'package:mochi_moon/core/content/quest.dart';
import 'package:mochi_moon/core/content/quote.dart';

/// `YYYY-MM-DD` of the local day of [day].
String journeyDateKey(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-'
    '${day.month.toString().padLeft(2, '0')}-'
    '${day.day.toString().padLeft(2, '0')}';

/// How far she is in one journey (PRD §6.21).
///
/// Days are done in order and at most one per local day. A missed day pauses
/// the journey: [currentDay] only moves when a day is finished, so nothing is
/// ever reset or lost.
@immutable
class JourneyProgress {
  const JourneyProgress({
    required this.journeyId,
    required this.startedAt,
    this.currentDay = 1,
    this.completedDays = const [],
    this.reflections = const {},
    this.completedAt,
    this.lastDoneOn,
  });

  final String journeyId;
  final DateTime startedAt;

  /// The next day to do (1-based). Stays on the last day once finished.
  final int currentDay;
  final List<int> completedDays;

  /// What she wrote for herself, by day. Private: never sent to the AI API or
  /// to analytics.
  final Map<int, String> reflections;
  final DateTime? completedAt;

  /// Local date (`YYYY-MM-DD`) of the last finished day. Kept on this device
  /// only; after a restore from Firestore it is null.
  final String? lastDoneOn;

  bool get isFinished => completedAt != null;

  /// Whether she can finish [currentDay] on [today]: the journey is not
  /// finished and she has not already finished a day today.
  bool canCompleteDay(DateTime today) =>
      !isFinished && lastDoneOn != journeyDateKey(today);

  /// Finishes [currentDay] on [today], with an optional [reflection], and
  /// moves to the next day. Returns this unchanged when [canCompleteDay] is
  /// false. [totalDays] is the length of the journey.
  JourneyProgress completeDay(
    DateTime today, {
    required int totalDays,
    String? reflection,
  }) {
    if (!canCompleteDay(today)) return this;
    final done = [...completedDays, currentDay];
    final finished = done.length >= totalDays;
    final text = reflection?.trim();
    return JourneyProgress(
      journeyId: journeyId,
      startedAt: startedAt,
      currentDay: finished ? totalDays : currentDay + 1,
      completedDays: done,
      reflections: {
        ...reflections,
        if (text != null && text.isNotEmpty) currentDay: text,
      },
      completedAt: finished ? today : null,
      lastDoneOn: journeyDateKey(today),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is JourneyProgress &&
      other.journeyId == journeyId &&
      other.startedAt == startedAt &&
      other.currentDay == currentDay &&
      listEquals(other.completedDays, completedDays) &&
      mapEquals(other.reflections, reflections) &&
      other.completedAt == completedAt &&
      other.lastDoneOn == lastDoneOn;

  @override
  int get hashCode => Object.hash(
    journeyId,
    startedAt,
    currentDay,
    Object.hashAll(completedDays),
    Object.hashAll(reflections.entries.map((e) => (e.key, e.value))),
    completedAt,
    lastDoneOn,
  );
}

/// A new, unstarted run of [journey] beginning on [now].
JourneyProgress startJourney(Journey journey, DateTime now) =>
    JourneyProgress(journeyId: journey.id, startedAt: now);

/// She runs one journey at a time: she may start another only when none of
/// her runs is still going.
bool canStartJourney(Iterable<JourneyProgress> all) =>
    all.every((run) => run.isFinished);

/// The run that is still going, if any.
JourneyProgress? activeJourney(Iterable<JourneyProgress> all) {
  for (final run in all) {
    if (!run.isFinished) return run;
  }
  return null;
}

/// The content of one journey day, with ids turned into the real cards and
/// quest. Ids that no longer exist are left out.
@immutable
class ResolvedJourneyDay {
  const ResolvedJourneyDay({
    required this.day,
    required this.quotes,
    required this.quest,
    required this.reflection,
  });

  final int day;
  final List<Quote> quotes;
  final Quest? quest;
  final Map<String, String> reflection;
}

/// Day [day] of [journey] resolved against [quotes] and [quests], or null when
/// the journey has no such day.
ResolvedJourneyDay? resolveJourneyDay(
  Journey journey,
  int day,
  List<Quote> quotes,
  List<Quest> quests,
) {
  final plan = journey.planFor(day);
  if (plan == null) return null;
  final quoteById = {for (final quote in quotes) quote.id: quote};
  Quest? quest;
  for (final candidate in quests) {
    if (candidate.id == plan.questId) quest = candidate;
  }
  return ResolvedJourneyDay(
    day: day,
    quotes: [for (final id in plan.quoteIds) ?quoteById[id]],
    quest: quest,
    reflection: plan.reflection,
  );
}
