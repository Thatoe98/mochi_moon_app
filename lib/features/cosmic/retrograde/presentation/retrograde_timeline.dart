import 'package:flutter/material.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/features/cosmic/astro/retrogrades.dart';

/// The three band colors, from the theme, shared by the bars and the legend.
class RetrogradePalette {
  RetrogradePalette(ColorScheme scheme)
    : track = scheme.surfaceContainerHighest,
      shadow = scheme.secondaryContainer,
      retrograde = scheme.primary,
      marker = scheme.onSurface;

  final Color track;
  final Color shadow;
  final Color retrograde;
  final Color marker;
}

/// One calendar year as a bar with each retrograde's pre-shadow, retrograde
/// and post-shadow bands, and a marker for [now]. Purely visual: the dates are
/// also listed as text beside it, so the bar is hidden from screen readers.
class RetrogradeTimeline extends StatelessWidget {
  const RetrogradeTimeline({
    required this.year,
    required this.periods,
    required this.now,
    super.key,
  });

  static const double height = 16;

  final int year;
  final List<RetrogradePeriod> periods;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final palette = RetrogradePalette(Theme.of(context).colorScheme);
    return ExcludeSemantics(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(
          painter: _TimelinePainter(
            year: year,
            periods: periods,
            now: now.toUtc(),
            palette: palette,
          ),
        ),
      ),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  _TimelinePainter({
    required this.year,
    required this.periods,
    required this.now,
    required this.palette,
  });

  final int year;
  final List<RetrogradePeriod> periods;
  final DateTime now;
  final RetrogradePalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final start = DateTime.utc(year);
    final span = DateTime.utc(year + 1).difference(start).inMinutes;

    double x(DateTime utc) =>
        (utc.difference(start).inMinutes / span).clamp(0.0, 1.0) * size.width;

    final bar = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(AppRadii.chip),
    );
    canvas
      ..save()
      ..clipRRect(bar)
      ..drawRect(Offset.zero & size, Paint()..color = palette.track);

    void band(DateTime from, DateTime to, Color color) {
      final left = x(from);
      final right = x(to);
      if (right <= left) return;
      canvas.drawRect(
        Rect.fromLTRB(left, 0, right, size.height),
        Paint()..color = color,
      );
    }

    for (final period in periods) {
      band(period.preShadowStart, period.retrogradeStart, palette.shadow);
      band(period.retrogradeEnd, period.postShadowEnd, palette.shadow);
      band(period.retrogradeStart, period.retrogradeEnd, palette.retrograde);
    }
    canvas.restore();

    if (now.year == year) {
      final at = x(now);
      canvas.drawLine(
        Offset(at, 0),
        Offset(at, size.height),
        Paint()
          ..color = palette.marker
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(_TimelinePainter old) =>
      old.year != year ||
      old.periods != periods ||
      old.now != now ||
      old.palette.track != palette.track ||
      old.palette.shadow != palette.shadow ||
      old.palette.retrograde != palette.retrograde ||
      old.palette.marker != palette.marker;
}
