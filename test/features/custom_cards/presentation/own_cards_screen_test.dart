import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/custom_cards/application/own_card_providers.dart';
import 'package:mochi_moon/features/custom_cards/domain/own_card.dart';
import 'package:mochi_moon/features/custom_cards/presentation/own_cards_screen.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';

import '../../auth/support/fake_auth_repository.dart';
import '../support/fake_own_cards.dart';

OwnCard _card(String id, int day) => OwnCard(
  id: id,
  body: 'Words $id',
  illustrationId: 'calm_01',
  createdAt: DateTime(2026, 10, day),
);

Widget _app(FakeOwnCardRepository repo, {bool premium = false}) =>
    ProviderScope(
      overrides: [
        ownCardRepositoryProvider.overrideWithValue(repo),
        ownCardRemoteProvider.overrideWithValue(null),
        hasPremiumProvider.overrideWithValue(premium),
        clockProvider.overrideWithValue(() => DateTime(2026, 10, 31, 12)),
        authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: OwnCardsScreen(),
      ),
    );

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized().platformDispatcher.views.first
      ..physicalSize = const Size(1170, 3000)
      ..devicePixelRatio = 3;
  });
  tearDown(() {
    TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
      ..resetPhysicalSize()
      ..resetDevicePixelRatio();
  });

  testWidgets('an empty list invites her to write a card', (tester) async {
    await tester.pumpWidget(_app(FakeOwnCardRepository()));
    await tester.pump();

    expect(find.text('No cards of your own yet'), findsOneWidget);
    expect(find.text('1 free card left'), findsOneWidget);
  });

  testWidgets('writing a card saves it with the picked picture', (
    tester,
  ) async {
    final repo = FakeOwnCardRepository();
    await tester.pumpWidget(_app(repo));
    await tester.pump();

    await tester.tap(find.text('Write a card'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'I am enough');
    await tester.pump();
    await tester.tap(
      find.bySemanticsLabel(RegExp('Mochi the moon bunny wrapped')),
    );
    await tester.pump();
    await tester.tap(find.text('Save my card'));
    await tester.pumpAndSettle();

    expect(repo.all.single.body, 'I am enough');
    expect(repo.all.single.illustrationId, 'healing_01');
    expect(find.text('I am enough'), findsOneWidget);
  });

  testWidgets('the box stops at 140 characters', (tester) async {
    await tester.pumpWidget(_app(FakeOwnCardRepository()));
    await tester.pump();
    await tester.tap(find.text('Write a card'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'a' * 200);
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.text.length, 140);
  });

  testWidgets('the second card explains the limit instead of opening', (
    tester,
  ) async {
    final repo = FakeOwnCardRepository([_card('a', 1)]);
    await tester.pumpWidget(_app(repo));
    await tester.pump();

    expect(find.text('No free cards left'), findsOneWidget);
    await tester.tap(find.text('Write a card'));
    await tester.pumpAndSettle();

    expect(find.text('Your free card is in use'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('Premium can keep writing past the first', (tester) async {
    final repo = FakeOwnCardRepository([
      _card('a', 1),
      _card('b', 2),
      _card('c', 3),
    ]);
    await tester.pumpWidget(_app(repo, premium: true));
    await tester.pump();

    expect(find.textContaining('free card'), findsNothing);
    await tester.tap(find.text('Write a card'));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('editing changes the words; deleting asks first', (tester) async {
    final repo = FakeOwnCardRepository([_card('a', 1)]);
    await tester.pumpWidget(_app(repo));
    await tester.pump();

    await tester.tap(find.text('Words a'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Better words');
    await tester.pump();
    await tester.tap(find.text('Save my card'));
    await tester.pumpAndSettle();
    expect(repo.all.single.body, 'Better words');

    await tester.tap(find.text('Better words'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Delete this card'));
    await tester.tap(find.text('Delete this card'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keep it'));
    await tester.pumpAndSettle();
    expect(repo.all, hasLength(1));

    await tester.ensureVisible(find.text('Delete this card'));
    await tester.tap(find.text('Delete this card'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(repo.all, isEmpty);
  });
}
