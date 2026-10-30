import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:astronomia/astronomia.dart' as am;
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/cosmic/astro/angles.dart';
import 'package:mochi_moon/features/cosmic/astro/ephemeris.dart';
import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';

/// Allowed error for planets and the Moon (PRD §9.7).
const _planetToleranceDegrees = 0.5;

/// Allowed error for the Sun (PRD §9.7).
const _sunToleranceDegrees = 0.3;

/// Allowed error for the Ascendant and Midheaven: far stricter than the PRD,
/// because the formulas are exact and only nutation and ΔT differ.
const _angleToleranceDegrees = 0.1;

double _angularDistance(double a, double b) {
  final difference = (a - b).abs() % 360;
  return difference > 180 ? 360 - difference : difference;
}

Map<String, dynamic> _loadGolden() => jsonDecode(
  File('test/features/cosmic/astro/golden_charts.json').readAsStringSync(),
) as Map<String, dynamic>;

BirthData _birthData(Map<String, dynamic> chart) => BirthData(
  birthDate: DateTime.parse(chart['birthDate'] as String),
  birthMinutes: chart['birthMinutes'] as int?,
  tzId: chart['tzId'] as String,
  latitude: (chart['latitude'] as num).toDouble(),
  longitude: (chart['longitude'] as num).toDouble(),
);

void main() {
  final charts = [
    for (final c in _loadGolden()['charts'] as List<dynamic>)
      c as Map<String, dynamic>,
  ];

  group('golden charts (Swiss Ephemeris oracle)', () {
    test('cover both hemispheres, the old days and high latitudes', () {
      expect(charts.length, greaterThanOrEqualTo(20));
      final lats = [for (final c in charts) (c['latitude'] as num).toDouble()];
      expect(lats.any((l) => l > 0), isTrue);
      expect(lats.any((l) => l < 0), isTrue);
      expect(lats.any((l) => l.abs() > 66), isTrue);
      expect(
        charts.any((c) => (c['birthDate'] as String).compareTo('1970') < 0),
        isTrue,
      );
      expect(charts.any((c) => c['birthMinutes'] == null), isTrue);
      final zones = {for (final c in charts) c['tzId']};
      expect(zones, containsAll(['Asia/Bangkok', 'Asia/Yangon']));
    });

    for (final c in charts) {
      test(c['id'] as String, () {
        final chart = computeNatalChart(_birthData(c));

        expect(
          chart.birthUtc,
          DateTime.parse(c['utc'] as String),
          reason: 'local time to UTC',
        );
        expect(chart.timeKnown, c['birthMinutes'] != null);

        final planets = c['planets'] as Map<String, dynamic>;
        for (final body in Body.values) {
          final expected = planets[body.name] as Map<String, dynamic>;
          final placement = chart.placementOf(body);
          final tolerance = body == Body.sun
              ? _sunToleranceDegrees
              : _planetToleranceDegrees;
          expect(
            _angularDistance(
              placement.longitude,
              (expected['longitude'] as num).toDouble(),
            ),
            lessThan(tolerance),
            reason: '${body.name} longitude',
          );
          expect(
            placement.sign.name,
            expected['sign'],
            reason: '${body.name} sign',
          );
          expect(
            placement.isRetrograde,
            expected['retrograde'],
            reason: '${body.name} retrograde',
          );
        }

        if (c['birthMinutes'] == null) {
          expect(chart.ascendant, isNull);
          expect(chart.midheaven, isNull);
          expect(chart.ascendantSign, isNull);
          expect(chart.houseOf(Body.sun), isNull);
          expect(chart.moonIsApproximate, isTrue);
          return;
        }

        expect(chart.moonIsApproximate, isFalse);
        expect(
          _angularDistance(
            chart.ascendant!,
            (c['ascendant'] as num).toDouble(),
          ),
          lessThan(_angleToleranceDegrees),
          reason: 'ascendant longitude',
        );
        expect(chart.ascendantSign!.name, c['ascendantSign']);
        expect(
          _angularDistance(
            chart.midheaven!,
            (c['midheaven'] as num).toDouble(),
          ),
          lessThan(_angleToleranceDegrees),
          reason: 'midheaven longitude',
        );
        expect(chart.midheavenSign!.name, c['midheavenSign']);

        final houses = c['houses'] as Map<String, dynamic>;
        for (final body in Body.values) {
          expect(
            chart.houseOf(body),
            houses[body.name],
            reason: '${body.name} house',
          );
        }
        expect(chart.risingMayBeUnreliable, (c['latitude'] as num).abs() > 66);
      });
    }
  });

  group('chartAngles', () {
    final utc = DateTime.utc(2001, 3, 21, 6);

    // Longitude at which the local apparent sidereal time is [theta] degrees.
    double longitudeFor(double theta) =>
        normalizeDegrees(theta - am.apparent(julianDay(utc)) / 240);

    test(
      'PRD §9.3 sanity: on the equator ASC is 90° past a meridian at 0°',
      () {
        final angles = chartAngles(
          utc: utc,
          latitude: 0,
          longitude: longitudeFor(0),
        );
        expect(_angularDistance(angles.midheaven, 0), lessThan(1e-9));
        expect(_angularDistance(angles.ascendant, 90), lessThan(1e-9));
      },
    );

    test(
      'on the equator the horizon meets 0° Cancer when the meridian is 90°',
      () {
        final angles = chartAngles(
          utc: utc,
          latitude: 0,
          longitude: longitudeFor(90),
        );
        expect(_angularDistance(angles.midheaven, 90), lessThan(1e-9));
        expect(_angularDistance(angles.ascendant, 180), lessThan(1e-9));
      },
    );

    test('angles stay inside [0, 360) around the world and clock', () {
      final random = math.Random(9);
      for (var i = 0; i < 400; i++) {
        final angles = chartAngles(
          utc: DateTime.utc(1940)
              .add(Duration(minutes: random.nextInt(90 * 365 * 24 * 60))),
          latitude: random.nextDouble() * 140 - 70,
          longitude: random.nextDouble() * 360 - 180,
        );
        expect(angles.ascendant, inInclusiveRange(0, 360));
        expect(angles.ascendant, lessThan(360));
        expect(angles.midheaven, inInclusiveRange(0, 360));
        expect(angles.midheaven, lessThan(360));
      }
    });

    test('the Midheaven does not depend on latitude', () {
      final north = chartAngles(utc: utc, latitude: 60, longitude: 96);
      final south = chartAngles(utc: utc, latitude: -45, longitude: 96);
      expect(north.midheaven, closeTo(south.midheaven, 1e-9));
    });

    test('the Ascendant turns once a sidereal day', () {
      final start = chartAngles(utc: utc, latitude: 17, longitude: 96);
      final later = chartAngles(
        utc: utc.add(const Duration(hours: 23, minutes: 56, seconds: 4)),
        latitude: 17,
        longitude: 96,
      );
      expect(_angularDistance(start.ascendant, later.ascendant), lessThan(0.1));
    });
  });

  group('NatalChart', () {
    final known = computeNatalChart(
      BirthData(
        birthDate: DateTime(2001, 3, 21),
        birthMinutes: 6 * 60 + 15,
        tzId: 'Asia/Yangon',
        latitude: 16.8409,
        longitude: 96.1735,
      ),
    );

    test('house 1 is the Ascendant sign and houses run around the zodiac', () {
      final rising = known.ascendantSign!;
      expect(known.houseOfSign(rising), 1);
      for (final sign in ZodiacSign.values) {
        final expected = (sign.index - rising.index + 12) % 12 + 1;
        expect(known.houseOfSign(sign), expected);
      }
      expect(ZodiacSign.values.map(known.houseOfSign).toSet(), {
        for (var i = 1; i <= 12; i++) i,
      });
    });

    test('a planet is in the house of its sign', () {
      for (final body in Body.values) {
        expect(
          known.houseOf(body),
          known.houseOfSign(known.placementOf(body).sign),
        );
      }
    });

    test('an unknown birth time has no angles or houses', () {
      final chart = computeNatalChart(
        BirthData(
          birthDate: DateTime(2001, 3, 21),
          tzId: 'Asia/Yangon',
          latitude: 16.8409,
          longitude: 96.1735,
        ),
      );
      expect(chart.timeKnown, isFalse);
      expect(chart.moonIsApproximate, isTrue);
      expect(chart.ascendant, isNull);
      expect(chart.midheaven, isNull);
      expect(chart.houseOf(Body.moon), isNull);
      // Noon at +6:30 is 05:30 UTC.
      expect(chart.birthUtc, DateTime.utc(2001, 3, 21, 5, 30));
      expect(chart.placements, hasLength(Body.values.length));
    });

    test('an unknown birthplace has no angles even with a time', () {
      final chart = computeNatalChart(
        BirthData(
          birthDate: DateTime(2001, 3, 21),
          birthMinutes: 6 * 60 + 15,
          tzId: 'UTC',
        ),
      );
      expect(chart.timeKnown, isTrue);
      expect(chart.ascendant, isNull);
      expect(chart.houseOf(Body.sun), isNull);
    });

    test('flags the Ascendant beyond 66° of latitude only', () {
      BirthData at(double lat) => BirthData(
        birthDate: DateTime(2003, 6, 21),
        birthMinutes: 12 * 60,
        tzId: 'Europe/Oslo',
        latitude: lat,
        longitude: 18.9553,
      );
      expect(computeNatalChart(at(66)).risingMayBeUnreliable, isFalse);
      expect(computeNatalChart(at(-66.5)).risingMayBeUnreliable, isTrue);
      expect(computeNatalChart(at(69.65)).risingMayBeUnreliable, isTrue);
      expect(computeNatalChart(at(69.65)).ascendant, isNotNull);
    });
  });
}
