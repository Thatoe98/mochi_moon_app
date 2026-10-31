import 'dart:math';

import 'package:mochi_moon/core/content/quote.dart';
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

/// Moves the cards from [position] on that fit [moodId] to the front of that
/// part of [cards], keeping the order inside both groups. Cards already
/// swiped stay where they are. Returns [cards] itself when nothing moves.
List<Quote> reorderForMood(List<Quote> cards, int position, String moodId) {
  final rest = cards.sublist(position);
  final fitting = [
    for (final card in rest)
      if (card.moods.contains(moodId)) card,
  ];
  final others = [
    for (final card in rest)
      if (!card.moods.contains(moodId)) card,
  ];
  final reordered = [...fitting, ...others];
  var same = true;
  for (var i = 0; i < rest.length; i++) {
    if (!identical(rest[i], reordered[i])) {
      same = false;
      break;
    }
  }
  return same ? cards : [...cards.sublist(0, position), ...reordered];
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
