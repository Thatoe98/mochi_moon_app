import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_theme.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/cosmic/chart/application/chart_providers.dart';
import 'package:mochi_moon/features/cosmic/chart/presentation/chart_glyphs.dart';
import 'package:mochi_moon/features/cosmic/chart/presentation/chart_screen.dart';
import 'package:mochi_moon/features/cosmic/chart/presentation/chart_wheel.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/profile/domain/birth_place.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';

import '../../../profile/support/fake_profile.dart';

const _bangkok = BirthPlace(
  name: 'Bangkok',
  region: 'Bangkok',
  countryCode: 'TH',
  lat: 13.75,
  lng: 100.5,
  tzId: 'Asia/Bangkok',
);

/// Sun Scorpio 15°25′, Moon Cancer 8°48′, Rising Sagittarius 15°25′, MC Virgo
/// 19°09′; Jupiter and Saturn retrograde.
final _withTime = UserProfile(
  displayName: 'Mochi',
  birthDate: DateTime(1998, 11, 8),
  birthMinutes: 8 * 60 + 30,
  birthPlace: _bangkok,
);

/// The same day with no time: Moon Cancer 10°52′ at noon.
final _noTime = UserProfile(
  displayName: 'Mochi',
  birthDate: DateTime(1998, 11, 8),
  birthPlace: _bangkok,
);

Widget _host({
  UserProfile? profile,
  Locale? locale,
  double textScale = 1,
  ThemeData? theme,
  bool failing = false,
  bool premium = false,
}) => ProviderScope(
  overrides: [
    hasPremiumProvider.overrideWithValue(premium),
    profileRepositoryProvider.overrideWithValue(FakeProfileRepository(profile)),
    if (failing)
      natalChartProvider.overrideWith((ref) => throw Exception('boom')),
  ],
  child: MaterialApp(
    theme: theme ?? AppTheme.light,
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(textScale)),
      child: child!,
    ),
    home: const ChartScreen(),
  ),
);

/// Tall enough that the whole list is built.
void _tallView(WidgetTester tester, {double width = 800}) {
  tester.view
    ..physicalSize = Size(width, 5000)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows a loader first', (tester) async {
    await tester.pumpWidget(_host(profile: _withTime));
    expect(find.byType(LoadingView), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('asks for a birth date when there is none', (tester) async {
    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();
    expect(find.text('Your chart needs a birth date'), findsOneWidget);
    expect(find.text('Your Big 3'), findsNothing);
  });

  testWidgets('offers the full reading to Premium users', (tester) async {
    _tallView(tester);
    await tester.pumpWidget(_host(profile: _withTime, premium: true));
    await tester.pumpAndSettle();

    expect(find.text('Your full reading'), findsOneWidget);
  });

  testWidgets('hides the full reading from free users', (tester) async {
    _tallView(tester);
    await tester.pumpWidget(_host(profile: _withTime));
    await tester.pumpAndSettle();

    expect(find.text('Your full reading'), findsNothing);
  });

  testWidgets('shows an error with a way to retry', (tester) async {
    await tester.pumpWidget(_host(profile: _withTime, failing: true));
    await tester.pumpAndSettle();
    expect(find.byType(ErrorView), findsOneWidget);
  });

  testWidgets('shows the Big 3 and every placement when the time is known', (
    tester,
  ) async {
    _tallView(tester);
    await tester.pumpWidget(_host(profile: _withTime));
    await tester.pumpAndSettle();

    expect(find.text('Birth chart'), findsOneWidget);
    expect(find.text('Your Big 3'), findsOneWidget);
    expect(find.text('Sun in Scorpio'), findsOneWidget);
    expect(find.text('Moon in Cancer'), findsOneWidget);
    expect(find.text('Rising in Sagittarius'), findsOneWidget);
    expect(find.textContaining('You feel things with depth'), findsOneWidget);
    expect(find.text('approximate'), findsNothing);
    expect(find.text('Add your birth time'), findsNothing);

    expect(find.text('Placements'), findsOneWidget);
    expect(find.text('Scorpio 15°25′'), findsOneWidget);
    expect(find.text('Cancer 8°48′'), findsOneWidget);
    expect(find.text('Ascendant'), findsOneWidget);
    expect(find.text('Sagittarius 15°25′'), findsOneWidget);
    expect(find.text('Midheaven'), findsOneWidget);
    expect(find.text('Virgo 19°09′'), findsOneWidget);
    // Houses: the Moon sits in the 8th, the Ascendant opens the 1st.
    expect(find.text('House 8'), findsOneWidget);
    expect(find.text('House 12'), findsNWidgets(2));
    // Jupiter and Saturn.
    expect(find.text(retrogradeMark), findsNWidgets(2));
    expect(find.text('For entertainment and self-reflection'), findsOneWidget);
  });

  testWidgets('without a birth time hides Rising and houses', (tester) async {
    _tallView(tester);
    await tester.pumpWidget(_host(profile: _noTime));
    await tester.pumpAndSettle();

    expect(find.text('Add your birth time'), findsOneWidget);
    expect(find.text('Sun in Scorpio'), findsOneWidget);
    expect(find.text('Moon in Cancer'), findsOneWidget);
    expect(find.textContaining('Rising in'), findsNothing);
    expect(find.text('Ascendant'), findsNothing);
    expect(find.text('Midheaven'), findsNothing);
    expect(find.textContaining('House'), findsNothing);
    // The card and the row both say the Moon is approximate.
    expect(find.text('approximate'), findsOneWidget);
    expect(find.text('Cancer 10°52′ (approximate)'), findsOneWidget);
    expect(find.text(retrogradeMark), findsNWidgets(2));
  });

  testWidgets('draws the wheel above the Big 3, with or without a time', (
    tester,
  ) async {
    _tallView(tester);
    for (final profile in [_withTime, _noTime]) {
      await tester.pumpWidget(_host(profile: profile));
      await tester.pumpAndSettle();
      expect(find.byType(ChartWheel), findsOneWidget);
      expect(
        tester.getBottomLeft(find.byType(ChartWheel)).dy,
        lessThan(tester.getTopLeft(find.text('Your Big 3')).dy),
      );
    }
  });

  testWidgets('reads in Burmese', (tester) async {
    _tallView(tester);
    await tester.pumpWidget(
      _host(profile: _withTime, locale: const Locale('my')),
    );
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('my'));
    expect(find.text(l10n.chartBigThreeTitle), findsOneWidget);
    expect(find.text(l10n.chartPlacementsTitle), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('each row is one stop for TalkBack', (tester) async {
    _tallView(tester);
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(_host(profile: _withTime));
    await tester.pumpAndSettle();

    expect(
      find.bySemanticsLabel('Sun in Scorpio, 15°25′, House 12'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('Jupiter in Pisces, 18°12′, House 4, retrograde'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('Ascendant in Sagittarius, 15°25′, House 1'),
      findsOneWidget,
    );
    // The heading is only the title, not the whole card read as a heading.
    expect(find.bySemanticsLabel('Sun in Scorpio'), findsOneWidget);
    // The glyphs are decoration; the words carry the meaning.
    expect(find.bySemanticsLabel('☉'), findsNothing);
    semantics.dispose();
  });

  testWidgets('the unknown-time Moon is announced as approximate', (
    tester,
  ) async {
    _tallView(tester);
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(_host(profile: _noTime));
    await tester.pumpAndSettle();

    expect(
      find.bySemanticsLabel('Moon in Cancer, 10°52′, approximate'),
      findsOneWidget,
    );
    semantics.dispose();
  });

  for (final (name, theme) in [
    ('light', AppTheme.light),
    ('dark', AppTheme.dark),
  ]) {
    for (final (label, profile) in [
      ('with a birth time', _withTime),
      ('without a birth time', _noTime),
    ]) {
      testWidgets('fits at 1.3× text on a small phone, $name, $label', (
        tester,
      ) async {
        _tallView(tester, width: 360);
        await tester.pumpWidget(
          _host(profile: profile, textScale: 1.3, theme: theme),
        );
        await tester.pumpAndSettle();

        expect(find.text('Placements'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
