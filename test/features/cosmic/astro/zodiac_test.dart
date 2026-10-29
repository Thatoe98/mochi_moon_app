import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';

void main() {
  group('normalizeDegrees', () {
    test('leaves values in range alone', () {
      expect(normalizeDegrees(0), 0);
      expect(normalizeDegrees(123.5), 123.5);
      expect(normalizeDegrees(359.999), 359.999);
    });

    test('wraps values outside the range', () {
      expect(normalizeDegrees(360), 0);
      expect(normalizeDegrees(725), 5);
      expect(normalizeDegrees(-10), 350);
      expect(normalizeDegrees(-370), 350);
    });

    test('never returns 360, even for tiny negative inputs', () {
      expect(normalizeDegrees(-1e-18), lessThan(360));
    });
  });

  group('signOfLongitude', () {
    test('each sign starts at a multiple of 30 degrees', () {
      for (final sign in ZodiacSign.values) {
        final start = sign.index * 30.0;
        expect(signOfLongitude(start), sign);
        expect(signOfLongitude(start + 29.999), sign);
      }
    });

    test('wraps around the circle', () {
      expect(signOfLongitude(360), ZodiacSign.aries);
      expect(signOfLongitude(-0.5), ZodiacSign.pisces);
      expect(signOfLongitude(390), ZodiacSign.taurus);
    });
  });

  group('degreeInSign', () {
    test('is the offset into the sign', () {
      expect(degreeInSign(0), 0);
      expect(degreeInSign(45), 15);
      expect(degreeInSign(359.5), closeTo(29.5, 1e-9));
    });
  });
}
