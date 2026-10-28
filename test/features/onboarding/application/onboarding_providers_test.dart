import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/onboarding/application/onboarding_providers.dart';

import '../../deck/support/fake_deck_repository.dart';
import '../support/fake_onboarding_repository.dart';

final _quotes = [
  const Quote(id: 'a', text: {'en': 'One'}, category: 'calm'),
  const Quote(id: 'b', text: {'en': 'Two'}, category: 'healing'),
  const Quote(id: 'c', text: {'en': 'Three'}, category: 'confidence'),
  const Quote(id: 'd', text: {'en': 'Four'}, category: 'calm'),
];

ProviderContainer _container({
  FakeOnboardingRepository? onboarding,
  FakeDeckRepository? deck,
  bool complete = false,
}) {
  final container = ProviderContainer(
    overrides: [
      initialOnboardingCompleteProvider.overrideWithValue(complete),
      onboardingRepositoryProvider.overrideWithValue(
        onboarding ?? FakeOnboardingRepository(),
      ),
      deckRepositoryProvider.overrideWithValue(deck ?? FakeDeckRepository()),
      clockProvider.overrideWithValue(() => DateTime(2026, 10, 28, 12)),
      quotesProvider.overrideWith((ref) async => _quotes),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('onboardingCompleteProvider', () {
    test('starts from the saved flag', () {
      expect(_container().read(onboardingCompleteProvider), isFalse);
      expect(_container(complete: true).read(onboardingCompleteProvider), true);
    });

    test('complete saves the flag and flips the state', () async {
      final repo = FakeOnboardingRepository();
      final container = _container(onboarding: repo);

      await container.read(onboardingCompleteProvider.notifier).complete();

      expect(container.read(onboardingCompleteProvider), isTrue);
      expect(repo.complete, isTrue);
    });

    test('a flag that cannot be saved never traps the user', () async {
      final repo = FakeOnboardingRepository(error: Exception('disk full'));
      final container = _container(onboarding: repo);

      await container.read(onboardingCompleteProvider.notifier).complete();

      expect(container.read(onboardingCompleteProvider), isTrue);
      expect(repo.complete, isFalse);
    });
  });

  group('sampleDeckProvider', () {
    test('deals three cards from different categories', () async {
      final container = _container();
      final state = await container.read(sampleDeckProvider.future);

      expect(state.cards.map((q) => q.id), ['a', 'b', 'c']);
      expect(state.position, 0);
      expect(state.canUndo, isFalse);
      expect(state.isDone, isFalse);
    });

    test('complete records the top card and advances', () async {
      final repo = FakeDeckRepository();
      final container = _container(deck: repo);
      await container.read(sampleDeckProvider.future);

      await container
          .read(sampleDeckProvider.notifier)
          .complete(DeckAction.saved);

      final state = container.read(sampleDeckProvider).requireValue;
      expect(state.position, 1);
      expect(state.canUndo, isTrue);
      expect(repo.events.single.quoteId, 'a');
      expect(repo.events.single.action, DeckAction.saved);
    });

    test(
      'is done after the third card, and complete then does nothing',
      () async {
        final repo = FakeDeckRepository();
        final container = _container(deck: repo);
        await container.read(sampleDeckProvider.future);
        final notifier = container.read(sampleDeckProvider.notifier);

        for (var i = 0; i < 4; i++) {
          await notifier.complete(DeckAction.skipped);
        }

        expect(container.read(sampleDeckProvider).requireValue.isDone, isTrue);
        expect(repo.events, hasLength(3));
      },
    );

    test('undo takes back the last card, one level only', () async {
      final repo = FakeDeckRepository();
      final container = _container(deck: repo);
      await container.read(sampleDeckProvider.future);
      final notifier = container.read(sampleDeckProvider.notifier);

      await notifier.complete(DeckAction.saved);
      await notifier.complete(DeckAction.saved);
      await notifier.undo();
      await notifier.undo();

      final state = container.read(sampleDeckProvider).requireValue;
      expect(state.position, 1);
      expect(state.canUndo, isFalse);
      expect(repo.events.map((e) => e.quoteId), ['a']);
    });

    test('resumes after cards recorded in an earlier run', () async {
      final repo = FakeDeckRepository([
        DeckEvent(
          id: 1,
          quoteId: 'a',
          action: DeckAction.saved,
          at: DateTime(2026, 10, 28, 9),
        ),
        DeckEvent(
          id: 2,
          quoteId: 'b',
          action: DeckAction.skipped,
          at: DateTime(2026, 10, 28, 9),
        ),
      ]);
      final container = _container(deck: repo);
      final state = await container.read(sampleDeckProvider.future);

      expect(state.position, 2);

      await container
          .read(sampleDeckProvider.notifier)
          .complete(DeckAction.saved);
      expect(repo.events.map((e) => e.quoteId), ['a', 'b', 'c']);
    });

    test('is done at once when there is no content to show', () async {
      final container = ProviderContainer(
        overrides: [
          initialOnboardingCompleteProvider.overrideWithValue(false),
          deckRepositoryProvider.overrideWithValue(FakeDeckRepository()),
          quotesProvider.overrideWith((ref) async => <Quote>[]),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(sampleDeckProvider.future);

      expect(state.cards, isEmpty);
      expect(state.isDone, isTrue);
    });
  });
}
