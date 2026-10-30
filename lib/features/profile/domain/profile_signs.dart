import 'package:mochi_moon/features/cosmic/astro/birth_time.dart';
import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';

/// The signs worked out from a profile's birth data (PRD §6.1, §8.1). They
/// are derived, never typed in, so they are recomputed on every save.
class ProfileSigns {
  const ProfileSigns({
    required this.sun,
    required this.moon,
    required this.moonApproximate,
    required this.rising,
  });

  /// Lowercase sign names, such as `taurus`.
  final String sun;
  final String moon;

  /// True when the birth time is unknown, so the Moon may be a sign off.
  final bool moonApproximate;

  /// Null without a birth time.
  final String? rising;

  /// The `users/{uid}.profile` fields of PRD §8.1.
  Map<String, Object?> toMap() => {
    'sunSign': sun,
    'moonSign': moon,
    'moonApproximate': moonApproximate,
    'risingSign': rising,
  };
}

/// The signs of [profile], or null while it has no birth date.
ProfileSigns? signsOfProfile(UserProfile profile) {
  final birthDate = profile.birthDate;
  if (birthDate == null) return null;
  final place = profile.birthPlace;
  final chart = computeNatalChart(
    BirthData(
      birthDate: birthDate,
      birthMinutes: profile.birthMinutes,
      tzId: place?.tzId ?? noPlaceTimeZone,
      latitude: place?.lat,
      longitude: place?.lng,
    ),
  );
  return ProfileSigns(
    sun: chart.placementOf(Body.sun).sign.name,
    moon: chart.placementOf(Body.moon).sign.name,
    moonApproximate: !chart.timeKnown,
    rising: chart.ascendantSign?.name,
  );
}
