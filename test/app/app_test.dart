import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/app/app.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/journal/application/journal_providers.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';
import 'package:mochi_moon/features/widget_bridge/application/widget_providers.dart';

import '../features/deck/support/fake_deck_repository.dart';
import '../features/journal/support/fake_journal_repository.dart';
import '../features/settings/support/fake_reminder.dart';
import '../features/widget_bridge/support/fake_widget_publisher.dart';

const _quote = Quote(
  id: 'q_test',
  text: {'en': 'I am enough.'},
  category: 'self_love',
);

Widget _app({Future<List<Quote>> Function()? quotes}) => ProviderScope(
  overrides: [
    deckRepositoryProvider.overrideWithValue(FakeDeckRepository()),
    journalRepositoryProvider.overrideWithValue(FakeJournalRepository()),
    reminderSettingsRepositoryProvider.overrideWithValue(
      FakeReminderSettingsRepository(),
    ),
    reminderSchedulerProvider.overrideWithValue(FakeReminderScheduler()),
    widgetPublisherProvider.overrideWithValue(FakeWidgetPublisher()),
    quotesProvider.overrideWith(
      (ref) => quotes?.call() ?? Future.value([_quote]),
    ),
  ],
  child: const MochiMoonApp(),
);

void main() {
  testWidgets('opens on the deck tab and shows a quote', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.text('I am enough.'), findsOneWidget);
    expect(find.text('Deck'), findsOneWidget);
  });

  testWidgets('shows a loading state while quotes load', (tester) async {
    await tester.pumpWidget(
      _app(
        quotes: () =>
            Future.delayed(const Duration(seconds: 1), () => [_quote]),
      ),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('shows an error state with retry', (tester) async {
    await tester.pumpWidget(
      _app(quotes: () => Future.error(Exception('boom'))),
    );
    await tester.pumpAndSettle();

    expect(find.text('Something wobbled'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('shows an empty state when there are no quotes', (tester) async {
    await tester.pumpWidget(_app(quotes: () => Future.value(<Quote>[])));
    await tester.pumpAndSettle();

    expect(find.text('Nothing here yet'), findsOneWidget);
  });

  testWidgets('bottom tabs navigate between Deck, Cosmic and Me', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cosmic'));
    await tester.pumpAndSettle();
    expect(find.text('Your stars are warming up.'), findsOneWidget);

    await tester.tap(find.text('Me'));
    await tester.pumpAndSettle();
    expect(find.text('Your journal'), findsOneWidget);
  });

  testWidgets('Me opens the journal', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Me'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Your journal'));
    await tester.pumpAndSettle();

    expect(find.text('Nothing saved yet'), findsOneWidget);
  });
}
