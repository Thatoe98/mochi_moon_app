import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_theme.dart';
import 'package:mochi_moon/core/utils/english_dates.dart';
import 'package:mochi_moon/features/cosmic/astro/moon_phase.dart';
import 'package:mochi_moon/features/cosmic/moon/presentation/moon_card.dart';
import 'package:mochi_moon/features/cosmic/moon/presentation/moon_glyph.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';

// Three days after the full moon of 26 Oct 2026: a waning gibbous moon.
final _now = DateTime.utc(2026, 10, 29, 12);

Widget _host({
  DateTime? now,
  Locale? locale,
  double textScale = 1,
  ThemeData? theme,
}) => ProviderScope(
  overrides: [clockProvider.overrideWithValue(() => now ?? _now)],
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
    home: const Scaffold(body: SingleChildScrollView(child: MoonCard())),
  ),
);

String _date(DateTime utc) => englishDates.formatMediumDate(utc.toLocal());

void main() {
  testWidgets('shows the phase, light, sign, next moons and an affirmation', (
    tester,
  ) async {
    await tester.pumpWidget(_host());
    final moon = moonPhase(_now);

    expect(find.text('Moon'), findsOneWidget);
    expect(find.text('Waning gibbous'), findsOneWidget);
    expect(
      find.text('${(moon.illumination * 100).round()}% lit'),
      findsOneWidget,
    );
    expect(find.textContaining('Moon in '), findsOneWidget);
    expect(
      find.text('Next new moon: ${_date(moon.nextNewMoon)}'),
      findsOneWidget,
    );
    expect(
      find.text('Next full moon: ${_date(moon.nextFullMoon)}'),
      findsOneWidget,
    );
    expect(
      find.text('I share what I have learned and I thank myself for it.'),
      findsOneWidget,
    );
  });

  testWidgets('reads the phase once and heads the card for TalkBack', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_host());

    final node = tester.getSemantics(find.byType(MoonCard));
    expect(node.label.split('Waning gibbous'), hasLength(2));
    expect(node.label, startsWith('Moon\n'));
    handle.dispose();
  });

  testWidgets('follows the clock to the next phase', (tester) async {
    await tester.pumpWidget(_host(now: DateTime.utc(2026, 11, 17, 12)));

    expect(find.text('First quarter'), findsOneWidget);
    expect(find.text('Waning gibbous'), findsNothing);
  });

  testWidgets('shows the Burmese labels in my', (tester) async {
    await tester.pumpWidget(_host(locale: const Locale('my')));
    final l10n = await AppLocalizations.delegate.load(const Locale('my'));

    expect(find.text(l10n.moonTitle), findsOneWidget);
    expect(find.text(l10n.moonPhaseWaningGibbous), findsOneWidget);
  });

  testWidgets('fits a narrow phone at 1.3x text in light and dark', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(360, 800)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(textScale: 1.3));
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(MoonCard)).width, lessThanOrEqualTo(360));

    await tester.pumpWidget(_host(textScale: 1.3, theme: AppTheme.dark));
    expect(tester.takeException(), isNull);
  });

  testWidgets('the drawing paints every kind of phase without errors', (
    tester,
  ) async {
    for (final waxing in [true, false]) {
      for (final lit in [0.0, 0.1, 0.5, 0.9, 1.0]) {
        await tester.pumpWidget(
          MaterialApp(
            home: MoonGlyph(illumination: lit, isWaxing: waxing, size: 64),
          ),
        );
        expect(tester.takeException(), isNull);
      }
    }
  });
}
