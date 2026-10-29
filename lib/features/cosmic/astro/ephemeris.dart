import 'dart:math' as math;

import 'package:astronomia/astronomia.dart' as am;
import 'package:astronomia/moonposition.dart' as moon_position;
import 'package:astronomia/planetposition.dart' as vsop;
import 'package:astronomia/pluto.dart' as pluto;
import 'package:astronomia/solar.dart' as solar;
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';

/// A heliocentric position of date, angles in radians and range in AU.
typedef _Heliocentric = ({double lon, double lat, double range});

/// Half the window used to measure a body's speed (PRD §9.2: t±12h).
const _halfSpeedWindowDays = 0.5;

final _earth = vsop.Planet(vsop.planetEarth);

final _vsopPlanets = <Body, vsop.Planet>{
  Body.mercury: vsop.Planet(vsop.planetMercury),
  Body.venus: vsop.Planet(vsop.planetVenus),
  Body.mars: vsop.Planet(vsop.planetMars),
  Body.jupiter: vsop.Planet(vsop.planetJupiter),
  Body.saturn: vsop.Planet(vsop.planetSaturn),
  Body.uranus: vsop.Planet(vsop.planetUranus),
  Body.neptune: vsop.Planet(vsop.planetNeptune),
};

/// Julian Day of [utc].
///
/// Treats UT as TT, which PRD §9.1 accepts (ΔT is about a minute today and
/// moves the Moon by less than 0.02°).
double julianDay(DateTime utc) {
  _requireUtc(utc);
  final dayFraction =
      (utc.hour * 3600 +
          utc.minute * 60 +
          utc.second +
          utc.millisecond / 1000 +
          utc.microsecond / 1e6) /
      86400;
  return am.calendarGregorianToJD(utc.year, utc.month, utc.day + dayFraction);
}

/// Every [Body]'s placement at [utc], in [Body] order.
List<Placement> planetPositions(DateTime utc) {
  final jde = julianDay(utc);
  return [
    for (final body in Body.values)
      Placement(
        body: body,
        longitude: _longitude(body, jde),
        speed: _speed(body, jde),
      ),
  ];
}

/// Apparent geocentric ecliptic longitude of date in degrees, [0, 360).
double _longitude(Body body, double jde) {
  final radians = switch (body) {
    Body.sun => solar.apparentVSOP87(_earth, jde).lon,
    Body.moon =>
      moon_position.position(jde).lon + am.nutation(jde).dPsi,
    _ => _planetLongitude(body, jde),
  };
  return normalizeDegrees(am.toDeg(radians));
}

/// Longitude change in degrees per day, measured across the day around [jde].
double _speed(Body body, double jde) {
  final before = _longitude(body, jde - _halfSpeedWindowDays);
  final after = _longitude(body, jde + _halfSpeedWindowDays);
  return _signedDifference(after, before) / (2 * _halfSpeedWindowDays);
}

/// [to] minus [from] in degrees, unwrapped across 0°/360° into [-180, 180).
double _signedDifference(double to, double from) {
  return (to - from + 540) % 360 - 180;
}

/// Meeus ch. 33: iterate the light-time so the planet is seen where it was
/// when the light left it, then add nutation. Annual aberration (about 20")
/// is left out; the golden tests allow 0.5°.
double _planetLongitude(Body body, double jde) {
  final earth = _earth.position(jde);
  var lightTimeDays = 0.0;
  var longitude = 0.0;
  for (var i = 0; i < 3; i++) {
    final planet = _heliocentric(body, jde - lightTimeDays);
    final x =
        planet.range * math.cos(planet.lat) * math.cos(planet.lon) -
        earth.range * math.cos(earth.lat) * math.cos(earth.lon);
    final y =
        planet.range * math.cos(planet.lat) * math.sin(planet.lon) -
        earth.range * math.cos(earth.lat) * math.sin(earth.lon);
    final z =
        planet.range * math.sin(planet.lat) -
        earth.range * math.sin(earth.lat);
    longitude = math.atan2(y, x);
    lightTimeDays = am.lightTime(math.sqrt(x * x + y * y + z * z));
  }
  return longitude + am.nutation(jde).dPsi;
}

_Heliocentric _heliocentric(Body body, double jde) {
  if (body == Body.pluto) {
    // Meeus ch. 37 gives J2000 coordinates; bring them to the equinox of date.
    final j2000 = pluto.heliocentric(jde);
    final ofDate = am.EclipticPrecessor(
      2000,
      am.jdeToJulianYear(jde),
    ).precess(j2000.lon, j2000.lat);
    return (lon: ofDate.lon, lat: ofDate.lat, range: j2000.r);
  }
  return _vsopPlanets[body]!.position(jde);
}

void _requireUtc(DateTime utc) {
  if (!utc.isUtc) {
    throw ArgumentError.value(utc, 'utc', 'The astro engine takes UTC times');
  }
}
