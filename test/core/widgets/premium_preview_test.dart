import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_theme.dart';
import 'package:mochi_moon/core/widgets/premium_preview.dart';

Widget _host(Widget child, {double textScale = 1}) => MaterialApp(
  theme: AppTheme.light,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context)
        .copyWith(textScaler: TextScaler.linear(textScale)),
    child: child!,
  ),
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('shows a Premium chip and calls onOpen when tapped', (
    tester,
  ) async {
    var opened = 0;
    await tester.pumpWidget(
      _host(
        PremiumPreview(
          source: 'cosmic_today',
          semanticLabel: 'Love line',
          onOpen: () => opened++,
          child: const Text('Secret love line'),
        ),
      ),
    );

    expect(find.text('Premium'), findsOneWidget);
    await tester.tap(find.text('Premium'));
    expect(opened, 1);
  });

  testWidgets('hides the locked text from TalkBack and labels the lock', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        const PremiumPreview(
          source: 'cosmic_today',
          semanticLabel: 'Love line',
          child: Text('Secret love line'),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Secret love line'), findsNothing);
    expect(
      find.bySemanticsLabel(
        'Love line. Part of Premium. Opens the Premium page.',
      ),
      findsOneWidget,
    );
    handle.dispose();
  });

  testWidgets('opens the paywall with its source', (tester) async {
    final opened = <String?>[];
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
            body: Center(
              child: PremiumPreview(
                source: 'chart_details',
                semanticLabel: 'Aspects',
                child: Text('aspects'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.paywall,
          builder: (context, state) {
            opened.add(state.uri.queryParameters['source']);
            return const Scaffold(body: Text('paywall'));
          },
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.light,
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );

    await tester.tap(find.text('Premium'));
    await tester.pumpAndSettle();

    expect(opened, ['chart_details']);
  });

  testWidgets('fits at 1.3x text and keeps a 48 dp target', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 200,
          child: PremiumPreview(
            source: 'cosmic_today',
            semanticLabel: 'Lucky number',
            child: Text('7'),
          ),
        ),
        textScale: 1.3,
      ),
    );

    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.byType(PremiumPreview)).height,
      greaterThanOrEqualTo(48),
    );
  });
}
