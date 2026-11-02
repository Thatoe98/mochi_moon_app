import 'dart:convert';

import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/astro/synastry.dart';

/// The most aspects sent; the server accepts 12.
const _maxTopAspects = 12;

/// Two decimals, and always below 30 so the server accepts it as a degree.
double _degree(double value) {
  final rounded = (value * 100).round() / 100;
  return rounded >= 30 ? 29.99 : rounded;
}

Map<String, Object?> _block(NatalChart chart) => {
  'placements': [
    for (final p in chart.placements)
      {
        'body': p.body.name,
        'sign': p.sign.name,
        'degree': _degree(p.degreeInSign),
        'retrograde': p.isRetrograde,
      },
  ],
};

/// The `POST /reports/compatibility` body (PRD §8.2).
///
/// It holds computed placements, the scores and the top aspects only: no birth
/// date, time or place, and no partner name. The partner id is an opaque
/// random id. The Ascendant is left out of the aspects because the server
/// compares planets.
Map<String, Object?> compatReportRequest({
  required String partnerId,
  required NatalChart you,
  required NatalChart them,
  required Synastry synastry,
  required String lang,
}) => {
  'lang': lang,
  'partnerId': partnerId,
  'a': _block(you),
  'b': _block(them),
  'score': {
    'overall': synastry.overall,
    'romance': synastry.romance,
    'emotional': synastry.emotional,
    'communication': synastry.communication,
  },
  'topAspects': [
    for (final a in synastry.aspects)
      if (a.fromA.body != null && a.fromB.body != null)
        {
          'a': a.fromA.body!.name,
          'b': a.fromB.body!.name,
          'type': a.type.name,
          'orb': _degree(a.deviation),
        },
  ].take(_maxTopAspects).toList(),
};

/// What identifies a request on the device: a saved report is only shown for
/// the pair it was written for.
String compatReportKey(Map<String, Object?> request) => jsonEncode(request);
