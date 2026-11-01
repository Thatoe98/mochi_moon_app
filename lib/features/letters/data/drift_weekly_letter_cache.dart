import 'dart:convert';

import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/letters/domain/weekly_letter.dart';

const _type = 'weekly_letter';

/// The weekly letters kept on the device, one per week and language (PRD
/// §8.6). They share the `cached_reports` table, told apart by `type`.
class DriftWeeklyLetterCache {
  DriftWeeklyLetterCache(this._db, [this._now = DateTime.now]);

  final AppDatabase _db;
  final DateTime Function() _now;

  static String _id(String lang, String weekStart) => '$_type:$lang:$weekStart';

  /// The saved letter, or null when there is none or the row is damaged.
  Future<WeeklyLetter?> find({
    required String lang,
    required String weekStart,
  }) async {
    final row = await (_db.select(
      _db.cachedReports,
    )..where((t) => t.reportId.equals(_id(lang, weekStart)))).getSingleOrNull();
    if (row == null) return null;
    try {
      final data = jsonDecode(row.json);
      if (data is! Map<String, Object?>) return null;
      final title = data['title'];
      final body = data['body'];
      if (title is! String || body is! String) return null;
      return WeeklyLetter(
        weekStart: weekStart,
        lang: lang,
        version: row.version,
        title: title,
        body: body,
      );
    } on FormatException {
      return null;
    }
  }

  Future<void> put(WeeklyLetter letter) => _db
      .into(_db.cachedReports)
      .insertOnConflictUpdate(
        CachedReportsCompanion.insert(
          reportId: _id(letter.lang, letter.weekStart),
          type: _type,
          lang: letter.lang,
          version: letter.version,
          json: jsonEncode({'title': letter.title, 'body': letter.body}),
          fetchedAt: _now(),
        ),
      );
}
