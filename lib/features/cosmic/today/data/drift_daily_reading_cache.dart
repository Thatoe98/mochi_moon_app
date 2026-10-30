import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/cosmic/today/data/daily_reading_codec.dart';
import 'package:mochi_moon/features/cosmic/today/domain/daily_reading.dart';

/// A reading read back from the cache.
class CachedDailyReading {
  const CachedDailyReading({required this.reading, required this.fetchedAt});

  final DailyReading reading;
  final DateTime fetchedAt;
}

/// Server readings kept on the device by date, sign and language (PRD §8.6),
/// so the page shows at once and works offline.
class DriftDailyReadingCache {
  DriftDailyReadingCache(this._db, [this._now = DateTime.now]);

  final AppDatabase _db;
  final DateTime Function() _now;

  /// The cached reading, or null when there is none or the row is damaged.
  Future<CachedDailyReading?> find({
    required String date,
    required String sign,
    required String lang,
  }) async {
    final row =
        await (_db.select(_db.cachedReadings)..where(
              (t) =>
                  t.date.equals(date) &
                  t.sign.equals(sign) &
                  t.lang.equals(lang),
            ))
            .getSingleOrNull();
    if (row == null) return null;
    try {
      final decoded = jsonDecode(row.json);
      if (decoded is! Map<String, Object?>) return null;
      return CachedDailyReading(
        reading: dailyReadingFromJson(decoded).reading,
        fetchedAt: row.fetchedAt,
      );
    } on FormatException {
      return null;
    }
  }

  /// Stores [reading] under its own language, replacing an older copy.
  Future<void> put({
    required String date,
    required String sign,
    required DailyReading reading,
    required int version,
  }) => _db
      .into(_db.cachedReadings)
      .insertOnConflictUpdate(
        CachedReadingsCompanion.insert(
          date: date,
          sign: sign,
          lang: reading.lang,
          version: version,
          json: jsonEncode(dailyReadingToJson(reading, version)),
          fetchedAt: _now(),
        ),
      );

  /// Forgets readings from before [date], which nobody opens again.
  Future<void> deleteBefore(String date) => (_db.delete(
    _db.cachedReadings,
  )..where((t) => t.date.isSmallerThanValue(date))).go();
}
