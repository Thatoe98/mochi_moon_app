import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/cosmic/astro/sun_moon_signs.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';

void main() {
  group('sunMoonSigns', () {
    // Horizons has the Sun at 102.42° and the Moon at 244.66° at
    // 1990-07-04 16:00 UTC, which is noon in New York (EDT).
    test('reads a known birth', () {
      final signs = sunMoonSigns(
        birthDate: DateTime(1990, 7, 4),
        tzId: 'America/New_York',
        birthMinutes: 12 * 60,
      );
      expect(signs.sun, ZodiacSign.cancer);
      expect(signs.moon, ZodiacSign.sagittarius);
      expect(signs.moonIsApproximate, isFalse);
    });

    test('flags the Moon as approximate when the time is unknown', () {
      final signs = sunMoonSigns(
        birthDate: DateTime(1990, 7, 4),
        tzId: 'America/New_York',
      );
      expect(signs.sun, ZodiacSign.cancer);
      // Unknown time is noon local, the same instant as the known birth above.
      expect(signs.moon, ZodiacSign.sagittarius);
      expect(signs.moonIsApproximate, isTrue);
    });

    // The March 2021 equinox was at 09:37 UTC, 16:37 in Bangkok.
    test('puts the Sun on the right side of a sign cusp', () {
      ZodiacSign sunAt(int hour, int minute) => sunMoonSigns(
        birthDate: DateTime(2021, 3, 20),
        tzId: 'Asia/Bangkok',
        birthMinutes: hour * 60 + minute,
      ).sun;

      expect(sunAt(16, 20), ZodiacSign.pisces);
      expect(sunAt(16, 55), ZodiacSign.aries);
    });

    test('the cusp follows daylight saving time', () {
      // Los Angeles was on PDT (UTC-7), so the equinox was at 02:37 local.
      ZodiacSign sunAt(int hour) => sunMoonSigns(
        birthDate: DateTime(2021, 3, 20),
        tzId: 'America/Los_Angeles',
        birthMinutes: hour * 60,
      ).sun;

      expect(sunAt(1), ZodiacSign.pisces);
      expect(sunAt(4), ZodiacSign.aries);
    });

    test('signs for Yangon and Bangkok births agree with Horizons', () {
      // 1984-05-05 03:45 UTC: Sun 44.83° (Taurus), Moon 92.39° (Cancer).
      // That is 10:45 in Bangkok and 10:15 in Yangon.
      for (final (tzId, minutes) in [
        ('Asia/Bangkok', 10 * 60 + 45),
        ('Asia/Yangon', 10 * 60 + 15),
      ]) {
        final signs = sunMoonSigns(
          birthDate: DateTime(1984, 5, 5),
          tzId: tzId,
          birthMinutes: minutes,
        );
        expect(signs.sun, ZodiacSign.taurus, reason: tzId);
        expect(signs.moon, ZodiacSign.cancer, reason: tzId);
      }
    });
  });
}
