import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The Moon disc with its lit part, drawn from the phase (PRD §6.8). Seen from
/// the northern hemisphere: the right side lights up while it waxes, the left
/// side while it wanes. It is decorative: the phase name written beside it
/// carries the meaning for screen readers.
class MoonGlyph extends StatelessWidget {
  const MoonGlyph({
    required this.illumination,
    required this.isWaxing,
    required this.size,
    super.key,
  });

  /// Lit fraction of the disc, from 0 (new) to 1 (full).
  final double illumination;
  final bool isWaxing;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size.square(size),
        painter: _MoonPainter(
          illumination: illumination,
          isWaxing: isWaxing,
          lit: scheme.primary,
          dark: scheme.surfaceContainerHighest,
          outline: scheme.outlineVariant,
        ),
      ),
    );
  }
}

class _MoonPainter extends CustomPainter {
  const _MoonPainter({
    required this.illumination,
    required this.isWaxing,
    required this.lit,
    required this.dark,
    required this.outline,
  });

  final double illumination;
  final bool isWaxing;
  final Color lit;
  final Color dark;
  final Color outline;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final disc = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(center, radius, Paint()..color = dark);

    // The lit part: the limb on the lit side, then back along the terminator.
    // The terminator is half an ellipse as wide as the unlit share of the
    // radius; it bulges toward the lit side for a crescent and away from it
    // for a gibbous moon.
    final terminatorRadius = radius * (1 - 2 * illumination).abs();
    final terminator = Rect.fromCenter(
      center: center,
      width: terminatorRadius * 2,
      height: radius * 2,
    );
    final crescent = illumination < 0.5;
    final path = Path()
      ..arcTo(disc, -math.pi / 2, math.pi, true)
      ..arcTo(terminator, math.pi / 2, crescent ? -math.pi : math.pi, false)
      ..close();

    canvas
      ..save()
      ..translate(isWaxing ? 0 : size.width, 0)
      ..scale(isWaxing ? 1 : -1, 1)
      ..drawPath(path, Paint()..color = lit)
      ..restore()
      ..drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = outline,
      );
  }

  @override
  bool shouldRepaint(_MoonPainter old) =>
      old.illumination != illumination ||
      old.isWaxing != isWaxing ||
      old.lit != lit ||
      old.dark != dark ||
      old.outline != outline;
}
