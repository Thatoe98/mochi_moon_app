import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/for_you/domain/for_you_ranker.dart';

/// A 4-number vector as an embedding.
String emb(List<int> v) =>
    base64Encode(Int8List.fromList(v).buffer.asUint8List());

Quote quote(String id, String category, List<int>? v) => Quote(
  id: id,
  text: {'en': id},
  category: category,
  embedding: v == null ? null : emb(v),
);

final now = DateTime(2026, 11, 2, 12);
var _id = 0;
DeckEvent event(String quoteId, DeckAction action, {int daysAgo = 0}) =>
    DeckEvent(
      id: _id++,
      quoteId: quoteId,
      action: action,
      at: now.subtract(Duration(days: daysAgo)),
    );

void main() {
  // Direction A (1,0): the ones she saves. B (0,1): the opposite taste.
  final liked = [
    for (var i = 0; i < 10; i++) quote('a$i', 'self_love', [100, 5, 0, 0]),
  ];
  final history = [for (final q in liked) event(q.id, DeckAction.saved)];

  test('no ranking before 10 right-swipes', () {
    final few = history.take(9).toList();
    expect(
      rankForYou(quotes: liked, history: few, now: now, random: Random(1)),
      isNull,
    );
    expect(savedCount(few), 9);
  });

  test('similar cards come first; recently seen and own cards last', () {
    final pool = [
      ...liked,
      quote('near', 'self_love', [90, 10, 0, 0]),
      quote('far', 'self_love', [-100, 0, 0, 0]),
      quote('own', 'own', null),
    ];
    final ids = rankForYou(
      quotes: pool,
      history: history,
      now: now,
      random: Random(1),
    )!;
    expect(ids.first, 'near');
    expect(ids.indexOf('near'), lessThan(ids.indexOf('far')));
    // The ten cards she just saw are in the 30-day window: after the fresh ones.
    expect(ids.indexOf('far'), lessThan(ids.indexOf('a0')));
    expect(ids.last, 'own');
    expect(ids.toSet(), pool.map((q) => q.id).toSet());
    expect(ids, hasLength(pool.length));
  });

  test('about 30% of the first cards explore categories she has not saved', () {
    final fresh = [
      for (var i = 0; i < 20; i++)
        quote('n$i', 'self_love', [100 - i, i, 0, 0]),
      for (var i = 0; i < 20; i++)
        quote('x$i', 'courage', [-100, 50 + i, 0, 0]),
    ];
    final ids = rankForYou(
      quotes: [...liked, ...fresh],
      history: history,
      now: now,
      random: Random(1),
    )!;
    final firstTen = ids.take(10).toList();
    expect(firstTen.where((id) => id.startsWith('x')), hasLength(3));
    expect(firstTen.where((id) => id.startsWith('n')), hasLength(7));
  });

  test('a skipped taste counts against a card, old swipes count less', () {
    final byId = {for (final q in liked) q.id: q};
    final recent = preferenceVector(
      byId: byId,
      history: [event('a0', DeckAction.saved)],
      now: now,
    )!;
    final skipped = preferenceVector(
      byId: byId,
      history: [event('a0', DeckAction.saved), event('a1', DeckAction.skipped)],
      now: now,
    )!;
    // Both point the same way: skip only has a small weight.
    expect(cosine(recent, skipped), greaterThan(0.99));
    expect(preferenceVector(byId: byId, history: const [], now: now), isNull);
  });

  test('the mood centroid pulls the preference', () {
    final byId = {for (final q in liked) q.id: q};
    final mood = decodeEmbedding(emb([0, 100, 0, 0]));
    final plain = preferenceVector(
      byId: byId,
      history: [event('a0', DeckAction.saved)],
      now: now,
    )!;
    final pulled = preferenceVector(
      byId: byId,
      history: [event('a0', DeckAction.saved)],
      now: now,
      moodCentroid: mood,
    )!;
    expect(pulled[1], greaterThan(plain[1]));
  });
}
