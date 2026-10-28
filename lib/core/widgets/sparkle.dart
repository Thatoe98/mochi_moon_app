import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';

/// A one-shot burst of little stars that fills its parent and plays on mount.
///
/// Renders nothing when the system asks for reduced motion. It never takes
/// pointer events and is hidden from screen readers.
class Sparkle extends StatefulWidget {
  const Sparkle({super.key});

  @override
  State<Sparkle> createState() => _SparkleState();
}

class _SparkleState extends State<Sparkle> with SingleTickerProviderStateMixin {
  static const _count = 6;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return const SizedBox.shrink();
    }
    final scheme = Theme.of(context).colorScheme;
    return IgnorePointer(
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = Curves.easeOut.transform(_controller.value);
            return Stack(
              fit: StackFit.expand,
              children: [
                for (var i = 0; i < _count; i++)
                  Align(
                    alignment: Alignment(
                      math.cos(2 * math.pi * i / _count) * t,
                      math.sin(2 * math.pi * i / _count) * t,
                    ),
                    child: Opacity(
                      opacity: 1 - t,
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        size: AppSpacing.md,
                        color: i.isEven ? scheme.secondary : scheme.tertiary,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
