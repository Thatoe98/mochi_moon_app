import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/breathe/domain/breathing_session.dart';

BreathState at(double seconds) =>
    breathStateAt(Duration(milliseconds: (seconds * 1000).round()));

void main() {
  test('a session lasts about a minute', () {
    expect(breathSessionLength, const Duration(seconds: 64));
  });

  test('the four beats follow in order, four seconds each', () {
    expect(at(0).phase, BreathPhase.inhale);
    expect(at(3.9).phase, BreathPhase.inhale);
    expect(at(4).phase, BreathPhase.holdFull);
    expect(at(8).phase, BreathPhase.exhale);
    expect(at(12).phase, BreathPhase.holdEmpty);
    expect(at(16).phase, BreathPhase.inhale);
  });

  test('the seconds count down from four to one', () {
    expect(at(0).secondsLeft, 4);
    expect(at(1.5).secondsLeft, 3);
    expect(at(3.9).secondsLeft, 1);
    expect(at(4).secondsLeft, 4);
  });

  test('Mochi grows on the way in and shrinks on the way out', () {
    expect(at(0).size, 0);
    expect(at(2).size, closeTo(0.5, 0.001));
    expect(at(5).size, 1);
    expect(at(10).size, closeTo(0.5, 0.001));
    expect(at(13).size, 0);
  });

  test('rounds count from one to four, then the session finishes', () {
    expect(at(0).round, 1);
    expect(at(16).round, 2);
    expect(at(63.9).round, breathRounds);
    expect(at(63.9).finished, isFalse);
    expect(at(64).finished, isTrue);
    expect(at(500).finished, isTrue);
  });

  test('negative time is clamped to the start', () {
    expect(
      breathStateAt(const Duration(seconds: -3)).phase,
      BreathPhase.inhale,
    );
  });
}
