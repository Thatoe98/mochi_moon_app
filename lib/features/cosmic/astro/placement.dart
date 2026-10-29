import 'package:mochi_moon/features/cosmic/astro/zodiac.dart' as zodiac;

/// The bodies the engine places, in the order astrologers list them.
enum Body {
  sun,
  moon,
  mercury,
  venus,
  mars,
  jupiter,
  saturn,
  uranus,
  neptune,
  pluto,
}

/// Where one [body] sits on the ecliptic at one instant.
class Placement {
  /// [longitude] is normalised into [0, 360).
  Placement({
    required this.body,
    required double longitude,
    required this.speed,
  }) : longitude = zodiac.normalizeDegrees(longitude);

  final Body body;

  /// Geocentric ecliptic longitude in degrees, in [0, 360).
  final double longitude;

  /// Degrees per day; negative while the body appears to move backwards.
  final double speed;

  zodiac.ZodiacSign get sign => zodiac.signOfLongitude(longitude);

  /// Degrees into [sign], in [0, 30).
  double get degreeInSign => zodiac.degreeInSign(longitude);

  /// PRD §9.2: retrograde means the longitude speed is below zero.
  bool get isRetrograde => speed < 0;

  @override
  String toString() =>
      'Placement(${body.name}, ${longitude.toStringAsFixed(4)}°, '
      '${sign.name}${isRetrograde ? ', R' : ''})';
}
