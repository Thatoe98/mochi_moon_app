import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/explore/application/tips_providers.dart';
import 'package:mochi_moon/features/explore/domain/explore_feature.dart';
import 'package:mochi_moon/features/explore/presentation/explore_screen.dart';
import 'package:mochi_moon/features/explore/presentation/tour_prompt_card.dart';
import 'package:mochi_moon/features/explore/presentation/tour_screen.dart';

import '../support/fake_tips_repository.dart';

Widget _host(FakeTipsRepository tips, Widget home) {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, _) => home),
      GoRoute(
        path: '/today',
        builder: (_, _) => const Scaffold(body: Text('today page')),
      ),
      GoRoute(
        path: '/me/breathe',
        builder: (_, _) => const Scaffold(body: Text('breathe page')),
      ),
      GoRoute(
        path: '/me/hard-day',
        builder: (_, _) => const Scaffold(body: Text('hard day page')),
      ),
      GoRoute(path: '/tour', builder: (_, _) => const TourScreen()),
    ],
  );
  return ProviderScope(
    overrides: [tipsRepositoryProvider.overrideWithValue(tips)],
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ),
  );
}

void main() {
  testWidgets('first tap shows the intro, then opens the feature', (
    tester,
  ) async {
    final tips = FakeTipsRepository();
    await tester.pumpWidget(_host(tips, const ExploreScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Breathe with Mochi'));
    await tester.pumpAndSettle();
    expect(find.text("Let's go"), findsOneWidget);
    expect(find.text('breathe page'), findsNothing);

    await tester.tap(find.text("Let's go"));
    await tester.pumpAndSettle();
    expect(find.text('breathe page'), findsOneWidget);
    expect(tips.seenIntros, contains(ExploreFeature.breathe));
  });

  testWidgets('dismissing the intro does not open, and it is not shown again', (
    tester,
  ) async {
    final tips = FakeTipsRepository();
    await tester.pumpWidget(_host(tips, const ExploreScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Breathe with Mochi'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(find.text('breathe page'), findsNothing);

    await tester.tap(find.text('Breathe with Mochi'));
    await tester.pumpAndSettle();
    expect(find.text('breathe page'), findsOneWidget);
  });

  testWidgets('the hard-day kit opens straight away, with no intro', (
    tester,
  ) async {
    await tester.pumpWidget(_host(FakeTipsRepository(), const ExploreScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('A hard day'));
    await tester.pumpAndSettle();
    expect(find.text("Let's go"), findsNothing);
    expect(find.text('hard day page'), findsOneWidget);
  });

  testWidgets('the tour prompt shows until the tour is seen', (tester) async {
    final tips = FakeTipsRepository(tourDone: false);
    await tester.pumpWidget(
      _host(tips, const Scaffold(body: TourPromptCard())),
    );
    await tester.pumpAndSettle();
    expect(find.text('New here?'), findsOneWidget);

    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();
    expect(find.text('New here?'), findsNothing);
    expect(tips.tourDone, isTrue);
  });

  testWidgets('the tour walks four cards and marks itself seen', (
    tester,
  ) async {
    final tips = FakeTipsRepository(tourDone: false);
    await tester.pumpWidget(_host(tips, const TourScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Your 2-minute ritual'), findsOneWidget);
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }
    expect(find.text('A little cosmic sparkle'), findsOneWidget);
    await tester.tap(find.text('Got it'));
    await tester.pumpAndSettle();
    expect(tips.tourDone, isTrue);
  });
}
