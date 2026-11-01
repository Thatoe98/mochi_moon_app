import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/paywall/application/purchase_providers.dart';
import 'package:mochi_moon/features/paywall/domain/purchase_catalog.dart';
import 'package:mochi_moon/features/paywall/presentation/paywall_screen.dart';

class _FakeCatalog implements PurchaseCatalog {
  _FakeCatalog({this.canBuy = true});

  final bool canBuy;
  int restoreCalls = 0;

  @override
  bool get canPurchase => canBuy;

  @override
  Future<List<PlanOffer>> offers() async => const [
    PlanOffer(plan: PremiumPlan.yearly, price: 'STORE-YEAR'),
    PlanOffer(plan: PremiumPlan.monthly, price: 'STORE-MONTH'),
  ];

  @override
  Future<bool> restore() async {
    restoreCalls++;
    return false;
  }
}

Widget _app(PurchaseCatalog catalog) => ProviderScope(
  overrides: [purchaseCatalogProvider.overrideWithValue(catalog)],
  child: const MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: PaywallScreen(source: 'test'),
  ),
);

void main() {
  void tall(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('shows store prices, trial note and a close button', (
    tester,
  ) async {
    tall(tester);
    await tester.pumpWidget(_app(_FakeCatalog()));
    await tester.pumpAndSettle();

    expect(find.textContaining('STORE-YEAR'), findsOneWidget);
    expect(find.textContaining('STORE-MONTH'), findsOneWidget);
    expect(find.textContaining('7 days free'), findsOneWidget);
    expect(find.text('Start free trial'), findsOneWidget);
    expect(find.byTooltip('Close'), findsOneWidget);
  });

  testWidgets('choosing monthly drops the trial wording', (tester) async {
    tall(tester);
    await tester.pumpWidget(_app(_FakeCatalog()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Monthly'));
    await tester.pumpAndSettle();

    expect(find.text('Subscribe'), findsOneWidget);
    expect(find.text('Start free trial'), findsNothing);
  });

  testWidgets('without billing the buy button is off and says why', (
    tester,
  ) async {
    tall(tester);
    await tester.pumpWidget(_app(_FakeCatalog(canBuy: false)));
    await tester.pumpAndSettle();

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
    expect(find.textContaining('not available to buy'), findsOneWidget);
  });

  testWidgets('restore reports what the store found', (tester) async {
    tall(tester);
    final catalog = _FakeCatalog();
    await tester.pumpWidget(_app(catalog));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Restore purchases'));
    await tester.tap(find.text('Restore purchases'));
    await tester.pumpAndSettle();

    expect(catalog.restoreCalls, 1);
    expect(find.textContaining('could not find'), findsOneWidget);
  });
}
