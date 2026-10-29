import 'dart:math' as math;

import 'package:mochi_moon/features/cosmic/astro/bisect.dart';
import 'package:mochi_moon/features/cosmic/astro/ephemeris.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';

/// The eight named phases, in order from new moon (PRD §9.5).
enum MoonPhaseName {
  newMoon,
  waxingCrescent,
  firstQuarter,
  waxingGibbous,
  fullMoon,
  waningGibbous,
  lastQuarter,
  waningCrescent,
}

/// Elongation of the Moon at new and full moon, in degrees.
const _newMoonElongation = 0.0;
const _fullMoonElongation = 180.0;

/// The Moon gains 11 to 15 degrees of elongation a day, so six hours never
/// steps over a new or full moon.
const _searchStep = Duration(hours: 6);

/// Accuracy of the next new and full moon times.
const _searchTolerance = Duration(minutes: 1);

/// What the Moon looks like at one instant.
class MoonPhase {
  const MoonPhase({
    required this.utc,
    required this.elongation,
    required this.illumination,
    required this.name,
    required this.moonSign,
    required this.nextNewMoon,
    required this.nextFullMoon,
  });

  final DateTime utc;

  /// Moon longitude minus Sun longitude, in degrees in [0, 360). Zero at new
  /// moon, 180 at full moon.
  final double elongation;

  /// Lit fraction of the disc, from 0 (new) to 1 (full).
  final double illumination;

  final MoonPhaseName name;

  /// True when the Moon is between new and full.
  bool get isWaxing => elongation < 180;

  final ZodiacSign moonSign;

  /// First new moon strictly after [utc].
  final DateTime nextNewMoon;

  /// First full moon strictly after [utc].
  final DateTime nextFullMoon;
}

/// The Moon's phase at [utc] (PRD §9.5).
MoonPhase moonPhase(DateTime utc) {
  final e = _elongation(utc);
  return MoonPhase(
    utc: utc,
    elongation: e,
    illumination: (1 - math.cos(e * math.pi / 180)) / 2,
    name: _phaseName(e),
    moonSign: signOfLongitude(longitudeAt(Body.moon, utc)),
    nextNewMoon: _nextCrossing(utc, _newMoonElongation),
    nextFullMoon: _nextCrossing(utc, _fullMoonElongation),
  );
}

double _elongation(DateTime utc) => normalizeDegrees(
  longitudeAt(Body.moon, utc) - longitudeAt(Body.sun, utc),
);

/// Each phase spans 45 degrees centred on a multiple of 45, so new moon is
/// [337.5, 360) and [0, 22.5).
MoonPhaseName _phaseName(double elongation) {
  final index = (elongation + 22.5) % 360 ~/ 45;
  return MoonPhaseName.values[index];
}

/// First instant after [from] when the elongation reaches [target].
DateTime _nextCrossing(DateTime from, double target) {
  // Elongation only grows, so it reaches [target] where this goes from
  // negative to non-negative.
  double offset(DateTime utc) =>
      signedAngleDifference(_elongation(utc), target);

  var previous = from;
  var previousOffset = offset(previous);
  while (true) {
    final current = previous.add(_searchStep);
    final currentOffset = offset(current);
    if (previousOffset < 0 && currentOffset >= 0) {
      return bisectInstant(
        before: previous,
        after: current,
        reached: (utc) => offset(utc) >= 0,
        tolerance: _searchTolerance,
      );
    }
    previous = current;
    previousOffset = currentOffset;
  }
}
