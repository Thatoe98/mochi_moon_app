import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/cosmic/astro/ephemeris.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';

/// Allowed error for planets and the Moon (PRD §9.7).
const _planetToleranceDegrees = 0.5;

/// Allowed error for the Sun (PRD §9.7).
const _sunToleranceDegrees = 0.3;

/// Smallest difference between two angles, in [0, 180].
double _angularDistance(double a, double b) {
  final difference = (a - b).abs() % 360;
  return difference > 180 ? 360 - difference : difference;
}

typedef _Golden = ({DateTime utc, Map<String, double> longitudes});

List<_Golden> _loadGolden() {
  final file = File('test/features/cosmic/astro/golden_positions.json');
  final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  return [
    for (final entry in json['positions'] as List<dynamic>)
      (
        utc: DateTime.parse((entry as Map<String, dynamic>)['utc'] as String),
        longitudes: {
          for (final e in (entry['longitudes'] as Map<String, dynamic>).entries)
            e.key: (e.value as num).toDouble(),
        },
      ),
  ];
}

void main() {
  final golden = _loadGolden();

  test('golden file covers every body at 20 or more instants', () {
    expect(golden.length, greaterThanOrEqualTo(20));
    for (final entry in golden) {
      expect(
        entry.longitudes.keys.toSet(),
        Body.values.map((b) => b.name).toSet(),
      );
    }
  });

  group('planetPositions against JPL Horizons', () {
    for (final entry in golden) {
      test(entry.utc.toIso8601String(), () {
        final placements = planetPositions(entry.utc);
        expect(placements.map((p) => p.body), Body.values);
        for (final placement in placements) {
          final expected = entry.longitudes[placement.body.name]!;
          final tolerance = placement.body == Body.sun
              ? _sunToleranceDegrees
              : _planetToleranceDegrees;
          final error = _angularDistance(placement.longitude, expected);
          expect(
            error,
            lessThan(tolerance),
            reason:
                '${placement.body.name}: got ${placement.longitude}, '
                'Horizons says $expected',
          );
          // Signs must match exactly, except when the reference sits within
          // the tolerance of a cusp and either answer is defensible.
          final cuspDistance = _angularDistance(
            expected,
            (expected / degreesPerSign).roundToDouble() * degreesPerSign,
          );
          if (cuspDistance > tolerance) {
            expect(
              placement.sign,
              signOfLongitude(expected),
              reason: '${placement.body.name} sign',
            );
          }
        }
      });
    }
  });

  group('julianDay', () {
    test('J2000 is 2451545.0', () {
      expect(julianDay(DateTime.utc(2000, 1, 1, 12)), 2451545.0);
    });

    test('Unix epoch is 2440587.5', () {
      expect(julianDay(DateTime.utc(1970)), 2440587.5);
    });

    test('rejects local times', () {
      expect(() => julianDay(DateTime(2000)), throwsArgumentError);
    });
  });

  group('invariants', () {
    test('longitudes are always in [0, 360)', () {
      for (var year = 1940; year <= 2040; year += 3) {
        for (final placement in planetPositions(DateTime.utc(year, 3, 21))) {
          expect(placement.longitude, inInclusiveRange(0, 360));
          expect(placement.longitude, lessThan(360));
          expect(placement.degreeInSign, inInclusiveRange(0, 30));
        }
      }
    });

    test('the Sun and Moon are never retrograde', () {
      for (var day = 0; day < 400; day += 7) {
        final utc = DateTime.utc(2026).add(Duration(days: day));
        final placements = planetPositions(utc);
        expect(placements[Body.sun.index].isRetrograde, isFalse);
        expect(placements[Body.moon.index].isRetrograde, isFalse);
      }
    });

    test('speeds are plausible', () {
      final placements = planetPositions(DateTime.utc(2026, 10, 29, 12));
      expect(placements[Body.sun.index].speed, closeTo(1, 0.1));
      expect(placements[Body.moon.index].speed, inInclusiveRange(11.5, 15.5));
      for (final placement in placements.skip(Body.mercury.index)) {
        expect(placement.speed.abs(), lessThan(2.5), reason: '$placement');
      }
    });

    test('a call is fast enough for a natal chart (PRD §10: < 200 ms)', () {
      final stopwatch = Stopwatch()..start();
      planetPositions(DateTime.utc(1990, 7, 4, 16));
      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(200));
    });
  });

  group('retrograde flag', () {
    Placement mercuryAt(DateTime utc) =>
        planetPositions(utc)[Body.mercury.index];

    // Published Mercury retrogrades (PRD §9.5): Oct 24 - Nov 13 2026,
    // Feb 9 - Mar 3 2027, Jun 10 - Jul 4 2027.
    test('Mercury is retrograde inside the published windows', () {
      expect(mercuryAt(DateTime.utc(2026, 11, 3)).isRetrograde, isTrue);
      expect(mercuryAt(DateTime.utc(2027, 2, 20)).isRetrograde, isTrue);
      expect(mercuryAt(DateTime.utc(2027, 6, 20)).isRetrograde, isTrue);
    });

    test('Mercury is direct outside them', () {
      expect(mercuryAt(DateTime.utc(2026, 10, 15)).isRetrograde, isFalse);
      expect(mercuryAt(DateTime.utc(2026, 11, 25)).isRetrograde, isFalse);
      expect(mercuryAt(DateTime.utc(2027, 4, 15)).isRetrograde, isFalse);
    });

    test('the flag flips close to the published station dates', () {
      expect(mercuryAt(DateTime.utc(2026, 10, 23)).isRetrograde, isFalse);
      expect(mercuryAt(DateTime.utc(2026, 10, 26)).isRetrograde, isTrue);
      expect(mercuryAt(DateTime.utc(2026, 11, 11)).isRetrograde, isTrue);
      expect(mercuryAt(DateTime.utc(2026, 11, 15)).isRetrograde, isFalse);
    });
  });
}
