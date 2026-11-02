import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_theme.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/partners/application/compatibility_providers.dart';
import 'package:mochi_moon/features/partners/application/partner_providers.dart';
import 'package:mochi_moon/features/partners/domain/partner.dart';
import 'package:mochi_moon/features/partners/presentation/compatibility_meter.dart';
import 'package:mochi_moon/features/partners/presentation/partner_result_screen.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';

import '../../profile/support/fake_profile.dart';
import '../support/fake_partners.dart';

final _profile = UserProfile(
  displayName: 'Mochi',
  birthDate: DateTime(1998, 11, 8),
  birthMinutes: 8 * 60 + 30,
  birthPlace: bangkok,
);

Widget _app({
  String? id = 'a',
  UserProfile? profile,
  List<Partner>? partners,
  bool failing = false,
  bool loading = false,
  bool premium = true,
}) {
  final router = GoRouter(
    initialLocation: '/result',
    routes: [
      GoRoute(
        path: '/result',
        builder: (context, state) => PartnerResultScreen(partnerId: id),
      ),
      GoRoute(
        path: AppRoutes.partnerEdit,
        builder: (context, state) =>
            Text('edit ${state.uri.queryParameters['id']}'),
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      hasPremiumProvider.overrideWithValue(premium),
      profileRepositoryProvider.overrideWithValue(
        FakeProfileRepository(profile),
      ),
      partnerRepositoryProvider.overrideWithValue(
        FakePartnerRepository(partners ?? [partner('a')]),
      ),
      if (failing)
        compatibilityProvider.overrideWith(
          (ref, id) => throw Exception('boom'),
        ),
      if (loading)
        compatibilityProvider.overrideWith(
          (ref, id) => Completer<Compatibility?>().future,
        ),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
}

void _tallView(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(800, 5000)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('free: the overall score is open, details are a preview', (
    tester,
  ) async {
    _tallView(tester);
    await tester.pumpWidget(_app(profile: _profile, premium: false));
    await tester.pumpAndSettle();

    expect(find.byType(CompatibilityMeter), findsOneWidget);
    expect(find.text('Premium'), findsOneWidget);
  });

  testWidgets('Premium: no lock on the details', (tester) async {
    _tallView(tester);
    await tester.pumpWidget(_app(profile: _profile));
    await tester.pumpAndSettle();

    expect(find.text('Premium'), findsNothing);
  });

  testWidgets('shows a loading state first', (tester) async {
    _tallView(tester);
    await tester.pumpWidget(_app(profile: _profile, loading: true));
    await tester.pump();

    expect(find.byType(LoadingView), findsOneWidget);
  });

  testWidgets('shows an error state that can retry', (tester) async {
    _tallView(tester);
    await tester.pumpWidget(_app(profile: _profile, failing: true));
    await tester.pumpAndSettle();

    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets("asks for the user's birthday when there is no profile", (
    tester,
  ) async {
    _tallView(tester);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.text('Add your birthday to compare'), findsOneWidget);
    expect(find.byType(CompatibilityMeter), findsNothing);
  });

  testWidgets('an unknown partner shows a not-found message', (tester) async {
    _tallView(tester);
    await tester.pumpWidget(_app(id: 'missing', profile: _profile));
    await tester.pumpAndSettle();

    expect(find.text("We couldn't find this partner."), findsOneWidget);
  });

  testWidgets('a missing id shows a not-found message', (tester) async {
    _tallView(tester);
    await tester.pumpWidget(_app(id: null, profile: _profile));
    await tester.pumpAndSettle();

    expect(find.text("We couldn't find this partner."), findsOneWidget);
  });

  testWidgets('shows the header, meter, sub-scores and the note', (
    tester,
  ) async {
    _tallView(tester);
    await tester.pumpWidget(_app(profile: _profile));
    await tester.pumpAndSettle();

    expect(find.text('You (Scorpio) + Luna (Taurus)'), findsOneWidget);
    expect(find.byType(CompatibilityMeter), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp(r'^Compatibility \d+ percent$')),
      findsOneWidget,
    );
    for (final theme in ['Romance', 'Emotional', 'Communication']) {
      expect(find.text(theme), findsOneWidget);
    }
    expect(find.text('For entertainment and self-reflection'), findsOneWidget);
  });

  testWidgets('a partner without a birth time gets the Light reading chip', (
    tester,
  ) async {
    _tallView(tester);
    await tester.pumpWidget(_app(profile: _profile));
    await tester.pumpAndSettle();

    expect(find.text('Light reading'), findsOneWidget);
  });

  testWidgets('both birth times known hides the Light reading chip', (
    tester,
  ) async {
    _tallView(tester);
    await tester.pumpWidget(
      _app(
        profile: _profile,
        partners: [
          partner('a', birthMinutes: 14 * 60 + 30, birthPlace: bangkok),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Light reading'), findsNothing);
    expect(find.byType(CompatibilityMeter), findsOneWidget);
  });

  testWidgets('aspects appear under the flow and grow headings', (
    tester,
  ) async {
    _tallView(tester);
    await tester.pumpWidget(_app(profile: _profile));
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(PartnerResultScreen)),
    );
    final result = (await container.read(compatibilityProvider('a').future))!;

    expect(
      find.text('What flows'),
      result.topSupportive.isEmpty ? findsNothing : findsOneWidget,
    );
    expect(
      find.text('Where you grow'),
      result.topGrowth.isEmpty ? findsNothing : findsOneWidget,
    );
    expect(
      find.textContaining("Luna's"),
      findsNWidgets(result.topSupportive.length + result.topGrowth.length),
    );
  });

  testWidgets('the app bar Edit button opens the edit form', (tester) async {
    _tallView(tester);
    await tester.pumpWidget(_app(profile: _profile));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Edit partner'));
    await tester.pumpAndSettle();

    expect(find.text('edit a'), findsOneWidget);
  });
}
