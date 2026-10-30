import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/analytics/analytics_providers.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/settings/presentation/analytics_consent_gate.dart';

import '../support/fake_analytics_consent.dart';

Widget _host(FakeAnalyticsConsentRepository repository) => ProviderScope(
  overrides: [analyticsConsentRepositoryProvider.overrideWithValue(repository)],
  child: const MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: AnalyticsConsentGate(child: Text('Home'))),
  ),
);

void main() {
  testWidgets('asks once when the question is unanswered', (tester) async {
    await tester.pumpWidget(_host(FakeAnalyticsConsentRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Help Mochi Moon grow?'), findsOneWidget);
    expect(find.text('Yes, count my taps'), findsOneWidget);
    expect(find.text('No thanks'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('does not ask after an answer', (tester) async {
    for (final saved in [true, false]) {
      await tester.pumpWidget(
        _host(FakeAnalyticsConsentRepository(saved: saved)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Help Mochi Moon grow?'), findsNothing);
    }
  });

  testWidgets('Yes saves the answer and closes the question', (tester) async {
    final repository = FakeAnalyticsConsentRepository();
    await tester.pumpWidget(_host(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Yes, count my taps'));
    await tester.pumpAndSettle();

    expect(repository.saved, isTrue);
    expect(find.text('Help Mochi Moon grow?'), findsNothing);
  });

  testWidgets('No thanks saves the answer and does not ask again', (
    tester,
  ) async {
    final repository = FakeAnalyticsConsentRepository();
    await tester.pumpWidget(_host(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('No thanks'));
    await tester.pumpAndSettle();

    expect(repository.saved, isFalse);
    expect(find.text('Help Mochi Moon grow?'), findsNothing);
  });

  testWidgets('the dialog survives large text', (tester) async {
    tester.view
      ..physicalSize = const Size(400, 800)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
        child: _host(FakeAnalyticsConsentRepository()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Help Mochi Moon grow?'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
