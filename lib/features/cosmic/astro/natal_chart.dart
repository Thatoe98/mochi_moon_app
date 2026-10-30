import 'package:mochi_moon/features/cosmic/astro/angles.dart';
import 'package:mochi_moon/features/cosmic/astro/birth_time.dart';
import 'package:mochi_moon/features/cosmic/astro/ephemeris.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';

/// What the engine needs to cast a chart (PRD §9.1).
class BirthData {
  const BirthData({
    required this.birthDate,
    required this.tzId,
    this.birthMinutes,
    this.latitude,
    this.longitude,
  });

  /// The calendar date at the birthplace; its time part is ignored.
  final DateTime birthDate;

  /// Minutes since midnight on the birthplace clock; null when unknown.
  final int? birthMinutes;

  /// IANA zone of the birthplace, such as `Asia/Yangon`.
  final String tzId;

  /// Birthplace in degrees, north and east positive. Without a place there is
  /// no Ascendant, Midheaven or houses.
  final double? latitude;
  final double? longitude;

  bool get timeKnown => birthMinutes != null;
  bool get placeKnown => latitude != null && longitude != null;
}

/// A natal chart: the ten placements and, when the birth time and place are
/// known, the Ascendant, Midheaven and Whole Sign houses (PRD §9.3–9.4).
class NatalChart {
  const NatalChart({
    required this.birthUtc,
    required this.timeKnown,
    required this.placements,
    this.ascendant,
    this.midheaven,
    this.risingMayBeUnreliable = false,
  });

  /// The birth instant in UTC (noon local time when the time is unknown).
  final DateTime birthUtc;

  /// False when the birth time was unknown and noon was used instead.
  final bool timeKnown;

  /// The ten bodies, in [Body] order.
  final List<Placement> placements;

  /// Ecliptic longitude of the Ascendant; null without a known time and place.
  final double? ascendant;

  /// Ecliptic longitude of the Midheaven; null without a known time and place.
  final double? midheaven;

  /// True beyond 66° latitude, where the Ascendant can jump (PRD §9.3).
  final bool risingMayBeUnreliable;

  Placement placementOf(Body body) => placements[body.index];

  /// The Moon moves about 13° a day, so noon is only a guess (PRD §9.1).
  bool get moonIsApproximate => !timeKnown;

  ZodiacSign? get ascendantSign =>
      ascendant == null ? null : signOfLongitude(ascendant!);

  ZodiacSign? get midheavenSign =>
      midheaven == null ? null : signOfLongitude(midheaven!);

  /// Whole Sign house, 1 to 12, of a [sign]; null without an Ascendant
  /// (PRD §9.4).
  int? houseOfSign(ZodiacSign sign) {
    final rising = ascendantSign;
    if (rising == null) return null;
    return (sign.index - rising.index) % 12 + 1;
  }

  /// Whole Sign house, 1 to 12, that [body] sits in.
  int? houseOf(Body body) => houseOfSign(placementOf(body).sign);
}

/// Casts the chart for [data] (PRD §9).
///
/// Everything inside the engine is UTC; the local clock time is converted at
/// the boundary with [birthInstantUtc]. An unknown birth time uses noon and
/// leaves out the angles and houses.
NatalChart computeNatalChart(BirthData data) {
  final utc = birthInstantUtc(
    birthDate: data.birthDate,
    tzId: data.tzId,
    birthMinutes: data.birthMinutes,
  );
  final placements = planetPositions(utc);

  final lat = data.latitude;
  final lng = data.longitude;
  if (!data.timeKnown || lat == null || lng == null) {
    return NatalChart(
      birthUtc: utc,
      timeKnown: data.timeKnown,
      placements: placements,
    );
  }
  final angles = chartAngles(utc: utc, latitude: lat, longitude: lng);
  return NatalChart(
    birthUtc: utc,
    timeKnown: true,
    placements: placements,
    ascendant: angles.ascendant,
    midheaven: angles.midheaven,
    risingMayBeUnreliable: lat.abs() > highLatitudeLimit,
  );
}
