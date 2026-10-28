import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';

import '../support/fake_deck_repository.dart';

Quote quote(String id) =>
    Quote(id: id, text: {'en': 'text $id'}, category: 'worth');

void main() {
  final now = DateTime(2026, 10, 28, 12);

  ProviderContainer makeContainer({
    FakeDeckRepository? repo,
    int limit = 10,
    int quoteCount = 20,
  }) {
    final container = ProviderContainer(
      overrides: [
        deckRepositoryProvider.overrideWithValue(repo ?? FakeDeckRepository()),
        clockProvider.overrideWithValue(() => now),
        randomProvider.overrideWithValue(Random(1)),
        dailyCardLimitProvider.overrideWithValue(limit),
        quotesProvider.overrideWith(
          (ref) async => [for (var i = 0; i < quoteCount; i++) quote('q$i')],
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

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
