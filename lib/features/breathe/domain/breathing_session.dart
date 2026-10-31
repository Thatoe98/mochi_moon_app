/// The four beats of box breathing (PRD §6.19).
enum BreathPhase { inhale, holdFull, exhale, holdEmpty }

/// Seconds in each beat.
const breathPhaseSeconds = 4;

/// Rounds of four beats in one session: 4 × 16 s, about a minute.
const breathRounds = 4;

/// How long one session lasts.
const breathSessionLength = Duration(
  seconds: breathPhaseSeconds * 4 * breathRounds,
);

/// Where the session is at a moment: pure maths on elapsed time, so a test can
/// check any second without a clock.
class BreathState {
  const BreathState({
    required this.phase,
    required this.round,
    required this.secondsLeft,
    required this.phaseProgress,
    required this.size,
    required this.finished,
  });

  final BreathPhase phase;

  /// 1-based round, up to `breathRounds`.
  final int round;

  /// Whole seconds left in this beat, 4 down to 1.
  final int secondsLeft;

  /// 0 at the start of the beat, 1 at its end.
  final double phaseProgress;

  /// How big Mochi is: 0 (small) when lungs are empty, 1 (big) when full.
  final double size;

  final bool finished;
}

/// The state after [elapsed] time. Anything past the end is "finished".
BreathState breathStateAt(Duration elapsed) {
  const beatMs = breathPhaseSeconds * 1000;
  const roundMs = beatMs * 4;
  const totalMs = roundMs * breathRounds;
  final ms = elapsed.inMilliseconds.clamp(0, totalMs);
  if (ms >= totalMs) {
    return const BreathState(
      phase: BreathPhase.holdEmpty,
      round: breathRounds,
      secondsLeft: 0,
      phaseProgress: 1,
      size: 0,
      finished: true,
    );
  }
  final round = ms ~/ roundMs;
  final inRound = ms % roundMs;
  final phase = BreathPhase.values[inRound ~/ beatMs];
  final inBeat = inRound % beatMs;
  final progress = inBeat / beatMs;
  final size = switch (phase) {
    BreathPhase.inhale => progress,
    BreathPhase.holdFull => 1.0,
    BreathPhase.exhale => 1 - progress,
    BreathPhase.holdEmpty => 0.0,
  };
  return BreathState(
    phase: phase,
    round: round + 1,
    secondsLeft: breathPhaseSeconds - inBeat ~/ 1000,
    phaseProgress: progress,
    size: size,
    finished: false,
  );
}
