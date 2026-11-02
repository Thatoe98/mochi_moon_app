import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/me/presentation/widget_theme_section.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:mochi_moon/features/widget_bridge/application/widget_theme_providers.dart';
import 'package:mochi_moon/features/widget_bridge/domain/widget_theme.dart';

import '../../widget_bridge/application/widget_theme_providers_test.dart';

Widget _host(FakeWidgetThemeRepository repo, {required bool premium}) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(body: WidgetThemeSection()),
      ),
      GoRoute(
        path: AppRoutes.paywall,
        builder: (_, state) =>
            Text('paywall ${state.uri.queryParameters['source']}'),
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      widgetThemeRepositoryProvider.overrideWithValue(repo),
      hasPremiumProvider.overrideWithValue(premium),
    ],
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ),
  );
}

void main() {
  testWidgets('Premium picks a theme and it is saved', (tester) async {
    final repo = FakeWidgetThemeRepository();
    await tester.pumpWidget(_host(repo, premium: true));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Lavender'));
    await tester.pumpAndSettle();

    expect(repo.saved, WidgetTheme.lavender);
  });

  testWidgets('a free user tapping a Premium theme sees the paywall', (
    tester,
  ) async {
    final repo = FakeWidgetThemeRepository();
    await tester.pumpWidget(_host(repo, premium: false));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.lock_outline_rounded), findsNWidgets(3));
    await tester.tap(find.text('Midnight'));
    await tester.pumpAndSettle();

    expect(find.text('paywall widget_theme'), findsOneWidget);
    expect(repo.saved, WidgetTheme.cream);
  });

  testWidgets('a free user can pick cream', (tester) async {
    final repo = FakeWidgetThemeRepository();
    await tester.pumpWidget(_host(repo, premium: false));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cream'));
    await tester.pumpAndSettle();

    expect(find.textContaining('paywall'), findsNothing);
  });
}
