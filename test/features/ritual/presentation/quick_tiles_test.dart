import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/ritual/presentation/quick_tiles.dart';

Widget _host() => MaterialApp.router(
  routerConfig: GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(body: QuickTiles()),
      ),
      GoRoute(
        path: '/me/breathe',
        builder: (_, _) => const Scaffold(body: Text('breathe page')),
      ),
      GoRoute(
        path: '/me/hard-day',
        builder: (_, state) => Scaffold(
          body: Text('hard day ${state.uri.queryParameters['source']}'),
        ),
      ),
    ],
  ),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
);

void main() {
  testWidgets('shows four shortcuts', (tester) async {
    await tester.pumpWidget(_host());
    for (final label in ['Breathe', 'Gratitude', 'Mood', 'Hard day']) {
      expect(find.text(label), findsOneWidget);
    }
  });

  testWidgets('Breathe opens straight away', (tester) async {
    await tester.pumpWidget(_host());
    await tester.tap(find.text('Breathe'));
    await tester.pumpAndSettle();
    expect(find.text('breathe page'), findsOneWidget);
  });

  testWidgets('Hard day opens the kit and says it came from Today', (
    tester,
  ) async {
    await tester.pumpWidget(_host());
    await tester.tap(find.text('Hard day'));
    await tester.pumpAndSettle();
    expect(find.text('hard day today'), findsOneWidget);
  });
}
