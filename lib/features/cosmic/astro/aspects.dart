import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';

/// The five major aspects with their angle, orb and value (PRD §9.6).
enum AspectType {
  conjunction(angle: 0, orb: 8, value: 0.8),
  sextile(angle: 60, orb: 4, value: 0.7),
  square(angle: 90, orb: 6, value: -0.6),
  trine(angle: 120, orb: 6, value: 1),
  opposition(angle: 180, orb: 8, value: -0.3);

  AspectType({required this.angle, required this.orb, required this.value});

  /// Exact angle between the two bodies, in degrees.
  final double angle;

  /// Widest deviation from [angle] that still counts, in degrees.
  final double orb;

  /// How much the aspect helps (+) or strains (−) in the compatibility score.
  final double value;
}

/// Extra orb when the Sun or the Moon is one of the two bodies (PRD §9.6).
const double luminaryOrbBonus = 2;

/// One aspect between two bodies.
class Aspect {
  const Aspect({
    required this.a,
    required this.b,
    required this.type,
    required this.deviation,
    required this.orb,
  });

  final Body a;
  final Body b;
  final AspectType type;

  /// Degrees away from the exact angle, always 0 or more.
  final double deviation;

  /// The orb that applied, [AspectType.orb] plus the luminary bonus if any.
  final double orb;

  /// 1 when exact, falling to 0 at the edge of the orb (PRD §9.6).
  double get strength => 1 - deviation / orb;

  @override
  String toString() =>
      'Aspect(${a.name} ${type.name} ${b.name}, '
      '${deviation.toStringAsFixed(2)}°)';
}

/// The aspect two ecliptic longitudes make, or null when they make none.
///
/// [luminary] widens every orb by [luminaryOrbBonus]; pass true when the Sun
/// or Moon is one of the two. The orbs of different aspects never overlap, so
/// at most one can match.
({AspectType type, double deviation, double orb})? aspectOf(
  double longitudeA,
  double longitudeB, {
  bool luminary = false,
}) {
  final separation = signedAngleDifference(longitudeA, longitudeB).abs();
  for (final type in AspectType.values) {
    final orb = type.orb + (luminary ? luminaryOrbBonus : 0);
    final deviation = (separation - type.angle).abs();
    if (deviation <= orb) {
      return (type: type, deviation: deviation, orb: orb);
    }
  }
  return null;
}

bool _isLuminary(Body body) => body == Body.sun || body == Body.moon;

/// Every aspect between the ten bodies of [chart], the tightest first.
///
/// Each pair appears once, with the earlier body in [Body] order as `a`. The
/// Ascendant and Midheaven are left out.
List<Aspect> natalAspects(NatalChart chart) {
  final found = <Aspect>[];
  final placements = chart.placements;
  for (var i = 0; i < placements.length; i++) {
    for (var j = i + 1; j < placements.length; j++) {
      final first = placements[i];
      final second = placements[j];
      final match = aspectOf(
        first.longitude,
        second.longitude,
        luminary: _isLuminary(first.body) || _isLuminary(second.body),
      );
      if (match == null) continue;
      found.add(
        Aspect(
          a: first.body,
          b: second.body,
          type: match.type,
          deviation: match.deviation,
          orb: match.orb,
        ),
      );
    }
  }
  return found..sort((x, y) => y.strength.compareTo(x.strength));
}
