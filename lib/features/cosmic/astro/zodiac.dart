/// The twelve signs of the Western tropical zodiac, in order from 0° Aries.
enum ZodiacSign {
  aries,
  taurus,
  gemini,
  cancer,
  leo,
  virgo,
  libra,
  scorpio,
  sagittarius,
  capricorn,
  aquarius,
  pisces,
}

/// The four elements. Signs cycle through them in this order, so a sign's
/// element is its index modulo four.
enum SignElement { fire, earth, air, water }

extension ZodiacSignElement on ZodiacSign {
  SignElement get element => SignElement.values[index % 4];
}

/// Width of one sign in degrees.
const degreesPerSign = 30.0;

/// [degrees] wrapped into [0, 360).
double normalizeDegrees(double degrees) {
  final wrapped = degrees % 360;
  // Dart's % is never negative, but `-1e-18 % 360` rounds up to exactly 360.
  return wrapped >= 360 ? 0 : wrapped;
}

/// [to] minus [from] in degrees, unwrapped across 0°/360° into [-180, 180).
double signedAngleDifference(double to, double from) {
  return (to - from + 540) % 360 - 180;
}

/// The sign that ecliptic [longitude] falls in.
ZodiacSign signOfLongitude(double longitude) {
  final index = normalizeDegrees(longitude) ~/ degreesPerSign;
  return ZodiacSign.values[index];
}

/// How far [longitude] is into its sign, in [0, 30).
double degreeInSign(double longitude) {
  return normalizeDegrees(longitude) % degreesPerSign;
}
