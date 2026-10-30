import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/cosmic/astro/aspects.dart';
import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';

NatalChart _chartAt(Map<Body, double> longitudes) => NatalChart(
  birthUtc: DateTime.utc(2000),
  timeKnown: false,
  placements: [
    for (final body in Body.values)
      Placement(body: body, longitude: longitudes[body] ?? 0, speed: 1),
  ],
);

void main() {
  group('aspectOf', () {
    test('finds each major aspect at its exact angle', () {
      expect(aspectOf(10, 10)!.type, AspectType.conjunction);
      expect(aspectOf(10, 70)!.type, AspectType.sextile);
      expect(aspectOf(10, 100)!.type, AspectType.square);
      expect(aspectOf(10, 130)!.type, AspectType.trine);
      expect(aspectOf(10, 190)!.type, AspectType.opposition);
      expect(aspectOf(10, 130)!.deviation, closeTo(0, 1e-9));
    });

    test('is symmetric', () {
      final forward = aspectOf(10, 133)!;
      final backward = aspectOf(133, 10)!;
      expect(backward.type, forward.type);
      expect(backward.deviation, closeTo(forward.deviation, 1e-9));
    });

    test('works across 0° / 360°', () {
      final match = aspectOf(359, 1)!;
      expect(match.type, AspectType.conjunction);
      expect(match.deviation, closeTo(2, 1e-9));
      expect(aspectOf(350, 110)!.type, AspectType.trine);
    });

    test('stops at the edge of the orb', () {
      expect(aspectOf(0, 126)!.type, AspectType.trine);
      expect(aspectOf(0, 126.01), isNull);
      expect(aspectOf(0, 64)!.type, AspectType.sextile);
      expect(aspectOf(0, 64.01), isNull);
      expect(aspectOf(0, 8)!.type, AspectType.conjunction);
      expect(aspectOf(0, 8.01), isNull);
    });

    test('allows 2° more when the Sun or Moon is involved', () {
      expect(aspectOf(0, 9, luminary: true)!.type, AspectType.conjunction);
      expect(aspectOf(0, 10, luminary: true)!.orb, 10);
      expect(aspectOf(0, 10.01, luminary: true), isNull);
      expect(aspectOf(0, 128, luminary: true)!.type, AspectType.trine);
    });

    test('strength falls from 1 at exact to 0 at the edge of the orb', () {
      expect(aspectOf(0, 120)!.deviation, 0);
      const exact = Aspect(
        a: Body.sun,
        b: Body.moon,
        type: AspectType.trine,
        deviation: 0,
        orb: 6,
      );
      const half = Aspect(
        a: Body.sun,
        b: Body.moon,
        type: AspectType.trine,
        deviation: 3,
        orb: 6,
      );
      const edge = Aspect(
        a: Body.sun,
        b: Body.moon,
        type: AspectType.trine,
        deviation: 6,
        orb: 6,
      );
      expect(exact.strength, 1);
      expect(half.strength, 0.5);
      expect(edge.strength, 0);
    });

    test('the orbs of different aspects never overlap', () {
      // Even with the luminary bonus, every angle matches at most one type.
      for (var tenths = 0; tenths <= 1800; tenths++) {
        final separation = tenths / 10;
        for (final luminary in [false, true]) {
          final matches = AspectType.values.where((type) {
            final orb = type.orb + (luminary ? luminaryOrbBonus : 0);
            return (separation - type.angle).abs() <= orb;
          });
          expect(matches.length, lessThanOrEqualTo(1), reason: '$separation');
        }
      }
    });

    test('values follow the PRD table', () {
      expect(AspectType.trine.value, 1);
      expect(AspectType.sextile.value, 0.7);
      expect(AspectType.conjunction.value, 0.8);
      expect(AspectType.square.value, -0.6);
      expect(AspectType.opposition.value, -0.3);
    });
  });

  group('natalAspects', () {
    test('lists each pair once, earlier body first', () {
      final chart = _chartAt({
        Body.sun: 10,
        Body.moon: 130,
        Body.mercury: 12,
        Body.venus: 250,
      });
      final aspects = natalAspects(chart);
      final pairs = {for (final a in aspects) (a.a, a.b)};
      expect(pairs.length, aspects.length);
      for (final aspect in aspects) {
        expect(aspect.a.index, lessThan(aspect.b.index));
      }
    });

    test('finds the Sun trine Moon with the wider luminary orb', () {
      // 7.5° off a trine: out of orb (6) for planets, inside it (8) for Moon.
      final withMoon = natalAspects(
        _chartAt({Body.sun: 0, Body.moon: 127.5, Body.mercury: 200}),
      );
      expect(
        withMoon.any(
          (a) =>
              a.a == Body.sun && a.b == Body.moon && a.type == AspectType.trine,
        ),
        isTrue,
      );
      final planetsOnly = natalAspects(
        _chartAt({Body.mercury: 0, Body.venus: 127.5}),
      );
      expect(
        planetsOnly.any(
          (a) =>
              a.a == Body.mercury &&
              a.b == Body.venus &&
              a.type == AspectType.trine,
        ),
        isFalse,
      );
    });

    test('puts the tightest aspect first', () {
      final chart = _chartAt({
        Body.sun: 0,
        Body.moon: 125,
        Body.mercury: 60,
        Body.venus: 200,
        Body.mars: 300,
        Body.jupiter: 31,
        Body.saturn: 250,
        Body.uranus: 77,
        Body.neptune: 150,
        Body.pluto: 340,
      });
      final aspects = natalAspects(chart);
      expect(aspects, isNotEmpty);
      for (var i = 1; i < aspects.length; i++) {
        expect(
          aspects[i - 1].strength,
          greaterThanOrEqualTo(aspects[i].strength),
        );
      }
    });

    test('matches an independent pass over a real chart', () {
      final chart = computeNatalChart(
        BirthData(
          birthDate: DateTime(1998, 11, 8),
          birthMinutes: 8 * 60 + 30,
          tzId: 'Asia/Bangkok',
          latitude: 13.75,
          longitude: 100.5,
        ),
      );
      final aspects = natalAspects(chart);
      var expected = 0;
      for (var i = 0; i < 10; i++) {
        for (var j = i + 1; j < 10; j++) {
          final lumi = i <= 1 || j <= 1;
          final raw =
              (chart.placements[i].longitude - chart.placements[j].longitude)
                  .abs();
          final sep = raw > 180 ? 360 - raw : raw;
          for (final type in AspectType.values) {
            if ((sep - type.angle).abs() <= type.orb + (lumi ? 2 : 0)) {
              expected++;
            }
          }
        }
      }
      expect(aspects.length, expected);
      for (final aspect in aspects) {
        expect(aspect.deviation, lessThanOrEqualTo(aspect.orb));
        expect(aspect.strength, inInclusiveRange(0, 1));
      }
    });
  });
}
