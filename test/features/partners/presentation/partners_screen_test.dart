import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/partners/application/partner_providers.dart';
import 'package:mochi_moon/features/partners/domain/partner.dart';
import 'package:mochi_moon/features/partners/domain/partner_repository.dart';
import 'package:mochi_moon/features/partners/presentation/partners_screen.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';

import '../support/fake_partners.dart';

class _Throwing extends FakePartnerRepository {
  _Throwing({required this.fail});

  bool fail;

  @override
  Future<List<Partner>> partners() async {
    if (fail) throw Exception('boom');
    return await super.partners();
  }
}

Widget _app(PartnerRepository repository, {bool premium = true}) {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const PartnersScreen()),
      GoRoute(
        path: AppRoutes.partnerEdit,
        builder: (context, state) =>
            Text('edit ${state.uri.queryParameters['id'] ?? 'new'}'),
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      partnerRepositoryProvider.overrideWithValue(repository),
      hasPremiumProvider.overrideWithValue(premium),
      clockProvider.overrideWithValue(() => DateTime(2026, 10, 30, 9)),
    ],
    child: MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
}

void main() {
  testWidgets('shows a loading state first', (tester) async {
    await tester.pumpWidget(_app(FakePartnerRepository()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('shows the empty state with an enabled add button', (
    tester,
  ) async {
    await tester.pumpWidget(_app(FakePartnerRepository()));
    await tester.pumpAndSettle();

    expect(find.text('No partners yet'), findsOneWidget);
    final add = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(add.onPressed, isNotNull);
  });

  testWidgets('shows an error state that retries', (tester) async {
    final repository = _Throwing(fail: true);
    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();
    expect(find.text('Something wobbled'), findsOneWidget);

    repository.fail = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('No partners yet'), findsOneWidget);
  });

  testWidgets('lists partners with their Sun sign and birthday', (
    tester,
  ) async {
    await tester.pumpWidget(_app(FakePartnerRepository([partner('a')])));
    await tester.pumpAndSettle();

    expect(find.text('Luna'), findsOneWidget);
    expect(find.text('Taurus · Born May 14, 1998'), findsOneWidget);
  });

  testWidgets('tapping a partner opens the edit form for it', (tester) async {
    await tester.pumpWidget(_app(FakePartnerRepository([partner('a')])));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Luna'));
    await tester.pumpAndSettle();

    expect(find.text('edit a'), findsOneWidget);
  });

  testWidgets('the add button opens an empty form', (tester) async {
    await tester.pumpWidget(_app(FakePartnerRepository()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add a partner'));
    await tester.pumpAndSettle();

    expect(find.text('edit new'), findsOneWidget);
  });

  testWidgets('Free at its limit disables add and explains the limit', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(FakePartnerRepository([partner('a')]), premium: false),
    );
    await tester.pumpAndSettle();

    final add = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(add.onPressed, isNull);
    expect(
      find.text('Free includes 1 partner. Premium keeps up to 5.'),
      findsOneWidget,
    );
  });

  testWidgets('Premium at five partners cannot add a sixth', (tester) async {
    await tester.pumpWidget(
      _app(
        FakePartnerRepository([
          for (var i = 1; i <= 5; i++) partner('p$i', nickname: 'P$i', day: i),
        ]),
      ),
    );
    await tester.pumpAndSettle();

    final add = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(add.onPressed, isNull);
    expect(find.textContaining('(5)'), findsOneWidget);
  });

  testWidgets('delete asks first and keeps the partner when declined', (
    tester,
  ) async {
    final repository = FakePartnerRepository([partner('a')]);
    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Delete Luna'));
    await tester.pumpAndSettle();
    expect(find.text('Delete Luna?'), findsOneWidget);

    await tester.tap(find.text('Keep it'));
    await tester.pumpAndSettle();

    expect(repository.saved, hasLength(1));
    expect(find.text('Luna'), findsOneWidget);
  });

  testWidgets('confirming delete removes the partner and frees the place', (
    tester,
  ) async {
    final repository = FakePartnerRepository([partner('a')]);
    await tester.pumpWidget(_app(repository, premium: false));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Delete Luna'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(repository.saved, isEmpty);
    expect(find.text('No partners yet'), findsOneWidget);
    final add = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(add.onPressed, isNotNull);
  });

  testWidgets('delete buttons meet the 48 dp touch target', (tester) async {
    await tester.pumpWidget(_app(FakePartnerRepository([partner('a')])));
    await tester.pumpAndSettle();

    final size = tester.getSize(find.byType(IconButton));
    expect(size.width, greaterThanOrEqualTo(48));
    expect(size.height, greaterThanOrEqualTo(48));
  });
}
