import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/ritual/presentation/today_screen.dart';

import '../../deck/support/fake_deck_repository.dart';

const _deckPage = 'deck page';

Widget _app(FakeDeckRepository repo, {double textScale = 1}) => ProviderScope(
  overrides: [
    deckRepositoryProvider.overrideWithValue(repo),
    clockProvider.overrideWithValue(() => DateTime(2026, 10, 28, 12)),
    quotesProvider.overrideWith(
      (ref) => Future.value(const [
        Quote(id: 'q1', text: {'en': 'Soft moon'}, category: 'self_love'),
      ]),
    ),
  ],
  child: MaterialApp.router(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(textScale)),
      child: child!,
    ),
    routerConfig: GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const TodayScreen()),
        GoRoute(path: AppRoutes.deck, builder: (_, _) => const Text(_deckPage)),
      ],
    ),
  ),
);

DeckEvent _done(int id, DateTime at) =>
    DeckEvent(id: id, quoteId: 'q$id', action: DeckAction.skipped, at: at);

void main() {
  testWidgets('invites her to start a streak when she has none', (
    tester,
  ) async {
    await tester.pumpWidget(_app(FakeDeckRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Start your self-love streak today'), findsOneWidget);
  });

  testWidgets('shows the streak once she has one', (tester) async {
    final repo = FakeDeckRepository([
      _done(1, DateTime(2026, 10, 27, 9)),
      _done(2, DateTime(2026, 10, 28, 9)),
    ]);
    await tester.pumpWidget(_app(repo));
    await tester.pumpAndSettle();

    expect(find.text('2 days of self-love'), findsOneWidget);
  });

  testWidgets('the button opens the deck', (tester) async {
    await tester.pumpWidget(_app(FakeDeckRepository()));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Read today's cards"));
    await tester.pumpAndSettle();

    expect(find.text(_deckPage), findsOneWidget);
  });

  testWidgets('survives 1.3x text without overflow', (tester) async {
    await tester.pumpWidget(_app(FakeDeckRepository(), textScale: 1.3));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
