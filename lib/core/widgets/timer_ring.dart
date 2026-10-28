import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';

/// A ring that fills over [duration], then calls [onCompleted] once.
///
/// Pass [completed] to start full (and silent), e.g. for a card that was
/// already read. Give it a new `key` to restart it. The ring keeps animating
/// when the system asks for reduced motion: it is the read-aloud gate, not
/// decoration.
class TimerRing extends StatefulWidget {
  const TimerRing({
    required this.duration,
    required this.onCompleted,
    this.completed = false,
    super.key,
  });

  final Duration duration;
  final VoidCallback onCompleted;
  final bool completed;

  @override
  State<TimerRing> createState() => _TimerRingState();
}

class _TimerRingState extends State<TimerRing>
    with SingleTickerProviderStateMixin {
  static const double _size = AppSpacing.minTouchTarget + AppSpacing.sm;
  static const double _strokeWidth = AppSpacing.xs * 1.5;

  late final AnimationController _controller;
  late bool _done;

  @override
  void initState() {
    super.initState();
    _done = widget.completed;
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: _done ? 1 : 0,
    );
    if (!_done) {
      _controller
        ..addStatusListener(_onStatus)
        ..forward();
    }
  }

  void _onStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    setState(() => _done = true);
    widget.onCompleted();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Semantics(
      label: l10n.deckTimerSemantics,
      value: _done ? l10n.deckTimerReady : null,
      liveRegion: true,
      child: ExcludeSemantics(
        child: SizedBox.square(
          dimension: _size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) => CustomPaint(
                  size: const Size.square(_size),
                  painter: _RingPainter(
                    progress: _controller.value,
                    track: theme.colorScheme.primaryContainer,
                    fill: theme.colorScheme.primary,
                    strokeWidth: _strokeWidth,
                  ),
                ),
              ),
              if (_done)
                Icon(
                  Icons.check_rounded,
                  size: _size / 2,
                  color: theme.colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.track,
    required this.fill,
    required this.strokeWidth,
  });

  final double progress;
  final Color track;
  final Color fill;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(strokeWidth / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas
      ..drawArc(rect, 0, 2 * math.pi, false, paint..color = track)
      ..drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        paint..color = fill,
      );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.track != track || old.fill != fill;
}
