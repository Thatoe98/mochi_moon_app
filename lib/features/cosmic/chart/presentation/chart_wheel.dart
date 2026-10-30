import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/cosmic/astro/aspects.dart';
import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';
import 'package:mochi_moon/features/cosmic/chart/presentation/chart_glyphs.dart';
import 'package:mochi_moon/features/cosmic/chart/presentation/wheel_layout.dart';

/// The colors a wheel is drawn in, all taken from the theme.
@immutable
class WheelPalette {
  const WheelPalette({
    required this.line,
    required this.band,
    required this.text,
    required this.quietText,
    required this.harmonious,
    required this.challenging,
    required this.neutral,
    required this.axis,
  });

  factory WheelPalette.of(ColorScheme colors) => WheelPalette(
    line: colors.outline,
    band: colors.primaryContainer,
    text: colors.onSurface,
    quietText: colors.onSurfaceVariant,
    harmonious: colors.primary,
    challenging: colors.tertiary,
    neutral: colors.outline,
    axis: colors.secondary,
  );

  final Color line;
  final Color band;
  final Color text;
  final Color quietText;

  /// Trines and sextiles.
  final Color harmonious;

  /// Squares and oppositions.
  final Color challenging;

  /// Conjunctions.
  final Color neutral;

  /// The Ascendant and Midheaven marks.
  final Color axis;

  Color colorOf(AspectType type) => switch (type) {
    AspectType.trine || AspectType.sextile => harmonious,
    AspectType.square || AspectType.opposition => challenging,
    AspectType.conjunction => neutral,
  };

  @override
  bool operator ==(Object other) =>
      other is WheelPalette &&
      other.line == line &&
      other.band == band &&
      other.text == text &&
      other.quietText == quietText &&
      other.harmonious == harmonious &&
      other.challenging == challenging &&
      other.neutral == neutral &&
      other.axis == axis;

  @override
  int get hashCode => Object.hash(
    line,
    band,
    text,
    quietText,
    harmonious,
    challenging,
    neutral,
    axis,
  );
}

/// The birth chart as a wheel: the zodiac ring, the planets at their degrees
/// and a line for each major aspect (PRD §6.11). With a known birth time the
/// Ascendant sits at 9 o'clock and the Whole Sign houses are numbered;
/// otherwise 0° Aries is at 9 o'clock and there are no houses.
///
/// The wheel is a picture: the placements list carries the same facts for
/// screen readers.
class ChartWheel extends StatelessWidget {
  const ChartWheel({required this.chart, super.key});

  final NatalChart chart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = WheelPalette.of(Theme.of(context).colorScheme);
    return Semantics(
      container: true,
      image: true,
      label: l10n.chartWheelLabel,
      excludeSemantics: true,
      child: AspectRatio(
        aspectRatio: 1,
        child: RepaintBoundary(
          child: CustomPaint(
            painter: ChartWheelPainter(
              chart: chart,
              aspects: natalAspects(chart),
              palette: palette,
            ),
          ),
        ),
      ),
    );
  }
}

/// Draws a [ChartWheel]. All sizes are fractions of the wheel's radius, so it
/// looks the same at any width and ignores the system text scale.
class ChartWheelPainter extends CustomPainter {
  ChartWheelPainter({
    required this.chart,
    required this.aspects,
    required this.palette,
  });

  final NatalChart chart;
  final List<Aspect> aspects;
  final WheelPalette palette;

  // Radii, as fractions of the wheel radius.
  static const _signBandInner = 0.86;
  static const _houseBandInner = 0.74;
  static const _planetRing = 0.62;
  static const _aspectRing = 0.44;

  /// Room left outside the ring for the AC and MC labels.
  static const _margin = 1.14;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 / _margin;
    final rotation = chart.ascendant ?? 0;
    final housesKnown = chart.ascendant != null;

    Offset at(double longitude, double fraction) {
      final angle = wheelAngle(longitude, rotation: rotation);
      return center +
          Offset(math.cos(angle), math.sin(angle)) * (radius * fraction);
    }

    _paintBands(canvas, center, radius, at, housesKnown);
    _paintAspects(canvas, at);
    _paintPlanets(canvas, radius, at);
    if (housesKnown) _paintAxes(canvas, radius, at);
  }

  void _paintBands(
    Canvas canvas,
    Offset center,
    double radius,
    Offset Function(double, double) at,
    bool housesKnown,
  ) {
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = palette.line;
    final band = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * (1 - _signBandInner)
      ..color = palette.band.withValues(alpha: 0.55);
    canvas
      ..drawCircle(center, radius * (1 + _signBandInner) / 2, band)
      ..drawCircle(center, radius, stroke)
      ..drawCircle(center, radius * _signBandInner, stroke)
      ..drawCircle(center, radius * _aspectRing, stroke);

    final rotation = chart.ascendant ?? 0;
    // The sign borders; with a known time they are the house borders too.
    for (var i = 0; i < 12; i++) {
      final border = i * degreesPerSign;
      canvas.drawLine(
        at(border, housesKnown ? _aspectRing : _signBandInner),
        at(border, 1),
        stroke..color = palette.line.withValues(alpha: housesKnown ? 0.5 : 1),
      );
      _paintText(
        canvas,
        signGlyph(ZodiacSign.values[i]),
        at(border + degreesPerSign / 2, (1 + _signBandInner) / 2),
        radius * 0.085,
        palette.text,
        symbols: true,
      );
      if (housesKnown) {
        final house = (i - signOfLongitude(rotation).index) % 12 + 1;
        _paintText(
          canvas,
          '$house',
          at(
            border + degreesPerSign / 2,
            (_signBandInner + _houseBandInner) / 2,
          ),
          radius * 0.06,
          palette.quietText,
        );
      }
    }
    if (housesKnown) {
      canvas.drawCircle(
        center,
        radius * _houseBandInner,
        stroke..color = palette.line,
      );
    }
  }

  void _paintAspects(Canvas canvas, Offset Function(double, double) at) {
    // The weakest first, so the tight ones end up on top.
    for (final aspect in aspects.reversed) {
      final from = chart.placementOf(aspect.a).longitude;
      final to = chart.placementOf(aspect.b).longitude;
      canvas.drawLine(
        at(from, _aspectRing),
        at(to, _aspectRing),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = aspect.type == AspectType.conjunction ? 1 : 1.5
          ..strokeCap = StrokeCap.round
          ..color = palette
              .colorOf(aspect.type)
              .withValues(alpha: 0.3 + 0.7 * aspect.strength),
      );
    }
  }

  void _paintPlanets(
    Canvas canvas,
    double radius,
    Offset Function(double, double) at,
  ) {
    final glyphSize = radius * 0.095;
    final longitudes = [for (final p in chart.placements) p.longitude];
    // Keep glyphs about one and a quarter glyph widths apart on the ring.
    final minGap = math.min(
      glyphSize * 1.25 / (radius * _planetRing) * 180 / math.pi,
      360 / longitudes.length - 1,
    );
    final spread = spreadLongitudes(longitudes, minGap: minGap);
    final tick = Paint()
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..color = palette.text;
    for (var i = 0; i < chart.placements.length; i++) {
      final placement = chart.placements[i];
      canvas.drawLine(
        at(placement.longitude, _houseBandInner),
        at(placement.longitude, _houseBandInner - 0.035),
        tick,
      );
      _paintText(
        canvas,
        bodyGlyph(placement.body),
        at(spread[i], _planetRing),
        glyphSize,
        palette.text,
        symbols: true,
      );
    }
  }

  void _paintAxes(
    Canvas canvas,
    double radius,
    Offset Function(double, double) at,
  ) {
    final axis = Paint()
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..color = palette.axis;
    for (final (longitude, label) in [
      (chart.ascendant!, 'AC'),
      (chart.midheaven!, 'MC'),
    ]) {
      canvas.drawLine(at(longitude, _signBandInner), at(longitude, 1.03), axis);
      _paintText(
        canvas,
        label,
        at(longitude, 1.09),
        radius * 0.065,
        palette.axis,
        bold: true,
      );
    }
  }

  void _paintText(
    Canvas canvas,
    String text,
    Offset center,
    double fontSize,
    Color color, {
    bool symbols = false,
    bool bold = false,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.w700 : null,
          fontFamily: symbols ? symbolsFontFamily : null,
          // Glyph metrics differ between fonts; keep the line box tight.
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
      textScaler: TextScaler.noScaling,
    )..layout();
    painter
      ..paint(canvas, center - Offset(painter.width, painter.height) / 2)
      ..dispose();
  }

  @override
  bool shouldRepaint(ChartWheelPainter oldDelegate) =>
      oldDelegate.chart != chart ||
      oldDelegate.palette != palette ||
      oldDelegate.aspects.length != aspects.length;
}
