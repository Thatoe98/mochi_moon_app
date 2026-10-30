import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_theme.dart';
import 'package:mochi_moon/features/cosmic/astro/aspects.dart';
import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/chart/presentation/chart_wheel.dart';

const _label = 'Birth chart wheel. The placements are listed below.';

NatalChart _chart({
  bool withTime = true,
  Map<Body, double> longitudes = const {},
}) => NatalChart(
  birthUtc: DateTime.utc(1998, 11, 8, 1, 30),
  timeKnown: withTime,
  placements: [
    for (final body in Body.values)
      Placement(
        body: body,
        longitude: longitudes[body] ?? (body.index * 36.0 + 5),
        speed: 1,
      ),
  ],
  ascendant: withTime ? 255.4 : null,
  midheaven: withTime ? 169.2 : null,
);

Widget _host(
  NatalChart chart, {
  ThemeData? theme,
  Locale? locale,
  double width = 360,
}) => MaterialApp(
  theme: theme ?? AppTheme.light,
  locale: locale,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: Center(
      child: SizedBox(
        width: width,
        child: ChartWheel(chart: chart),
      ),
    ),
  ),
);

void main() {
  group('ChartWheel', () {
    testWidgets('is square and sized by its width', (tester) async {
      await tester.pumpWidget(_host(_chart()));
      expect(tester.getSize(find.byType(ChartWheel)), const Size(360, 360));
    });

    testWidgets('is announced once, as a picture', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_host(_chart()));
      expect(find.bySemanticsLabel(_label), findsOneWidget);
      handle.dispose();
    });

    testWidgets('speaks Burmese', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_host(_chart(), locale: const Locale('my')));
      expect(find.bySemanticsLabel(_label), findsNothing);
      expect(find.bySemanticsLabel(RegExp('Birth chart')), findsOneWidget);
      handle.dispose();
    });

    for (final (name, theme) in [
      ('light', AppTheme.light),
      ('dark', AppTheme.dark),
    ]) {
      for (final withTime in [true, false]) {
        testWidgets(
          'paints with ${withTime ? 'houses' : 'no houses'} in $name',
          (tester) async {
            await tester.pumpWidget(
              _host(_chart(withTime: withTime), theme: theme),
            );
            expect(tester.takeException(), isNull);
          },
        );
      }
    }

    testWidgets('paints a crowded sign and every aspect type', (tester) async {
      // Everything in one sign (so glyphs are spread) and then spread so that
      // all five aspect types are present.
      final crowded = {
        for (final body in Body.values) body: 100.0 + body.index * 0.5,
      };
      await tester.pumpWidget(_host(_chart(longitudes: crowded)));
      expect(tester.takeException(), isNull);

      final mixed = {
        Body.sun: 0.0,
        Body.moon: 60.0,
        Body.mercury: 90.0,
        Body.venus: 120.0,
        Body.mars: 180.0,
        Body.jupiter: 1.0,
        Body.saturn: 359.0,
        Body.uranus: 240.0,
        Body.neptune: 300.0,
        Body.pluto: 33.0,
      };
      final chart = _chart(longitudes: mixed);
      expect(
        natalAspects(chart).map((a) => a.type).toSet(),
        AspectType.values.toSet(),
      );
      await tester.pumpWidget(_host(chart));
      expect(tester.takeException(), isNull);
    });

    testWidgets('survives a tiny box', (tester) async {
      await tester.pumpWidget(_host(_chart(), width: 40));
      expect(tester.takeException(), isNull);
    });

    testWidgets('ignores the system text scale', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
          child: _host(_chart()),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(ChartWheel)), const Size(360, 360));
    });
  });

  group('ChartWheelPainter.shouldRepaint', () {
    final chart = _chart();
    final palette = WheelPalette.of(AppTheme.light.colorScheme);
    ChartWheelPainter painter(NatalChart c, WheelPalette p) =>
        ChartWheelPainter(chart: c, aspects: natalAspects(c), palette: p);

    test('stays put for the same chart and colors', () {
      expect(
        painter(chart, palette).shouldRepaint(painter(chart, palette)),
        isFalse,
      );
    });

    test('repaints for a new theme', () {
      final dark = WheelPalette.of(AppTheme.dark.colorScheme);
      expect(
        painter(chart, dark).shouldRepaint(painter(chart, palette)),
        isTrue,
      );
    });

    test('repaints for a different chart', () {
      final other = _chart(withTime: false);
      expect(
        painter(other, palette).shouldRepaint(painter(chart, palette)),
        isTrue,
      );
    });
  });

  group('WheelPalette', () {
    final colors = AppTheme.light.colorScheme;
    final palette = WheelPalette.of(colors);

    test('colors harmonious and challenging aspects differently', () {
      expect(palette.colorOf(AspectType.trine), colors.primary);
      expect(palette.colorOf(AspectType.sextile), colors.primary);
      expect(palette.colorOf(AspectType.square), colors.tertiary);
      expect(palette.colorOf(AspectType.opposition), colors.tertiary);
      expect(palette.colorOf(AspectType.conjunction), colors.outline);
    });

    test('compares by value', () {
      expect(palette, WheelPalette.of(colors));
      expect(palette.hashCode, WheelPalette.of(colors).hashCode);
      expect(palette, isNot(WheelPalette.of(AppTheme.dark.colorScheme)));
    });
  });
}
