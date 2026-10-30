import 'dart:convert';

import 'package:mochi_moon/features/cosmic/astro/aspects.dart';
import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';
import 'package:mochi_moon/features/cosmic/report/domain/natal_report.dart';

/// Two decimals, and always below 30 so the server accepts it as a degree.
double _degree(double value) {
  final rounded = (value * 100).round() / 100;
  return rounded >= 30 ? 29.99 : rounded;
}

Map<String, Object?> _point(double longitude) => {
  'sign': signOfLongitude(longitude).name,
  'degree': _degree(degreeInSign(longitude)),
};

/// The `POST /reports/natal` body for [chart] (PRD §8.2).
///
/// It holds computed placements only: no birth date, time or place. The map
/// keeps one order, so the same chart always gives the same JSON.
Map<String, Object?> natalReportRequest(NatalChart chart, String lang) {
  final ascendant = chart.timeKnown ? chart.ascendant : null;
  final midheaven = ascendant == null ? null : chart.midheaven;
  return {
    'lang': lang,
    'timeKnown': ascendant != null,
    'placements': [
      for (final p in chart.placements)
        {
          'body': p.body.name,
          'sign': p.sign.name,
          'degree': _degree(p.degreeInSign),
          'house': ascendant == null ? null : chart.houseOf(p.body),
          'retrograde': p.isRetrograde,
        },
    ],
    'ascendant': ?(ascendant == null ? null : _point(ascendant)),
    'midheaven': ?(midheaven == null ? null : _point(midheaven)),
    'aspects': [
      for (final a in natalAspects(chart))
        {
          'a': a.a.name,
          'b': a.b.name,
          'type': a.type.name,
          'orb': _degree(a.deviation),
        },
    ],
  };
}

/// What identifies a request on the device: a saved report is only shown for
/// the chart it was written for.
String natalReportKey(Map<String, Object?> request) => jsonEncode(request);

/// Reads a server report, or a saved copy of one. Throws a [FormatException]
/// when a field is missing or has the wrong type, so a bad answer is never
/// shown or saved.
NatalReport natalReportFromJson(Map<String, Object?> json) {
  String text(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value is String && value.trim().isNotEmpty) return value;
    throw FormatException('Missing "$key" in the report.');
  }

  int number(String key) {
    final value = json[key];
    if (value is int) return value;
    throw FormatException('Missing "$key" in the report.');
  }

  final sections = json['sections'];
  if (sections is! List) {
    throw const FormatException('Missing "sections" in the report.');
  }
  final status = ReportStatus.values.asNameMap()[json['status']];
  if (status == null) {
    throw const FormatException('Missing "status" in the report.');
  }
  return NatalReport(
    reportId: text(json, 'reportId'),
    lang: text(json, 'lang'),
    version: number('version'),
    status: status,
    total: number('total'),
    sections: [
      for (final raw in sections)
        if (raw is Map<String, Object?>)
          ReportSection(
            key: text(raw, 'key'),
            title: text(raw, 'title'),
            body: text(raw, 'body'),
          )
        else
          throw const FormatException('A part of the report is not an object.'),
    ],
  );
}

/// The shape [natalReportFromJson] reads, as saved on the device.
Map<String, Object?> natalReportToJson(NatalReport report) => {
  'reportId': report.reportId,
  'lang': report.lang,
  'version': report.version,
  'status': report.status.name,
  'total': report.total,
  'sections': [
    for (final s in report.sections)
      {'key': s.key, 'title': s.title, 'body': s.body},
  ],
};
