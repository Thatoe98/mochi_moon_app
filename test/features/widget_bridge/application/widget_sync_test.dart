import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/features/custom_cards/application/own_card_providers.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';
import 'package:mochi_moon/features/widget_bridge/application/widget_providers.dart';
import 'package:mochi_moon/features/widget_bridge/domain/widget_day.dart';

import '../../custom_cards/support/fake_own_cards.dart';
import '../support/fake_widget_publisher.dart';

const _quote = Quote(
  id: 'q1',
  text: {'en': 'I am enough.\nTruly.'},
  category: 'self_love',
);

class _FailingPublisher implements WidgetPublisher {
  @override
  Future<void> publish(List<WidgetDay> days) =>
      Future.error(Exception('no widget host'));
}

ProviderContainer _container({
  required WidgetPublisher publisher,
  List<Quote> quotes = const [_quote],
}) {
  final container = ProviderContainer(
    overrides: [
      widgetPublisherProvider.overrideWithValue(publisher),
      reminderLanguageProvider.overrideWithValue('en'),
      clockProvider.overrideWithValue(() => DateTime(2026, 10, 28, 9)),
      ownCardRepositoryProvider.overrideWithValue(FakeOwnCardRepository()),
      quotesProvider.overrideWith((ref) => Future.value(quotes)),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('publishes the next two weeks of cards', () async {
    final publisher = FakeWidgetPublisher();
    final container = _container(publisher: publisher);

    await container.read(widgetSyncProvider.future);

    expect(publisher.published, hasLength(1));
    expect(publisher.published.single, hasLength(widgetWindowDays));
    expect(publisher.published.single.first.text, 'I am enough.');
    expect(publisher.published.single.first.date, DateTime(2026, 10, 28));
  });

  test('publishes nothing without usable cards', () async {
    final publisher = FakeWidgetPublisher();
    final container = _container(publisher: publisher, quotes: const []);

    await container.read(widgetSyncProvider.future);

    expect(publisher.published, isEmpty);
  });

  test('a failing widget never breaks the app', () async {
    final container = _container(publisher: _FailingPublisher());

    await expectLater(container.read(widgetSyncProvider.future), completes);
  });
}
