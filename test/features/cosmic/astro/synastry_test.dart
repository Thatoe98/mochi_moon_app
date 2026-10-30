import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/cosmic/astro/aspects.dart';
import 'package:mochi_moon/features/cosmic/astro/ephemeris.dart';
import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/synastry.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';

/// A chart with every body at [base] unless [at] says otherwise.
NatalChart _chart({
  double base = 0,
  Map<Body, double> at = const {},
  double? ascendant,
  bool timeKnown = true,
  DateTime? birthUtc,
}) => NatalChart(
  birthUtc: birthUtc ?? DateTime.utc(2000, 6, 1, 12),
  timeKnown: timeKnown,
  placements: [
    for (final body in Body.values)
      Placement(body: body, longitude: at[body] ?? base, speed: 1),
  ],
  ascendant: ascendant,
  midheaven: ascendant == null ? null : ascendant + 90,
);

/// Chart A at 0° and chart B at 45°: no two bodies make an aspect.
NatalChart get _quietA => _chart();
NatalChart _quietB({Map<Body, double> at = const {}}) =>
    _chart(base: 45, at: at);

void main() {
  group('a quiet pair', () {
    test('scores the base of 60 with no aspects', () {
      final result = synastry(_quietA, _quietB());
      expect(result.aspects, isEmpty);
      expect(result.overall, 60);
      expect(result.romance, 60);
      expect(result.emotional, 60);
      expect(result.communication, 60);
      expect(result.elementBonus, 0);
      expect(result.light, isFalse);
    });
  });

  group('one aspect, worked by hand', () {
    test('an exact Venus–Mars trine adds 3 to the raw score', () {
      // raw = 3.0 × 1.0 × 1.0; overall 60 + 8×3, romance 60 + 12×3.
      final result = synastry(_quietA, _quietB(at: {Body.mars: 120}));
      expect(result.aspects, hasLength(1));
      final aspect = result.aspects.single;
      expect(aspect.fromA, SynastryPoint.venus);
      expect(aspect.fromB, SynastryPoint.mars);
      expect(aspect.type, AspectType.trine);
      expect(aspect.weight, 3);
      expect(aspect.theme, SynastryTheme.romance);
      expect(aspect.contribution, closeTo(3, 1e-9));
      expect(result.overall, 84);
      expect(result.romance, 96);
      expect(result.emotional, 60);
      expect(result.communication, 60);
    });

    test('a looser trine counts for less', () {
      // 3° off with a 6° orb: strength 0.5, raw 1.5.
      final result = synastry(_quietA, _quietB(at: {Body.mars: 123}));
      expect(result.aspects.single.strength, closeTo(0.5, 1e-9));
      expect(result.overall, 72);
      expect(result.romance, 78);
    });

    test('an opposition costs a little: value −0.3', () {
      // raw = 3 × −0.3 = −0.9; overall 52.8 → 53, romance 49.2 → 49.
      final result = synastry(_quietA, _quietB(at: {Body.mars: 180}));
      expect(result.aspects.single.type, AspectType.opposition);
      expect(result.overall, 53);
      expect(result.romance, 49);
    });

    test('reads a pair both ways round', () {
      // Chart A has the Mars this time.
      final result = synastry(_chart(at: {Body.mars: 120}), _quietB());
      // A's Mars (120) against B's Venus (45) is no aspect; so move B's Venus.
      expect(result.aspects, isEmpty);
      final flipped = synastry(
        _chart(at: {Body.mars: 120}),
        _quietB(at: {Body.venus: 0}),
      );
      final aspect = flipped.aspects.firstWhere(
        (a) => a.fromA == SynastryPoint.mars,
      );
      expect(aspect.fromB, SynastryPoint.venus);
      expect(aspect.type, AspectType.trine);
    });

    test('the Sun and Moon get 2° more room', () {
      // A's Sun at 0, B's Moon 128° away: 8° off a trine, inside 6 + 2.
      final result = synastry(
        _chart(base: 200, at: {Body.sun: 0}),
        _chart(base: 245, at: {Body.moon: 128}),
      );
      final sunMoon = result.aspects.where(
        (a) =>
            a.fromA == SynastryPoint.sun &&
            a.fromB == SynastryPoint.moon &&
            a.type == AspectType.trine,
      );
      expect(sunMoon, hasLength(1));
      expect(sunMoon.single.orb, 8);
      expect(sunMoon.single.strength, closeTo(0, 1e-9));
    });
  });

  group('element bonus', () {
    // Mid-sign Suns, so the two Suns never make an aspect that matters here.
    int bonusOf(ZodiacSign a, ZodiacSign b) {
      final chartA = _chart(at: {Body.sun: a.index * 30.0 + 15});
      final chartB = _chart(at: {Body.sun: b.index * 30.0 + 15});
      return synastry(chartA, chartB).elementBonus;
    }

    test('+4 for the same element', () {
      expect(bonusOf(ZodiacSign.aries, ZodiacSign.leo), 4);
      expect(bonusOf(ZodiacSign.taurus, ZodiacSign.capricorn), 4);
      expect(bonusOf(ZodiacSign.gemini, ZodiacSign.gemini), 4);
      expect(bonusOf(ZodiacSign.cancer, ZodiacSign.pisces), 4);
    });

    test('+2 for fire with air and earth with water', () {
      expect(bonusOf(ZodiacSign.aries, ZodiacSign.gemini), 2);
      expect(bonusOf(ZodiacSign.libra, ZodiacSign.leo), 2);
      expect(bonusOf(ZodiacSign.taurus, ZodiacSign.cancer), 2);
      expect(bonusOf(ZodiacSign.scorpio, ZodiacSign.virgo), 2);
    });

    test('0 otherwise', () {
      expect(bonusOf(ZodiacSign.aries, ZodiacSign.taurus), 0);
      expect(bonusOf(ZodiacSign.leo, ZodiacSign.scorpio), 0);
      expect(bonusOf(ZodiacSign.gemini, ZodiacSign.cancer), 0);
      expect(bonusOf(ZodiacSign.libra, ZodiacSign.pisces), 0);
    });

    test('raises every score by the bonus', () {
      // Suns in Aries and Leo (fire, fire) but 120° apart is a trine, so keep
      // the Suns in the same sign: Aries 5° and Aries 25° (20° apart, none).
      final result = synastry(
        _chart(at: {Body.sun: 5}),
        _chart(base: 45, at: {Body.sun: 25}),
      );
      expect(result.elementBonus, 4);
      expect(result.aspects, isEmpty);
      expect(result.overall, 64);
      expect(result.romance, 64);
      expect(result.emotional, 64);
      expect(result.communication, 64);
    });
  });

  group('limits', () {
    test('the best possible pair is held at 98', () {
      final result = synastry(_chart(), _chart());
      expect(result.overall, 98);
      expect(result.romance, 98);
      expect(result.emotional, 98);
      expect(result.communication, 98);
    });

    test('the hardest possible pair is held at 35', () {
      final result = synastry(_chart(), _chart(base: 90));
      expect(result.overall, 35);
      expect(result.romance, 35);
      expect(result.emotional, 35);
      expect(result.communication, 35);
    });
  });

  group('the Ascendant pairs', () {
    test('count when both birth times are known', () {
      final result = synastry(
        _chart(ascendant: 0),
        _chart(base: 45, at: {Body.sun: 120}, ascendant: 200),
      );
      final pair = result.aspects.singleWhere(
        (a) => a.fromA == SynastryPoint.ascendant,
      );
      expect(pair.fromB, SynastryPoint.sun);
      expect(pair.type, AspectType.trine);
      expect(pair.weight, 1);
      expect(pair.theme, SynastryTheme.romance);
    });

    test('are read both ways round', () {
      final result = synastry(
        _chart(base: 45, at: {Body.moon: 120}, ascendant: 200),
        _chart(ascendant: 0),
      );
      final pair = result.aspects.singleWhere(
        (a) => a.fromB == SynastryPoint.ascendant,
      );
      expect(pair.fromA, SynastryPoint.moon);
    });

    test('need the Ascendant of the chart they take it from', () {
      // B has a time but no place, so no Ascendant: only A's can be used.
      final result = synastry(
        _chart(ascendant: 0),
        _chart(base: 45, at: {Body.sun: 120}),
      );
      expect(result.light, isFalse);
      expect(
        result.aspects.any((a) => a.fromB == SynastryPoint.ascendant),
        isFalse,
      );
      expect(
        result.aspects.where((a) => a.fromA == SynastryPoint.ascendant).length,
        1,
      );
    });
  });

  group('a light reading', () {
    // Find a day on which the Moon changes sign and one on which it does not,
    // from the real ephemeris, so the test does not depend on a hand-picked
    // date.
    late DateTime movingDay;
    late DateTime steadyDay;
    setUpAll(() {
      DateTime? moving;
      DateTime? steady;
      for (var day = 0; day < 60 && (moving == null || steady == null); day++) {
        final noon = DateTime.utc(2000, 1, 1 + day, 12);
        final before = planetPositions(
          noon.subtract(const Duration(hours: 12)),
        );
        final after = planetPositions(noon.add(const Duration(hours: 12)));
        final changes =
            before[Body.moon.index].sign != after[Body.moon.index].sign;
        if (changes) {
          moving ??= noon;
        } else {
          steady ??= noon;
        }
      }
      movingDay = moving!;
      steadyDay = steady!;
    });

    NatalChart noTime(DateTime noon, {double base = 45}) => _chart(
      base: base,
      at: {Body.moon: base},
      timeKnown: false,
      birthUtc: noon,
    );

    test('is switched on by a missing time on either side', () {
      expect(synastry(_chart(), noTime(steadyDay)).light, isTrue);
      expect(synastry(noTime(steadyDay), _chart()).light, isTrue);
      expect(synastry(_chart(), _chart()).light, isFalse);
    });

    test('never uses the Ascendant', () {
      final result = synastry(
        _chart(ascendant: 0),
        noTime(steadyDay).copyWithSun(120),
      );
      expect(
        result.aspects.where(
          (a) =>
              a.fromA == SynastryPoint.ascendant ||
              a.fromB == SynastryPoint.ascendant,
        ),
        isEmpty,
      );
    });

    test('drops a Moon that changes sign that day, but only that one', () {
      // Both Moons exactly conjunct and everything else quiet, so any Moon
      // pair that is allowed will show up.
      final b = noTime(movingDay, base: 0);
      final result = synastry(_chart(), b);
      expect(result.light, isTrue);
      expect(result.aspects.any((a) => a.fromB == SynastryPoint.moon), isFalse);
      // A's Moon is certain (its time is known) so it may still pair with
      // B's Venus.
      expect(result.aspects.any((a) => a.fromA == SynastryPoint.moon), isTrue);
    });

    test('keeps a Moon that stays in one sign', () {
      final b = noTime(steadyDay, base: 0);
      final result = synastry(_chart(), b);
      expect(
        result.aspects.any(
          (a) => a.fromA == SynastryPoint.moon && a.fromB == SynastryPoint.moon,
        ),
        isTrue,
      );
    });

    test('only compares Sun, Moon, Mercury, Venus and Mars', () {
      final result = synastry(_chart(), noTime(steadyDay, base: 0));
      final points = {
        for (final a in result.aspects) ...[a.fromA, a.fromB],
      };
      expect(points, isNot(contains(SynastryPoint.ascendant)));
      expect(points, contains(SynastryPoint.sun));
    });

    test('is still the same either way round', () {
      final a = _chart(at: {Body.venus: 20});
      final b = noTime(movingDay, base: 0);
      final one = synastry(a, b);
      final two = synastry(b, a);
      expect(two.overall, one.overall);
      expect(two.romance, one.romance);
      expect(two.emotional, one.emotional);
      expect(two.communication, one.communication);
    });
  });

  group('the ranked aspects', () {
    final result = synastry(
      _chart(at: {Body.venus: 10, Body.mercury: 33}),
      _chart(
        base: 45,
        at: {Body.mars: 131, Body.mercury: 3, Body.moon: 97, Body.sun: 7},
      ),
    );

    test('lists the strongest effect first', () {
      expect(result.aspects, isNotEmpty);
      for (var i = 1; i < result.aspects.length; i++) {
        expect(
          result.aspects[i - 1].contribution.abs(),
          greaterThanOrEqualTo(result.aspects[i].contribution.abs()),
        );
      }
    });

    test('splits into supportive and growth aspects', () {
      expect(result.supportive, isNotEmpty);
      expect(result.growth, isNotEmpty);
      expect(result.supportive.every((a) => a.contribution > 0), isTrue);
      expect(result.growth.every((a) => a.contribution < 0), isTrue);
      expect(
        result.supportive.length + result.growth.length,
        result.aspects.length,
      );
      for (var i = 1; i < result.growth.length; i++) {
        expect(
          result.growth[i - 1].contribution,
          lessThanOrEqualTo(result.growth[i].contribution),
        );
      }
    });
  });

  group('against an independent calculation', () {
    // Written out from the PRD §9.6 tables, without sharing code with the
    // engine.
    const aspectTable = [
      (angle: 0.0, orb: 8.0, value: 0.8),
      (angle: 60.0, orb: 4.0, value: 0.7),
      (angle: 90.0, orb: 6.0, value: -0.6),
      (angle: 120.0, orb: 6.0, value: 1.0),
      (angle: 180.0, orb: 8.0, value: -0.3),
    ];
    // (first, second, weight, theme: 0 romance, 1 emotional, 2 communication)
    const rules = [
      ('sun', 'moon', 3.0, 1),
      ('moon', 'moon', 3.0, 1),
      ('venus', 'mars', 3.0, 0),
      ('sun', 'sun', 2.0, 2),
      ('venus', 'venus', 2.0, 0),
      ('moon', 'venus', 2.0, 1),
      ('mercury', 'mercury', 1.5, 2),
      ('sun', 'venus', 1.5, 0),
      ('mercury', 'moon', 1.0, 2),
      ('asc', 'sun', 1.0, 0),
      ('asc', 'moon', 1.0, 0),
    ];

    double? lon(NatalChart c, String name) => name == 'asc'
        ? c.ascendant
        : c.placements[Body.values.byName(name).index].longitude;

    num score(NatalChart a, NatalChart b, int? theme) {
      var raw = 0.0;
      for (final (first, second, weight, ruleTheme) in rules) {
        if (theme != null && theme != ruleTheme) continue;
        final ways = first == second
            ? [(first, second)]
            : [(first, second), (second, first)];
        for (final (x, y) in ways) {
          final p = lon(a, x);
          final q = lon(b, y);
          if (p == null || q == null) continue;
          final raw360 = (p - q).abs() % 360;
          final separation = raw360 > 180 ? 360 - raw360 : raw360;
          final luminary =
              x == 'sun' || x == 'moon' || y == 'sun' || y == 'moon';
          for (final rule in aspectTable) {
            final orb = rule.orb + (luminary ? 2 : 0);
            final deviation = (separation - rule.angle).abs();
            if (deviation <= orb) {
              raw += weight * rule.value * (1 - deviation / orb);
            }
          }
        }
      }
      final sunA = (lon(a, 'sun')! ~/ 30) % 4;
      final sunB = (lon(b, 'sun')! ~/ 30) % 4;
      final bonus = sunA == sunB ? 4 : ((sunA - sunB).abs() == 2 ? 2 : 0);
      final value = 60 + (theme == null ? 8 : 12) * raw + bonus;
      return value.round().clamp(35, 98);
    }

    test('matches on 500 random pairs, with and without Ascendants', () {
      final random = math.Random(2024);
      NatalChart randomChart() {
        final withAscendant = random.nextBool();
        return NatalChart(
          birthUtc: DateTime.utc(2000, 6, 1, 12),
          timeKnown: true,
          placements: [
            for (final body in Body.values)
              Placement(
                body: body,
                longitude: random.nextDouble() * 360,
                speed: 1,
              ),
          ],
          ascendant: withAscendant ? random.nextDouble() * 360 : null,
        );
      }

      for (var i = 0; i < 500; i++) {
        final a = randomChart();
        final b = randomChart();
        final got = synastry(a, b);
        expect(got.overall, score(a, b, null), reason: '$i overall');
        expect(got.romance, score(a, b, 0), reason: '$i romance');
        expect(got.emotional, score(a, b, 1), reason: '$i emotional');
        expect(got.communication, score(a, b, 2), reason: '$i communication');
        final back = synastry(b, a);
        expect(back.overall, got.overall, reason: '$i swapped');
      }
    });
  });

  test('gives the same answer for the same charts', () {
    final a = _chart(at: {Body.venus: 10, Body.moon: 77});
    final b = _chart(base: 45, at: {Body.mars: 131, Body.sun: 7});
    final one = synastry(a, b);
    final two = synastry(a, b);
    expect(two.overall, one.overall);
    expect(two.aspects.length, one.aspects.length);
    for (var i = 0; i < one.aspects.length; i++) {
      expect(two.aspects[i].contribution, one.aspects[i].contribution);
    }
  });
}

extension on NatalChart {
  /// This chart with the Sun moved to [longitude].
  NatalChart copyWithSun(double longitude) => NatalChart(
    birthUtc: birthUtc,
    timeKnown: timeKnown,
    placements: [
      for (final p in placements)
        if (p.body == Body.sun)
          Placement(body: Body.sun, longitude: longitude, speed: p.speed)
        else
          p,
    ],
    ascendant: ascendant,
    midheaven: midheaven,
  );
}
