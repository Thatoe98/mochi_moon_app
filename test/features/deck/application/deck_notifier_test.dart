import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/card_of_the_day.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';

import '../support/fake_deck_repository.dart';

Quote quote(String id, [List<String> moods = const []]) =>
    Quote(id: id, text: {'en': 'text $id'}, category: 'worth', moods: moods);

void main() {
  final now = DateTime(2026, 10, 28, 12);

  ProviderContainer makeContainer({
    FakeDeckRepository? repo,
    int limit = 10,
    int quoteCount = 20,
    List<String> sadIds = const [],
    DateTime Function()? clock,
  }) {
    final container = ProviderContainer(
      overrides: [
        deckRepositoryProvider.overrideWithValue(repo ?? FakeDeckRepository()),
        clockProvider.overrideWithValue(clock ?? () => now),
        randomProvider.overrideWithValue(Random(1)),
        dailyCardLimitProvider.overrideWithValue(limit),
        quotesProvider.overrideWith(
          (ref) async => [
            for (var i = 0; i < quoteCount; i++)
              quote('q$i', sadIds.contains('q$i') ? ['sad'] : const []),
          ],
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('applyMood', () {
    test('moves the cards that fit the mood to the front', () async {
      final container = makeContainer(
        quoteCount: 3,
        sadIds: const ['q0', 'q1', 'q2'],
      );
      final before = await container.read(deckProvider.future);
      final ids = before.cards.map((q) => q.id).toList();

      container.read(deckProvider.notifier).applyMood(Mood.sad);

      // Every card fits, so nothing moves and the list is the same.
      expect(
        container.read(deckProvider).requireValue.cards.map((q) => q.id),
        ids,
      );
    });

    test('puts the one fitting card on top and keeps the rest', () async {
      final container = makeContainer(quoteCount: 6, sadIds: const ['q5']);
      final before = await container.read(deckProvider.future);
      final others = before.cards.where((q) => q.id != 'q5').map((q) => q.id);

      container.read(deckProvider.notifier).applyMood(Mood.sad);

      final after = container.read(deckProvider).requireValue.cards;
      expect(after.first.id, 'q5');
      expect(after.skip(1).map((q) => q.id), others);
    });

    test('choosing the same mood again changes nothing', () async {
      final container = makeContainer(quoteCount: 6, sadIds: const ['q5']);
      await container.read(deckProvider.future);
      final notifier = container.read(deckProvider.notifier)
        ..applyMood(Mood.sad);
      final first = container.read(deckProvider).requireValue.cards;

      notifier.applyMood(Mood.sad);

      expect(
        identical(container.read(deckProvider).requireValue.cards, first),
        isTrue,
      );
    });
  });

  test('deals up to the daily limit', () async {
    final container = makeContainer();
    final state = await container.read(deckProvider.future);

    expect(state.cards, hasLength(10));
    expect(state.position, 0);
    expect(state.completedToday, 0);
    expect(state.streak, 0);
    expect(state.canUndo, isFalse);
  });

  test("only deals what is left of today's limit", () async {
    final repo = FakeDeckRepository([
      for (var i = 0; i < 4; i++)
        DeckEvent(
          id: i,
          quoteId: 'q$i',
          action: DeckAction.skipped,
          at: DateTime(2026, 10, 28, 8),
        ),
    ]);
    final container = makeContainer(repo: repo);
    final state = await container.read(deckProvider.future);

    expect(state.cards, hasLength(6));
    expect(state.completedToday, 4);
    expect(state.streak, 1);
    expect(state.cards.map((q) => q.id), isNot(contains('q0')));
  });

  test('deals nothing once the limit is reached', () async {
    final repo = FakeDeckRepository([
      for (var i = 0; i < 3; i++)
        DeckEvent(
          id: i,
          quoteId: 'q$i',
          action: DeckAction.saved,
          at: DateTime(2026, 10, 28, 8),
        ),
    ]);
    final container = makeContainer(repo: repo, limit: 3);
    final state = await container.read(deckProvider.future);

    expect(state.cards, isEmpty);
    expect(state.isDone, isTrue);
  });

  group("today's card of the day", () {
    final cardId = cardOfTheDay([
      for (var i = 0; i < 20; i++) quote('q$i'),
    ], now)!.id;

    test('is dealt first, matching the widget and the reminder', () async {
      final container = makeContainer();
      final state = await container.read(deckProvider.future);

      expect(state.cards.first.id, cardId);
      expect(state.cards.map((q) => q.id).toSet(), hasLength(10));
    });

    test('is not dealt again once completed today', () async {
      final repo = FakeDeckRepository([
        DeckEvent(
          id: 1,
          quoteId: cardId,
          action: DeckAction.saved,
          at: DateTime(2026, 10, 28, 8),
        ),
      ]);
      final container = makeContainer(repo: repo);
      final state = await container.read(deckProvider.future);

      expect(state.cards.map((q) => q.id), isNot(contains(cardId)));
    });

    test('still respects the daily limit', () async {
      final container = makeContainer(limit: 1);
      final state = await container.read(deckProvider.future);

      expect(state.cards.map((q) => q.id), [cardId]);
    });
  });

  group('when the day turns', () {
    final tonight = DateTime(2026, 10, 28, 23, 59, 30);

    FakeDeckRepository finishedToday() => FakeDeckRepository([
      for (var i = 0; i < 3; i++)
        DeckEvent(
          id: i,
          quoteId: 'q$i',
          action: DeckAction.saved,
          at: DateTime(2026, 10, 28, 20),
        ),
    ]);

    test('refreshIfNewDay deals a fresh deck, keeping the streak', () async {
      var clock = tonight;
      final container = makeContainer(
        repo: finishedToday(),
        limit: 3,
        clock: () => clock,
      )..listen(deckProvider, (_, _) {});
      final before = await container.read(deckProvider.future);
      expect(before.isDone, isTrue);

      clock = DateTime(2026, 10, 29, 8);
      container.read(deckProvider.notifier).refreshIfNewDay();
      final after = await container.read(deckProvider.future);

      expect(after.completedToday, 0);
      expect(after.cards, hasLength(3));
      expect(after.streak, 1);
    });

    test('refreshIfNewDay leaves the same day alone', () async {
      final container = makeContainer(
        repo: finishedToday(),
        limit: 3,
        clock: () => tonight,
      )..listen(deckProvider, (_, _) {});
      final before = await container.read(deckProvider.future);

      container.read(deckProvider.notifier).refreshIfNewDay();
      final after = await container.read(deckProvider.future);

      expect(identical(after.cards, before.cards), isTrue);
    });

    testWidgets('a deck left open past midnight is dealt again', (
      tester,
    ) async {
      var clock = tonight;
      final container = makeContainer(
        repo: finishedToday(),
        limit: 3,
        clock: () => clock,
      )..listen(deckProvider, (_, _) {});
      await tester.pump();
      expect(container.read(deckProvider).value?.completedToday, 3);

      clock = DateTime(2026, 10, 29, 0, 0, 5);
      await tester.pump(const Duration(seconds: 40));
      await tester.pump();

      expect(container.read(deckProvider).value?.completedToday, 0);
      expect(container.read(deckProvider).value?.cards, hasLength(3));

      // The test binding checks for pending timers before the teardown runs.
      container.dispose();
    });
  });

  test('never deals more cards than exist', () async {
    final container = makeContainer(quoteCount: 4);
    final state = await container.read(deckProvider.future);
    expect(state.cards, hasLength(4));
  });

  test('complete records the top card and advances', () async {
    final repo = FakeDeckRepository();
    final container = makeContainer(repo: repo);
    final first = (await container.read(deckProvider.future)).cards.first;

    await container.read(deckProvider.notifier).complete(DeckAction.saved);

    final state = container.read(deckProvider).requireValue;
    expect(state.position, 1);
    expect(state.remaining, 9);
    expect(state.completedToday, 1);
    expect(state.streak, 1);
    expect(state.canUndo, isTrue);
    expect(repo.events.single.quoteId, first.id);
    expect(repo.events.single.action, DeckAction.saved);
  });

  test('undo reverts the last card, one level only', () async {
    final repo = FakeDeckRepository();
    final container = makeContainer(repo: repo);
    await container.read(deckProvider.future);
    final notifier = container.read(deckProvider.notifier);

    await notifier.complete(DeckAction.skipped);
    await notifier.complete(DeckAction.skipped);
    await notifier.undo();

    var state = container.read(deckProvider).requireValue;
    expect(state.position, 1);
    expect(state.completedToday, 1);
    expect(state.canUndo, isFalse);
    expect(repo.events, hasLength(1));

    await notifier.undo();
    state = container.read(deckProvider).requireValue;
    expect(state.position, 1);
    expect(repo.events, hasLength(1));
  });

  test('complete does nothing when the deck is done', () async {
    final repo = FakeDeckRepository();
    final container = makeContainer(repo: repo, limit: 1);
    await container.read(deckProvider.future);
    final notifier = container.read(deckProvider.notifier);

    await notifier.complete(DeckAction.skipped);
    await notifier.complete(DeckAction.skipped);

    expect(repo.events, hasLength(1));
    expect(container.read(deckProvider).requireValue.isDone, isTrue);
  });
}
