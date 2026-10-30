import 'dart:convert';

import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/cosmic/report/data/natal_report_codec.dart';
import 'package:mochi_moon/features/cosmic/report/domain/natal_report.dart';

const _type = 'natal';

/// The finished natal report kept on the device (PRD §8.6), one per language.
/// Each is saved with the key of the chart it was written for, so editing the
/// birth data makes it stale and the next visit asks for a new one.
class DriftNatalReportCache {
  DriftNatalReportCache(this._db, [this._now = DateTime.now]);

  final AppDatabase _db;
  final DateTime Function() _now;

  static String _id(String lang) => '$_type:$lang';

  /// The saved report for [lang] if it was written for [key]; null when there
  /// is none, it is for another chart, or the row is damaged.
  Future<NatalReport?> find({required String lang, required String key}) async {
    final row = await (_db.select(
      _db.cachedReports,
    )..where((t) => t.reportId.equals(_id(lang)))).getSingleOrNull();
    if (row == null) return null;
    try {
      final decoded = jsonDecode(row.json);
      if (decoded is! Map<String, Object?> || decoded['key'] != key) {
        return null;
      }
      final report = decoded['report'];
      if (report is! Map<String, Object?>) return null;
      return natalReportFromJson(report);
    } on FormatException {
      return null;
    }
  }

  Future<void> put({required String key, required NatalReport report}) => _db
      .into(_db.cachedReports)
      .insertOnConflictUpdate(
        CachedReportsCompanion.insert(
          reportId: _id(report.lang),
          type: _type,
          lang: report.lang,
          version: report.version,
          json: jsonEncode({'key': key, 'report': natalReportToJson(report)}),
          fetchedAt: _now(),
        ),
      );
}
