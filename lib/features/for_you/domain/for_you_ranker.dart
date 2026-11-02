import 'dart:convert';
import 'dart:math';

import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/deck/domain/deck_planner.dart';

/// Right-swipes needed before the For You deck can rank (PRD §6.9).
const forYouMinSaved = 10;

/// A selected mood pulls the preference toward its centroid (PRD §7.2).
const _moodWeight = 2.0;
const _halfLifeDays = 14;

/// Every 10 slots, these three are exploration (30%).
const _explorationSlots = {2, 5, 8};

double _weight(DeckAction action) => switch (action) {
  DeckAction.saved => 1.0,
  DeckAction.shared => 1.5,
  DeckAction.skipped => -0.3,
};

/// A base64 int8 vector as a length-1 list, or null when [encoded] is empty.
List<double>? decodeEmbedding(String? encoded) {
  if (encoded == null || encoded.isEmpty) return null;
  final bytes = base64Decode(encoded).buffer.asInt8List();
  return normalize([for (final b in bytes) b / 127]);
}

List<double> normalize(List<double> v) {
  var sum = 0.0;
  for (final x in v) {
    sum += x * x;
  }
  if (sum == 0) return v;
  final length = sqrt(sum);
  return [for (final x in v) x / length];
}

double cosine(List<double> a, List<double> b) {
  var dot = 0.0;
  for (var i = 0; i < a.length && i < b.length; i++) {
    dot += a[i] * b[i];
  }
  return dot;
}

/// Right-swipes ("This is me") in [history].
int savedCount(List<DeckEvent> history) =>
    history.where((e) => e.action == DeckAction.saved).length;

/// Her preference vector (PRD §7.2): the weighted sum of the cards she saved,
/// shared and skipped (older ones count less), plus [moodCentroid] when she
/// picked a mood today. Null when there is nothing to go on.
List<double>? preferenceVector({
  required Map<String, Quote> byId,
  required List<DeckEvent> history,
  required DateTime now,
  List<double>? moodCentroid,
}) {
  List<double>? sum;
  void add(List<double> v, double w) {
    sum ??= List<double>.filled(v.length, 0);
    for (var i = 0; i < v.length && i < sum!.length; i++) {
      sum![i] += v[i] * w;
    }
  }

  for (final event in history) {
    final vector = decodeEmbedding(byId[event.quoteId]?.embedding);
    if (vector == null) continue;
    final days = now.difference(event.at).inMinutes / (60 * 24);
    final decay = pow(0.5, max(0, days) / _halfLifeDays).toDouble();
    add(vector, _weight(event.action) * decay);
  }
  if (moodCentroid != null) add(moodCentroid, _moodWeight);
  final result = sum;
  if (result == null || result.every((x) => x == 0)) return null;
  return normalize(result);
}

/// Orders [quotes] for the For You deck, or returns null while she has fewer
/// than [forYouMinSaved] right-swipes (PRD §6.9).
///
/// Cards not seen in the last 30 days come first: 70% the most similar to her
/// preference, 30% exploration from categories she has not saved. Cards seen
/// recently follow, then cards with no embedding (her own cards).
List<String>? rankForYou({
  required List<Quote> quotes,
  required List<DeckEvent> history,
  required DateTime now,
  required Random random,
  List<double>? moodCentroid,
}) {
  if (savedCount(history) < forYouMinSaved) return null;
  final byId = {for (final q in quotes) q.id: q};
  final preference = preferenceVector(
    byId: byId,
    history: history,
    now: now,
    moodCentroid: moodCentroid,
  );
  if (preference == null) return null;

  final lastSeen = <String, DateTime>{};
  final liked = <String>{};
  for (final e in history) {
    final seen = lastSeen[e.quoteId];
    if (seen == null || e.at.isAfter(seen)) lastSeen[e.quoteId] = e.at;
    final category = byId[e.quoteId]?.category;
    if (category != null &&
        (e.action == DeckAction.saved || e.action == DeckAction.shared)) {
      liked.add(category);
    }
  }

  final cutoff = now.subtract(noRepeatWindow);
  final score = <String, double>{};
  final fresh = <Quote>[];
  final stale = <Quote>[];
  final plain = <Quote>[];
  for (final q in quotes) {
    final vector = decodeEmbedding(q.embedding);
    if (vector == null) {
      plain.add(q);
      continue;
    }
    score[q.id] = cosine(preference, vector);
    final seen = lastSeen[q.id];
    (seen == null || seen.isBefore(cutoff) ? fresh : stale).add(q);
  }

  fresh.sort((a, b) => score[b.id]!.compareTo(score[a.id]!));
  final explore = [
    for (final q in fresh)
      if (!liked.contains(q.category)) q,
  ]..shuffle(random);
  final used = <String>{};
  final out = <String>[];
  var top = 0;
  var exploring = 0;
  while (out.length < fresh.length) {
    final wantExplore = _explorationSlots.contains(out.length % 10);
    Quote? pick;
    if (wantExplore) {
      while (exploring < explore.length &&
          used.contains(explore[exploring].id)) {
        exploring++;
      }
      if (exploring < explore.length) pick = explore[exploring];
    }
    if (pick == null) {
      while (used.contains(fresh[top].id)) {
        top++;
      }
      pick = fresh[top];
    }
    used.add(pick.id);
    out.add(pick.id);
  }
  stale.sort((a, b) => lastSeen[a.id]!.compareTo(lastSeen[b.id]!));
  return [...out, ...stale.map((q) => q.id), ...plain.map((q) => q.id)];
}
