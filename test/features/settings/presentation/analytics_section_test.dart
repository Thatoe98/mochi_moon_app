import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/analytics/analytics_providers.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/settings/presentation/analytics_section.dart';

import '../support/fake_analytics_consent.dart';

Widget _host(FakeAnalyticsConsentRepository repository) => ProviderScope(
  overrides: [analyticsConsentRepositoryProvider.overrideWithValue(repository)],
  child: const MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: AnalyticsSection()),
  ),
);

bool _switchValue(WidgetTester tester) =>
    tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value;

void main() {
  testWidgets('is off while the question is unanswered', (tester) async {
    await tester.pumpWidget(_host(FakeAnalyticsConsentRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Share anonymous usage'), findsOneWidget);
    expect(_switchValue(tester), isFalse);
  });

  testWidgets('shows a saved yes and a saved no', (tester) async {
    await tester.pumpWidget(_host(FakeAnalyticsConsentRepository(saved: true)));
    await tester.pumpAndSettle();
    expect(_switchValue(tester), isTrue);

    await tester.pumpWidget(
      _host(FakeAnalyticsConsentRepository(saved: false)),
    );
    await tester.pumpAndSettle();
    expect(_switchValue(tester), isFalse);
  });

  testWidgets('switching it on saves the answer', (tester) async {
    final repository = FakeAnalyticsConsentRepository();
    await tester.pumpWidget(_host(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    expect(repository.saved, isTrue);
    expect(_switchValue(tester), isTrue);
  });

  testWidgets('switching it off saves the answer', (tester) async {
    final repository = FakeAnalyticsConsentRepository(saved: true);
    await tester.pumpWidget(_host(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    expect(repository.saved, isFalse);
  });

  testWidgets('survives large text', (tester) async {
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

    expect(tester.takeException(), isNull);
  });
}
