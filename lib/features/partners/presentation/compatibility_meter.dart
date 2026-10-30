import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';

/// A soft ring that fills to [score] out of 100, with the number inside.
class CompatibilityMeter extends StatelessWidget {
  const CompatibilityMeter({required this.score, super.key});

  final int score;

  static const _size = 168.0;
  static const _stroke = 14.0;
  static const _fill = Duration(milliseconds: 400);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      label: l10n.compatMeterLabel(score),
      child: ExcludeSemantics(
        child: SizedBox.square(
          dimension: _size,
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: score / 100),
            duration: reduceMotion ? Duration.zero : _fill,
            curve: Curves.easeOut,
            builder: (context, value, child) => CustomPaint(
              painter: _RingPainter(
                value: value,
                track: theme.colorScheme.surfaceContainerHighest,
                fill: theme.colorScheme.primary,
              ),
              child: child,
            ),
            child: Center(
              child: Text('$score%', style: theme.textTheme.displaySmall),
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.value, required this.track, required this.fill});

  final double value;
  final Color track;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final arc = rect.deflate(CompatibilityMeter._stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = CompatibilityMeter._stroke
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawArc(arc, 0, 2 * math.pi, false, paint..color = track)
      ..drawArc(
        arc,
        -math.pi / 2,
        2 * math.pi * value,
        false,
        paint..color = fill,
      );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.track != track || old.fill != fill;
}
