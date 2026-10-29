import 'package:mochi_moon/features/cosmic/astro/birth_time.dart';
import 'package:mochi_moon/features/cosmic/astro/ephemeris.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';

/// The Sun and Moon signs a user gets when they save their birth data
/// (PRD §6.1).
class SunMoonSigns {
  const SunMoonSigns({
    required this.sun,
    required this.moon,
    required this.moonIsApproximate,
  });

  final ZodiacSign sun;
  final ZodiacSign moon;

  /// True when the birth time is unknown. The Moon changes sign about every
  /// two and a half days, so noon is only a best guess.
  final bool moonIsApproximate;
}

/// Sun and Moon signs for a birth on [birthDate] at [birthMinutes] (null when
/// unknown) local to [tzId]. See [birthInstantUtc] for how the time is read.
SunMoonSigns sunMoonSigns({
  required DateTime birthDate,
  required String tzId,
  int? birthMinutes,
}) {
  final placements = planetPositions(
    birthInstantUtc(
      birthDate: birthDate,
      tzId: tzId,
      birthMinutes: birthMinutes,
    ),
  );
  return SunMoonSigns(
    sun: placements[Body.sun.index].sign,
    moon: placements[Body.moon.index].sign,
    moonIsApproximate: birthMinutes == null,
  );
}
