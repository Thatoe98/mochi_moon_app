import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/mascot_item.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/mascot/application/mascot_providers.dart';
import 'package:mochi_moon/features/mascot/presentation/mascot_room_screen.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';

import '../support/fake_mascot.dart';

const _items = [
  MascotItem(
    id: 'scarf',
    slot: 'outfit',
    name: {'en': 'Cozy scarf'},
    unlock: MascotUnlock(type: 'streak', value: 7),
    illustrationId: 'ill_mascot_scarf_01',
  ),
  MascotItem(
    id: 'crown',
    slot: 'outfit',
    name: {'en': 'Flower crown'},
    unlock: MascotUnlock(type: 'streak', value: 14),
    illustrationId: 'ill_mascot_crown_01',
    premium: true,
  ),
  MascotItem(
    id: 'lamp',
    slot: 'shelf',
    name: {'en': 'Moon glow lamp'},
    unlock: MascotUnlock(type: 'streak', value: 30),
    illustrationId: 'ill_mascot_lamp_01',
  ),
];

void main() {
  late FakeMascotRepository repo;

  setUp(() => repo = FakeMascotRepository());

  Future<void> pump(WidgetTester tester, {bool premium = false}) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          mascotRepositoryProvider.overrideWithValue(repo),
          mascotItemsProvider.overrideWith((ref) async => _items),
          hasPremiumProvider.overrideWithValue(premium),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MascotRoomScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the empty invitation and how to earn each gift', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text("Mochi's room is waiting"), findsOneWidget);
    expect(find.text('Reach a 7-day streak'), findsOneWidget);
    expect(find.text('Cozy scarf'), findsNothing);
  });

  testWidgets('an owned item can be put on and taken off', (tester) async {
    await repo.grant(['scarf'], DateTime(2026, 11, 2));
    await pump(tester);

    expect(find.text('Cozy scarf'), findsOneWidget);
    await tester.tap(find.text('Cozy scarf'));
    await tester.pumpAndSettle();
    expect(repo.state.equipped, {'outfit': 'scarf'});
    expect(find.text('In use. Tap to take off.'), findsOneWidget);

    await tester.tap(find.text('Cozy scarf'));
    await tester.pumpAndSettle();
    expect(repo.state.equipped, isEmpty);
  });

  testWidgets('a Premium gift is kept but cannot be used without Premium', (
    tester,
  ) async {
    await repo.grant(['crown'], DateTime(2026, 11, 2));
    await pump(tester);

    expect(find.text('Flower crown'), findsOneWidget);
    expect(
      find.text('Mochi keeps this gift. Using it is part of Premium.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Flower crown'));
    await tester.pumpAndSettle();
    expect(repo.state.equipped, isEmpty);
  });

  testWidgets('with Premium the same gift can be worn', (tester) async {
    await repo.grant(['crown'], DateTime(2026, 11, 2));
    await pump(tester, premium: true);

    await tester.tap(find.text('Flower crown'));
    await tester.pumpAndSettle();
    expect(repo.state.equipped, {'outfit': 'crown'});
  });

  testWidgets('every gift has a semantic label and survives 1.3x text', (
    tester,
  ) async {
    await repo.grant(['scarf'], DateTime(2026, 11, 2));
    final handle = tester.ensureSemantics();
    tester.view.physicalSize = const Size(400, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          mascotRepositoryProvider.overrideWithValue(repo),
          mascotItemsProvider.overrideWith((ref) async => _items),
          hasPremiumProvider.overrideWithValue(false),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.3)),
            child: child!,
          ),
          home: const MascotRoomScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.bySemanticsLabel('Cozy scarf, Tap to use'), findsOneWidget);
    handle.dispose();
  });
}
