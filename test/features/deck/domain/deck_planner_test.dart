import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/deck/domain/deck_planner.dart';

DeckEvent event(String quoteId, DateTime at, {int id = 0}) =>
    DeckEvent(id: id, quoteId: quoteId, action: DeckAction.skipped, at: at);

Quote card(String id, [List<String> moods = const []]) =>
    Quote(id: id, text: {'en': id}, category: 'calm', moods: moods);

void main() {
  final now = DateTime(2026, 10, 28, 12);

  group('reorderForMood', () {
    test('puts the cards that fit the mood first, keeping order', () {
      final cards = [
        card('a'),
        card('b', ['sad']),
        card('c'),
        card('d', ['sad', 'tired']),
      ];
      final result = reorderForMood(cards, 0, 'sad');
      expect(result.map((q) => q.id), ['b', 'd', 'a', 'c']);
    });

    test('leaves the swiped cards where they are', () {
      final cards = [
        card('a'),
        card('b'),
        card('c', ['calm']),
        card('d'),
      ];
      final result = reorderForMood(cards, 2, 'calm');
      expect(result.map((q) => q.id), ['a', 'b', 'c', 'd']);

      final result2 = reorderForMood(cards, 1, 'calm');
      expect(result2.map((q) => q.id), ['a', 'c', 'b', 'd']);
    });

    test('returns the same list when nothing moves', () {
      final cards = [
        card('a', ['sad']),
        card('b'),
      ];
      expect(identical(reorderForMood(cards, 0, 'sad'), cards), isTrue);
      expect(identical(reorderForMood(cards, 0, 'happy'), cards), isTrue);
    });
  });

  group('planDeck', () {
    test('returns every quote exactly once', () {
      final plan = planDeck(
        quoteIds: ['a', 'b', 'c', 'd'],
        history: [event('b', DateTime(2026, 10, 20))],
        now: now,
        random: Random(1),
      );
      expect(plan, unorderedEquals(['a', 'b', 'c', 'd']));
    });

    test('puts cards seen within 30 days after unseen ones', () {
      final plan = planDeck(
        quoteIds: ['a', 'b', 'c'],
        history: [event('a', DateTime(2026, 10, 27))],
        now: now,
        random: Random(1),
      );
      expect(plan.last, 'a');
    });

    test('cards seen more than 30 days ago count as fresh again', () {
      final plan = planDeck(
        quoteIds: ['a', 'b'],
        history: [event('a', DateTime(2026, 9)), event('b', now)],
        now: now,
        random: Random(1),
      );
      expect(plan, ['a', 'b']);
    });

    test('once fresh cards run out, least recently seen comes first', () {
      final plan = planDeck(
        quoteIds: ['a', 'b', 'c'],
        history: [
          event('a', DateTime(2026, 10, 25)),
          event('b', DateTime(2026, 10, 10)),
          event('c', DateTime(2026, 10, 20)),
        ],
        now: now,
        random: Random(1),
      );
      expect(plan, ['b', 'c', 'a']);
    });

    test('uses the latest sighting when a card was seen repeatedly', () {
      final plan = planDeck(
        quoteIds: ['a', 'b'],
        history: [
          event('a', DateTime(2026, 10), id: 1),
          event('a', DateTime(2026, 10, 27), id: 2),
          event('b', DateTime(2026, 10, 15), id: 3),
        ],
        now: now,
        random: Random(1),
      );
      expect(plan, ['b', 'a']);
    });

    test('is deterministic for a seeded random', () {
      List<String> plan() => planDeck(
        quoteIds: List.generate(20, (i) => 'q$i'),
        history: const [],
        now: now,
        random: Random(42),
      );
      expect(plan(), plan());
    });

    test('ignores history for quotes that no longer exist', () {
      final plan = planDeck(
        quoteIds: ['a'],
        history: [event('gone', DateTime(2026, 10, 27))],
        now: now,
        random: Random(1),
      );
      expect(plan, ['a']);
    });
  });

  group('completedOnDay', () {
    test('counts only cards from the same local day', () {
      final history = [
        event('a', DateTime(2026, 10, 28, 0, 1)),
        event('b', DateTime(2026, 10, 28, 23, 59)),
        event('c', DateTime(2026, 10, 27, 23, 59)),
      ];
      expect(completedOnDay(history, now), 2);
    });

    test('is zero with no history', () {
      expect(completedOnDay(const [], now), 0);
    });
  });

  group('currentStreak', () {
    test('is zero with no history', () {
      expect(currentStreak(const [], now), 0);
    });

    test('counts consecutive days ending today', () {
      final history = [
        event('a', DateTime(2026, 10, 28, 8)),
        event('b', DateTime(2026, 10, 27, 8)),
        event('c', DateTime(2026, 10, 26, 8)),
      ];
      expect(currentStreak(history, now), 3);
    });

    test('several cards on one day count as one day', () {
      final history = [
        event('a', DateTime(2026, 10, 28, 8)),
        event('b', DateTime(2026, 10, 28, 9)),
      ];
      expect(currentStreak(history, now), 1);
    });

    test('stays alive when the last card was yesterday', () {
      final history = [
        event('a', DateTime(2026, 10, 27, 8)),
        event('b', DateTime(2026, 10, 26, 8)),
      ];
      expect(currentStreak(history, now), 2);
    });

    test('resets after a missed day', () {
      final history = [
        event('a', DateTime(2026, 10, 28, 8)),
        event('b', DateTime(2026, 10, 26, 8)),
      ];
      expect(currentStreak(history, now), 1);
    });

    test('is zero when the last card was two days ago', () {
      expect(currentStreak([event('a', DateTime(2026, 10, 26))], now), 0);
    });

    test('crosses month boundaries', () {
      final history = [
        event('a', DateTime(2026, 11, 1, 8)),
        event('b', DateTime(2026, 10, 31, 8)),
      ];
      expect(currentStreak(history, DateTime(2026, 11, 1, 20)), 2);
    });
  });
}
