import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';
import 'package:mochi_moon/features/custom_cards/application/own_card_providers.dart';
import 'package:mochi_moon/features/custom_cards/domain/own_card.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';
import 'package:mochi_moon/features/widget_bridge/application/widget_providers.dart';

import '../../deck/support/fake_deck_repository.dart';
import '../../widget_bridge/support/fake_widget_publisher.dart';
import '../support/fake_own_cards.dart';

final _own = OwnCard(
  id: 'mine',
  body: 'I am doing my best',
  illustrationId: 'healing_01',
  createdAt: DateTime(2026, 10, 30),
);

const _bundled = Quote(
  id: 'q1',
  text: {'en': 'Bundled card'},
  category: 'self_love',
);

ProviderContainer _container({FakeWidgetPublisher? publisher}) {
  final container = ProviderContainer(
    overrides: [
      deckRepositoryProvider.overrideWithValue(FakeDeckRepository()),
      clockProvider.overrideWithValue(() => DateTime(2026, 10, 31, 9)),
      randomProvider.overrideWithValue(Random(1)),
      dailyCardLimitProvider.overrideWithValue(10),
      reminderLanguageProvider.overrideWithValue('en'),
      ownCardRepositoryProvider.overrideWithValue(
        FakeOwnCardRepository([_own]),
      ),
      quotesProvider.overrideWith((ref) async => [_bundled]),
      if (publisher != null)
        widgetPublisherProvider.overrideWithValue(publisher),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('the card pool holds bundled cards and her own', () async {
    final pool = await _container().read(cardPoolProvider.future);

    expect(pool.map((q) => q.id), ['q1', 'own_mine']);
  });

  test('her card is dealt in the deck rotation', () async {
    final deck = await _container().read(deckProvider.future);

    expect(deck.cards.map((q) => q.id), containsAll(['q1', 'own_mine']));
    final own = deck.cards.firstWhere((q) => q.id == 'own_mine');
    expect(own.category, 'self_love');
    expect(own.textFor('en'), 'I am doing my best');
  });

  test('the home-screen widget can pick her card', () async {
    final publisher = FakeWidgetPublisher();
    final container = _container(publisher: publisher);

    await container.read(widgetSyncProvider.future);

    final texts = publisher.published.single.map((d) => d.text).toSet();
    expect(texts, contains('I am doing my best'));
  });

  test('her picture wins over the category art', () {
    expect(
      AppIllustrations.forCard('self_love', 'healing_01'),
      AppIllustrations.healing,
    );
    expect(
      AppIllustrations.forCard('self_love', 'unknown'),
      AppIllustrations.selfWorth,
    );
    expect(
      AppIllustrations.forCard('self_love', null),
      AppIllustrations.selfWorth,
    );
  });
}
