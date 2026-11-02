import 'package:mochi_moon/features/cosmic/astro/aspects.dart';
import 'package:mochi_moon/features/cosmic/astro/ephemeris.dart';
import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';

/// The most transits sent; the server accepts 6.
const _maxTransits = 6;

/// Two decimals, and always below 30 so the server accepts it as a degree.
double _degree(double value) {
  final rounded = (value * 100).round() / 100;
  return rounded >= 30 ? 29.99 : rounded;
}

/// `yyyy-MM-dd` for a local calendar day.
String personalDateKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

/// The `POST /daily/personal` body (PRD §8.2).
///
/// It holds her computed placements, the Moon's sign and the day's transits to
/// them: no birth date, time or place, and no name. The sky is read at noon UTC
/// of [date], close enough for a daily note.
Map<String, Object?> personalNoteRequest({
  required NatalChart chart,
  required DateTime date,
  required String lang,
}) {
  final sky = planetPositions(
    DateTime.utc(date.year, date.month, date.day, 12),
  );
  final found =
      <
        ({
          Placement sky,
          Placement natal,
          double strength,
          AspectType type,
          double deviation,
        })
      >[];
  for (final today in sky) {
    for (final natal in chart.placements) {
      final match = aspectOf(
        today.longitude,
        natal.longitude,
        luminary:
            today.body == Body.sun ||
            today.body == Body.moon ||
            natal.body == Body.sun ||
            natal.body == Body.moon,
      );
      if (match == null) continue;
      found.add((
        sky: today,
        natal: natal,
        strength: 1 - match.deviation / match.orb,
        type: match.type,
        deviation: match.deviation,
      ));
    }
  }
  found.sort((x, y) => y.strength.compareTo(x.strength));
  return {
    'lang': lang,
    'date': personalDateKey(date),
    'moonSign': sky[Body.moon.index].sign.name,
    'placements': [
      for (final p in chart.placements)
        {
          'body': p.body.name,
          'sign': p.sign.name,
          'degree': _degree(p.degreeInSign),
          'retrograde': p.isRetrograde,
        },
    ],
    'transits': [
      for (final t in found.take(_maxTransits))
        {
          'transit': t.sky.body.name,
          'natal': t.natal.body.name,
          'type': t.type.name,
          'orb': _degree(t.deviation),
        },
    ],
  };
}
