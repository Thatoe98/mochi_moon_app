import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/astro/synastry.dart';

/// PRD §9.6 calibration: over 10,000 seeded random pairs the median overall
/// score must be 62–78, and fewer than 5% may be 40 or lower. If this fails,
/// change the base (60) or the multiplier (8), never the clamp, and update
/// the PRD.
void main() {
  const poolSize = 1000;
  const pairCount = 10000;

  late List<NatalChart> pool;

  setUpAll(() {
    final random = math.Random(9);
    // People who might date: born 1960–2008, anywhere on Earth, any time of
    // day, with the birthplace on the clock of UTC (the engine only needs a
    // valid zone, and the spread of the Sun and planets does not depend on it).
    pool = [
      for (var i = 0; i < poolSize; i++)
        computeNatalChart(
          BirthData(
            birthDate: DateTime(
              1960 + random.nextInt(49),
              1 + random.nextInt(12),
              1 + random.nextInt(28),
            ),
            birthMinutes: random.nextInt(24 * 60),
            tzId: 'UTC',
            latitude: -55 + random.nextDouble() * 110,
            longitude: -180 + random.nextDouble() * 360,
          ),
        ),
    ];
  });

  List<int> scores({required bool light}) {
    final random = math.Random(31);
    final result = <int>[];
    for (var i = 0; i < pairCount; i++) {
      final first = random.nextInt(poolSize);
      var second = random.nextInt(poolSize - 1);
      if (second >= first) second++;
      var a = pool[first];
      var b = pool[second];
      if (light) {
        a = _withoutTime(a);
        b = _withoutTime(b);
      }
      result.add(synastry(a, b).overall);
    }
    return result..sort();
  }

  test('full readings: median 62–78 and under 5% at 40 or lower', () {
    final all = scores(light: false);
    final median = (all[pairCount ~/ 2 - 1] + all[pairCount ~/ 2]) / 2;
    final low = all.where((score) => score <= 40).length / pairCount;
    // The numbers are the point of this test; keep them in the log.
    // ignore: avoid_print
    print(
      'full: median $median, ≤40 ${(low * 100).toStringAsFixed(2)}%, '
      'min ${all.first}, max ${all.last}',
    );
    expect(median, inInclusiveRange(62, 78));
    expect(low, lessThan(0.05));
  });

  test('light readings stay in a sensible range too', () {
    final all = scores(light: true);
    final median = (all[pairCount ~/ 2 - 1] + all[pairCount ~/ 2]) / 2;
    final low = all.where((score) => score <= 40).length / pairCount;
    // The numbers are the point of this test; keep them in the log.
    // ignore: avoid_print
    print(
      'light: median $median, ≤40 ${(low * 100).toStringAsFixed(2)}%, '
      'min ${all.first}, max ${all.last}',
    );
    expect(median, inInclusiveRange(62, 78));
    expect(low, lessThan(0.05));
  });
}

/// The same chart as if its time had not been given: no angles.
NatalChart _withoutTime(NatalChart chart) => NatalChart(
  birthUtc: chart.birthUtc,
  timeKnown: false,
  placements: chart.placements,
);
