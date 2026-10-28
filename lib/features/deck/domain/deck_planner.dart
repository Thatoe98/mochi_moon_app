import 'dart:math';

import 'package:mochi_moon/features/deck/domain/deck_action.dart';

/// Cards seen within this window are not repeated while fresh ones remain.
const Duration noRepeatWindow = Duration(days: 30);

/// Orders [quoteIds] for today's deck: random among cards not seen in the last
/// 30 days, then (once those run out) the least recently seen first.
List<String> planDeck({
  required List<String> quoteIds,
  required List<DeckEvent> history,
  required DateTime now,
  required Random random,
}) {
  final lastSeen = <String, DateTime>{};
  for (final event in history) {
    final seen = lastSeen[event.quoteId];
    if (seen == null || event.at.isAfter(seen)) {
      lastSeen[event.quoteId] = event.at;
    }
  }

  final cutoff = now.subtract(noRepeatWindow);
  final fresh = <String>[];
  final stale = <String>[];
  for (final id in quoteIds) {
    final seen = lastSeen[id];
    (seen == null || seen.isBefore(cutoff) ? fresh : stale).add(id);
  }

  fresh.shuffle(random);
  stale.sort((a, b) => lastSeen[a]!.compareTo(lastSeen[b]!));
  return [...fresh, ...stale];
}

DateTime _day(DateTime t) => DateTime(t.year, t.month, t.day);

/// Number of cards completed on the local day of [now].
int completedOnDay(List<DeckEvent> history, DateTime now) {
  final today = _day(now);
  return history.where((e) => _day(e.at) == today).length;
}

/// Consecutive local days with at least one completed card, ending today. A
/// streak that reached yesterday stays alive until today ends.
int currentStreak(List<DeckEvent> history, DateTime now) {
  final days = history.map((e) => _day(e.at)).toSet();
  var day = _day(now);
  if (!days.contains(day)) {
    day = DateTime(day.year, day.month, day.day - 1);
  }
  var streak = 0;
  while (days.contains(day)) {
    streak++;
    day = DateTime(day.year, day.month, day.day - 1);
  }
  return streak;
}
