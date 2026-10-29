import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/cosmic/astro/ephemeris.dart';
import 'package:mochi_moon/features/cosmic/astro/moon_phase.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';

/// Horizons gives these times to the minute; the Moon is about 0.01° off.
const _tolerance = Duration(minutes: 10);

List<DateTime> _loadTimes(String key) {
  final file = File('test/features/cosmic/astro/golden_events.json');
  final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  return [
    for (final time in json[key] as List<dynamic>)
      DateTime.parse(time as String),
  ];
}

Duration _gap(DateTime a, DateTime b) => a.difference(b).abs();

void main() {
  final newMoons = _loadTimes('newMoons');
  final fullMoons = _loadTimes('fullMoons');

  group('next new and full moon', () {
    test('match Horizons from three days before each event', () {
      for (final time in newMoons) {
        final phase = moonPhase(time.subtract(const Duration(days: 3)));
        expect(
          _gap(phase.nextNewMoon, time),
          lessThan(_tolerance),
          reason: 'new moon $time, got ${phase.nextNewMoon}',
        );
      }
      for (final time in fullMoons) {
        final phase = moonPhase(time.subtract(const Duration(days: 3)));
        expect(
          _gap(phase.nextFullMoon, time),
          lessThan(_tolerance),
          reason: 'full moon $time, got ${phase.nextFullMoon}',
        );
      }
    });

    test('are strictly after the asked time, one lunation apart', () {
      for (var i = 0; i < newMoons.length - 1; i++) {
        final justAfter = moonPhase(newMoons[i].add(const Duration(hours: 1)));
        expect(
          _gap(justAfter.nextNewMoon, newMoons[i + 1]),
          lessThan(_tolerance),
        );
      }
    });

    test('are always within one lunation', () {
      var utc = DateTime.utc(2026, 10, 29);
      for (var i = 0; i < 60; i++) {
        final phase = moonPhase(utc);
        expect(phase.nextNewMoon.isAfter(utc), isTrue);
        expect(phase.nextFullMoon.isAfter(utc), isTrue);
        expect(
          phase.nextNewMoon.difference(utc),
          lessThan(const Duration(days: 30)),
        );
        expect(
          phase.nextFullMoon.difference(utc),
          lessThan(const Duration(days: 30)),
        );
        utc = utc.add(const Duration(days: 7, hours: 5));
      }
    });
  });

  group('moonPhase at the main phases', () {
    test('new moon is dark and named New', () {
      for (final time in newMoons) {
        final phase = moonPhase(time);
        expect(phase.illumination, lessThan(0.001));
        expect(phase.name, MoonPhaseName.newMoon);
      }
    });

    test('full moon is bright and named Full', () {
      for (final time in fullMoons) {
        final phase = moonPhase(time);
        expect(phase.illumination, greaterThan(0.999));
        expect(phase.name, MoonPhaseName.fullMoon);
      }
    });

    test('quarters are half lit', () {
      // About a week after new moon is the first quarter, and a week after
      // full moon the last.
      final first = moonPhase(newMoons.first.add(const Duration(days: 7, hours: 9)));
      expect(first.name, MoonPhaseName.firstQuarter);
      expect(first.illumination, closeTo(0.5, 0.1));
      expect(first.isWaxing, isTrue);

      final last = moonPhase(fullMoons.first.add(const Duration(days: 7, hours: 9)));
      expect(last.name, MoonPhaseName.lastQuarter);
      expect(last.illumination, closeTo(0.5, 0.1));
      expect(last.isWaxing, isFalse);
    });

    test('waxes after new moon and wanes after full moon', () {
      expect(
        moonPhase(newMoons.first.add(const Duration(days: 3))).isWaxing,
        isTrue,
      );
      expect(
        moonPhase(fullMoons.first.add(const Duration(days: 3))).isWaxing,
        isFalse,
      );
    });
  });

  group('moonPhase over a lunation', () {
    test('goes through all eight names in order', () {
      final names = <MoonPhaseName>[];
      var utc = newMoons.first.add(const Duration(hours: 1));
      final end = newMoons[1];
      while (utc.isBefore(end)) {
        final name = moonPhase(utc).name;
        if (names.isEmpty || names.last != name) names.add(name);
        utc = utc.add(const Duration(hours: 6));
      }
      // The last samples before the next new moon are "New" again.
      expect(names, [...MoonPhaseName.values, MoonPhaseName.newMoon]);
    });

    test('illumination stays between 0 and 1 and grows then shrinks', () {
      var previous = 0.0;
      var utc = newMoons.first;
      while (utc.isBefore(fullMoons.first)) {
        final illumination = moonPhase(utc).illumination;
        expect(illumination, inInclusiveRange(0, 1));
        expect(illumination, greaterThanOrEqualTo(previous - 1e-9));
        previous = illumination;
        utc = utc.add(const Duration(hours: 6));
      }
    });

    test('elongation is in [0, 360) and the Moon sign is the Moon sign', () {
      final utc = DateTime.utc(2026, 10, 29, 12);
      final phase = moonPhase(utc);
      expect(phase.elongation, inInclusiveRange(0, 360));
      expect(phase.elongation, lessThan(360));
      expect(
        phase.moonSign,
        planetPositions(utc)[Body.moon.index].sign,
      );
      expect(phase.moonSign, signOfLongitude(longitudeAt(Body.moon, utc)));
    });
  });

  test('rejects local times', () {
    expect(() => moonPhase(DateTime(2026, 10, 29)), throwsArgumentError);
  });
}
