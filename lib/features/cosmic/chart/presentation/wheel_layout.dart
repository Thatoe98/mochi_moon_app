import 'dart:math' as math;

import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';

/// The canvas angle, in radians, of ecliptic [longitude] on the chart wheel.
///
/// [rotation] is the longitude that sits at 9 o'clock: the Ascendant when the
/// birth time is known, otherwise 0° Aries. Longitudes then grow
/// counterclockwise, as on a traditional chart. Canvas angles run clockwise
/// from 3 o'clock with y pointing down.
double wheelAngle(double longitude, {required double rotation}) {
  final turned = normalizeDegrees(longitude - rotation);
  return math.pi - turned * math.pi / 180;
}

/// Moves longitudes apart so that neighbours are at least [minGap] degrees
/// from each other, and returns them in the order given.
///
/// It only nudges: each close pair is pushed apart by the same amount, so a
/// crowded group stays centred where it was. Used to keep planet glyphs from
/// covering each other when several sit in one sign.
List<double> spreadLongitudes(
  List<double> longitudes, {
  required double minGap,
}) {
  final count = longitudes.length;
  if (count < 2) return List.of(longitudes);
  assert(minGap * count < 360, 'The gaps must fit around the circle.');

  final order = List.generate(count, (i) => i)
    ..sort(
      (x, y) =>
          normalizeDegrees(longitudes[x])
              .compareTo(normalizeDegrees(longitudes[y])),
    );
  final spots = [for (final i in order) normalizeDegrees(longitudes[i])];

  // Pushing a pair apart can close the gap to its other neighbour, so repeat
  // until nothing moves. A few dozen passes settle ten glyphs.
  for (var pass = 0; pass < 500; pass++) {
    var moved = false;
    for (var k = 0; k < count; k++) {
      final next = (k + 1) % count;
      final gap = next == 0
          ? spots[0] + 360 - spots[k]
          : spots[next] - spots[k];
      if (gap < minGap - 1e-9) {
        final push = (minGap - gap) / 2;
        spots[k] -= push;
        spots[next] += push;
        moved = true;
      }
    }
    if (!moved) break;
  }

  final spread = List<double>.filled(count, 0);
  for (var k = 0; k < count; k++) {
    spread[order[k]] = normalizeDegrees(spots[k]);
  }
  return spread;
}
