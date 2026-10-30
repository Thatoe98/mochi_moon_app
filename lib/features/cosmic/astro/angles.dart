import 'dart:math' as math;

import 'package:astronomia/astronomia.dart' as am;
import 'package:mochi_moon/features/cosmic/astro/ephemeris.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';

/// Latitude beyond which the Ascendant is flagged as possibly unreliable
/// (PRD §9.3).
const double highLatitudeLimit = 66;

/// The Ascendant and Midheaven for one place and instant.
class ChartAngles {
  const ChartAngles({required this.ascendant, required this.midheaven});

  /// Ecliptic longitude of the eastern horizon, in [0, 360).
  final double ascendant;

  /// Ecliptic longitude of the Midheaven, in [0, 360).
  final double midheaven;
}

/// Ascendant and Midheaven at [utc] for a place at [latitude] and [longitude]
/// (degrees, north and east positive), by PRD §9.3.
///
/// With θ the local apparent sidereal time and ε the true obliquity:
/// `MC = atan2(sin θ, cos θ · cos ε)` and
/// `ASC = atan2(cos θ, −(sin θ · cos ε + tan φ · sin ε))`.
ChartAngles chartAngles({
  required DateTime utc,
  required double latitude,
  required double longitude,
}) {
  final jd = julianDay(utc);
  // am.apparent is the Greenwich apparent sidereal time in seconds of time.
  final theta = _rad(am.apparent(jd) / 240 + longitude);
  final nutation = am.nutation(jd);
  final epsilon = am.meanObliquity(jd) + nutation.dEps;
  final phi = _rad(latitude);

  final midheaven = math.atan2(
    math.sin(theta),
    math.cos(theta) * math.cos(epsilon),
  );
  final ascendant = math.atan2(
    math.cos(theta),
    -(math.sin(theta) * math.cos(epsilon) + math.tan(phi) * math.sin(epsilon)),
  );
  return ChartAngles(
    ascendant: normalizeDegrees(_deg(ascendant)),
    midheaven: normalizeDegrees(_deg(midheaven)),
  );
}

double _rad(double degrees) => degrees * math.pi / 180;

double _deg(double radians) => radians * 180 / math.pi;
