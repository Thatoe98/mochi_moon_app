import 'package:mochi_moon/features/cosmic/astro/aspects.dart';
import 'package:mochi_moon/features/cosmic/astro/ephemeris.dart';
import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';

/// What a compatibility score is made of: the points that are compared.
enum SynastryPoint {
  sun(Body.sun),
  moon(Body.moon),
  mercury(Body.mercury),
  venus(Body.venus),
  mars(Body.mars),
  ascendant(null);

  SynastryPoint(this.body);

  /// The planet behind the point; null for the Ascendant.
  final Body? body;

  bool get isLuminary => this == sun || this == moon;
}

/// The three sub-scores of a compatibility reading (PRD §6.12).
enum SynastryTheme { romance, emotional, communication }

/// One row of the PRD §9.6 pairs table.
class _PairRule {
  const _PairRule(this.first, this.second, this.weight, this.theme);

  final SynastryPoint first;
  final SynastryPoint second;
  final double weight;
  final SynastryTheme theme;
}

const _pairRules = [
  _PairRule(SynastryPoint.sun, SynastryPoint.moon, 3, SynastryTheme.emotional),
  _PairRule(SynastryPoint.moon, SynastryPoint.moon, 3, SynastryTheme.emotional),
  _PairRule(SynastryPoint.venus, SynastryPoint.mars, 3, SynastryTheme.romance),
  _PairRule(
    SynastryPoint.sun,
    SynastryPoint.sun,
    2,
    SynastryTheme.communication,
  ),
  _PairRule(SynastryPoint.venus, SynastryPoint.venus, 2, SynastryTheme.romance),
  _PairRule(
    SynastryPoint.moon,
    SynastryPoint.venus,
    2,
    SynastryTheme.emotional,
  ),
  _PairRule(
    SynastryPoint.mercury,
    SynastryPoint.mercury,
    1.5,
    SynastryTheme.communication,
  ),
  _PairRule(SynastryPoint.sun, SynastryPoint.venus, 1.5, SynastryTheme.romance),
  _PairRule(
    SynastryPoint.mercury,
    SynastryPoint.moon,
    1,
    SynastryTheme.communication,
  ),
  _PairRule(
    SynastryPoint.ascendant,
    SynastryPoint.sun,
    1,
    SynastryTheme.romance,
  ),
  _PairRule(
    SynastryPoint.ascendant,
    SynastryPoint.moon,
    1,
    SynastryTheme.romance,
  ),
];

/// The score is 60 plus this much per unit of raw aspect strength (PRD §9.6).
/// Sub-scores use [subScoreMultiplier] instead.
const double scoreBase = 60;
const double overallMultiplier = 8;
const double subScoreMultiplier = 12;

/// Scores never leave this range, so nobody is told they are a perfect match
/// or a hopeless one.
const int scoreFloor = 35;
const int scoreCeiling = 98;

/// One aspect between a point of chart A and a point of chart B.
class SynastryAspect {
  const SynastryAspect({
    required this.fromA,
    required this.fromB,
    required this.type,
    required this.deviation,
    required this.orb,
    required this.weight,
    required this.theme,
  });

  /// The point taken from the first chart.
  final SynastryPoint fromA;

  /// The point taken from the second chart.
  final SynastryPoint fromB;

  final AspectType type;

  /// Degrees away from the exact angle.
  final double deviation;

  /// The orb that applied, with the Sun and Moon bonus if any.
  final double orb;

  final double weight;
  final SynastryTheme theme;

  /// 1 when exact, falling to 0 at the edge of the orb.
  double get strength => 1 - deviation / orb;

  /// What this aspect adds to the raw score: weight × value × strength.
  /// Positive for supportive aspects, negative for growth ones.
  double get contribution => weight * type.value * strength;

  @override
  String toString() =>
      'SynastryAspect(A ${fromA.name} ${type.name} B ${fromB.name}, '
      '${contribution.toStringAsFixed(2)})';
}

/// The compatibility reading of two charts (PRD §6.12 and §9.6).
class Synastry {
  const Synastry({
    required this.overall,
    required this.romance,
    required this.emotional,
    required this.communication,
    required this.light,
    required this.elementBonus,
    required this.aspects,
  });

  /// 35–98.
  final int overall;
  final int romance;
  final int emotional;
  final int communication;

  /// True when a birth time is missing on either side: only the Sun,
  /// Mercury, Venus and Mars (and a Moon that cannot change sign that day)
  /// are compared, and the reading is labeled "Light reading".
  final bool light;

  /// 0, 2 or 4, from the two Sun signs' elements.
  final int elementBonus;

  /// Every aspect that counted, the strongest effect first.
  final List<SynastryAspect> aspects;

  int scoreOf(SynastryTheme theme) => switch (theme) {
    SynastryTheme.romance => romance,
    SynastryTheme.emotional => emotional,
    SynastryTheme.communication => communication,
  };

  /// The aspects that help, strongest first.
  List<SynastryAspect> get supportive => [
    for (final aspect in aspects)
      if (aspect.contribution > 0) aspect,
  ];

  /// The aspects that ask for care, the heaviest first.
  List<SynastryAspect> get growth => [
    for (final aspect in aspects)
      if (aspect.contribution < 0) aspect,
  ]..sort((x, y) => x.contribution.compareTo(y.contribution));
}

/// Compares chart [a] with chart [b] (PRD §9.6). The result is the same for
/// the same inputs and does not depend on which chart comes first.
Synastry synastry(NatalChart a, NatalChart b) {
  final light = !a.timeKnown || !b.timeKnown;
  // Checked once per chart: it asks the ephemeris.
  final moonUsable = (
    a: !light || _moonStaysInOneSign(a),
    b: !light || _moonStaysInOneSign(b),
  );
  final found = <SynastryAspect>[];
  for (final rule in _pairRules) {
    // A rule with two different points is read both ways round.
    final directions = rule.first == rule.second
        ? [(rule.first, rule.second)]
        : [(rule.first, rule.second), (rule.second, rule.first)];
    for (final (pointA, pointB) in directions) {
      final longitudeA = _longitudeOf(
        a,
        pointA,
        light: light,
        moonUsable: moonUsable.a,
      );
      final longitudeB = _longitudeOf(
        b,
        pointB,
        light: light,
        moonUsable: moonUsable.b,
      );
      if (longitudeA == null || longitudeB == null) continue;
      final match = aspectOf(
        longitudeA,
        longitudeB,
        luminary: pointA.isLuminary || pointB.isLuminary,
      );
      if (match == null) continue;
      found.add(
        SynastryAspect(
          fromA: pointA,
          fromB: pointB,
          type: match.type,
          deviation: match.deviation,
          orb: match.orb,
          weight: rule.weight,
          theme: rule.theme,
        ),
      );
    }
  }

  final bonus = _elementBonus(
    a.placementOf(Body.sun).sign,
    b.placementOf(Body.sun).sign,
  );
  int scoreOf(Iterable<SynastryAspect> aspects, double multiplier) {
    final raw = aspects.fold<double>(0, (sum, x) => sum + x.contribution);
    return (scoreBase + multiplier * raw + bonus).round().clamp(
      scoreFloor,
      scoreCeiling,
    );
  }

  int subScore(SynastryTheme theme) => scoreOf(
    found.where((aspect) => aspect.theme == theme),
    subScoreMultiplier,
  );

  return Synastry(
    overall: scoreOf(found, overallMultiplier),
    romance: subScore(SynastryTheme.romance),
    emotional: subScore(SynastryTheme.emotional),
    communication: subScore(SynastryTheme.communication),
    light: light,
    elementBonus: bonus,
    aspects: found
      ..sort((x, y) => y.contribution.abs().compareTo(x.contribution.abs())),
  );
}

/// Where [point] sits in [chart], or null when it cannot be used: the
/// Ascendant needs a known time and place and is left out of a light reading,
/// and the Moon needs [moonUsable].
double? _longitudeOf(
  NatalChart chart,
  SynastryPoint point, {
  required bool light,
  required bool moonUsable,
}) {
  if (point == SynastryPoint.ascendant) return light ? null : chart.ascendant;
  if (point == SynastryPoint.moon && !moonUsable) return null;
  return chart.placementOf(point.body!).longitude;
}

/// A chart without a birth time uses noon, so the Moon is only certain when
/// it is in the same sign twelve hours either side of that.
bool _moonStaysInOneSign(NatalChart chart) {
  if (chart.timeKnown) return true;
  const half = Duration(hours: 12);
  final before = longitudeAt(Body.moon, chart.birthUtc.subtract(half));
  final after = longitudeAt(Body.moon, chart.birthUtc.add(half));
  return signOfLongitude(before) == signOfLongitude(after);
}

/// Same element +4; fire with air or earth with water +2; otherwise 0.
int _elementBonus(ZodiacSign a, ZodiacSign b) {
  final gap = (a.element.index - b.element.index).abs();
  return switch (gap) {
    0 => 4,
    2 => 2,
    _ => 0,
  };
}
