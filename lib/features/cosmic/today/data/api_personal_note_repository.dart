import 'dart:convert';

import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/network/readings_api.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/today/data/personal_note_codec.dart';
import 'package:mochi_moon/features/cosmic/today/domain/personal_note.dart';

const _type = 'personal_daily';

/// The personal notes kept on the device, one per day and language. They share
/// the `cached_reports` table, told apart by `type`.
class DriftPersonalNoteCache {
  DriftPersonalNoteCache(this._db, [this._now = DateTime.now]);

  final AppDatabase _db;
  final DateTime Function() _now;

  static String _id(String lang, String date) => '$_type:$lang:$date';

  Future<PersonalNote?> find({
    required String lang,
    required String date,
  }) async {
    final row = await (_db.select(
      _db.cachedReports,
    )..where((t) => t.reportId.equals(_id(lang, date)))).getSingleOrNull();
    if (row == null) return null;
    try {
      final data = jsonDecode(row.json);
      if (data is! Map<String, Object?>) return null;
      final title = data['title'];
      final body = data['body'];
      if (title is! String || body is! String) return null;
      return PersonalNote(
        date: date,
        lang: lang,
        version: row.version,
        title: title,
        body: body,
      );
    } on FormatException {
      return null;
    }
  }

  Future<void> put(PersonalNote note) => _db
      .into(_db.cachedReports)
      .insertOnConflictUpdate(
        CachedReportsCompanion.insert(
          reportId: _id(note.lang, note.date),
          type: _type,
          lang: note.lang,
          version: note.version,
          json: jsonEncode({'title': note.title, 'body': note.body}),
          fetchedAt: _now(),
        ),
      );
}

/// The personal note from the Readings API (PRD §6.7, §8.2). Only placements
/// and the day's transits go out; a note that arrived is saved on the device.
class ApiPersonalNoteRepository implements PersonalNoteRepository {
  ApiPersonalNoteRepository({required this.api, required this.cache});

  final ReadingsApi api;
  final DriftPersonalNoteCache cache;

  @override
  Future<PersonalNote?> cached({
    required DateTime date,
    required String lang,
  }) => cache.find(lang: lang, date: personalDateKey(date));

  @override
  Future<PersonalNote> note({
    required NatalChart chart,
    required DateTime date,
    required String lang,
  }) async {
    final key = personalDateKey(date);
    final saved = await cache.find(lang: lang, date: key);
    if (saved != null) return saved;
    final data = await api.postJson(
      'daily/personal',
      personalNoteRequest(chart: chart, date: date, lang: lang),
    );
    final title = data['title'];
    final body = data['body'];
    final version = data['version'];
    if (title is! String || body is! String || version is! int) {
      throw const FormatException('The personal note has the wrong shape.');
    }
    final note = PersonalNote(
      date: key,
      lang: lang,
      version: version,
      title: title,
      body: body,
    );
    await cache.put(note);
    return note;
  }
}

/// Used while the build has no Readings API: only a saved note can be shown.
class UnavailablePersonalNoteRepository implements PersonalNoteRepository {
  const UnavailablePersonalNoteRepository(this.cache);

  final DriftPersonalNoteCache cache;

  @override
  Future<PersonalNote?> cached({
    required DateTime date,
    required String lang,
  }) => cache.find(lang: lang, date: personalDateKey(date));

  @override
  Future<PersonalNote> note({
    required NatalChart chart,
    required DateTime date,
    required String lang,
  }) => Future.error(const UnavailableFailure());
}
