import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';
import 'package:mochi_moon/features/breathe/domain/breathing_session.dart';

enum _Stage { intro, running, finished }

/// Breathe with Mochi (PRD §6.19): a one-minute box breathing session. Works
/// offline with no account, and needs no permission. With reduce motion on,
/// Mochi stays still and the cue text plus the progress ring carry the rhythm.
class BreatheScreen extends StatefulWidget {
  const BreatheScreen({super.key});

  @override
  State<BreatheScreen> createState() => _BreatheScreenState();
}

class _BreatheScreenState extends State<BreatheScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  _Stage _stage = _Stage.intro;
  bool _haptics = true;
  BreathPhase? _lastPhase;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: breathSessionLength)
          ..addListener(_onTick)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed && mounted) {
              setState(() => _stage = _Stage.finished);
            }
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  BreathState get _state => breathStateAt(
    Duration(
      microseconds: (breathSessionLength.inMicroseconds * _controller.value)
          .round(),
    ),
  );

  void _onTick() {
    final phase = _state.phase;
    if (_stage == _Stage.running && phase != _lastPhase) {
      _lastPhase = phase;
      if (_haptics) unawaited(HapticFeedback.selectionClick());
    }
    setState(() {});
  }

  void _begin() {
    _lastPhase = null;
    setState(() => _stage = _Stage.running);
    _controller.forward(from: 0);
  }

  void _stop() {
    _controller.stop();
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      setState(() => _stage = _Stage.intro);
      _controller.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.breatheTitle),
        actions: [
          IconButton(
            tooltip: _haptics ? l10n.breatheHapticOn : l10n.breatheHapticOff,
            icon: Icon(
              _haptics ? Icons.vibration_rounded : Icons.mobile_off_rounded,
            ),
            onPressed: () => setState(() => _haptics = !_haptics),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: switch (_stage) {
            _Stage.intro => _Intro(onBegin: _begin),
            _Stage.running => _Running(state: _state, onStop: _stop),
            _Stage.finished => _Finished(onAgain: _begin, onDone: _stop),
          },
        ),
      ),
    );
  }
}

String _cue(AppLocalizations l10n, BreathPhase phase) => switch (phase) {
  BreathPhase.inhale => l10n.breatheIn,
  BreathPhase.holdFull || BreathPhase.holdEmpty => l10n.breatheHold,
  BreathPhase.exhale => l10n.breatheOut,
};

class _Intro extends StatelessWidget {
  const _Intro({required this.onBegin});

  final VoidCallback onBegin;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: 200,
              child: MochiIllustration(
                asset: AppIllustrations.calm,
                semanticLabel: l10n.illustrationCalm,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.breatheIntro,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(onPressed: onBegin, child: Text(l10n.breatheStart)),
          ],
        ),
      ),
    );
  }
}

class _Running extends StatelessWidget {
  const _Running({required this.state, required this.onStop});

  final BreathState state;
  final VoidCallback onStop;

  static const double _maxSize = 240;
  static const double _minScale = 0.6;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final scale = reduceMotion ? 1.0 : _minScale + (1 - _minScale) * state.size;
    final cue = _cue(l10n, state.phase);
    return Column(
      children: [
        Text(
          l10n.breatheRound(state.round, breathRounds),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Expanded(
          child: Center(
            child: SizedBox.square(
              dimension: _maxSize + AppSpacing.xl,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: state.phaseProgress,
                      strokeWidth: AppSpacing.sm,
                      color: scheme.primary,
                      backgroundColor: scheme.primaryContainer,
                      semanticsLabel: cue,
                    ),
                  ),
                  Transform.scale(
                    key: const Key('breathe-mochi'),
                    scale: scale,
                    child: SizedBox.square(
                      dimension: _maxSize - AppSpacing.xl,
                      child: MochiIllustration(
                        asset: AppIllustrations.calm,
                        semanticLabel: l10n.illustrationCalm,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Semantics(
          liveRegion: true,
          child: Text(
            cue,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        ExcludeSemantics(
          child: Text(
            '${state.secondsLeft}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextButton(onPressed: onStop, child: Text(l10n.breatheStop)),
      ],
    );
  }
}

class _Finished extends StatelessWidget {
  const _Finished({required this.onAgain, required this.onDone});

  final VoidCallback onAgain;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: 200,
              child: MochiIllustration(
                asset: AppIllustrations.healing,
                semanticLabel: l10n.illustrationHealing,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.breatheFinishTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.breatheFinishBody,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(onPressed: onDone, child: Text(l10n.breatheDone)),
            const SizedBox(height: AppSpacing.sm),
            TextButton(onPressed: onAgain, child: Text(l10n.breatheAgain)),
          ],
        ),
      ),
    );
  }
}
