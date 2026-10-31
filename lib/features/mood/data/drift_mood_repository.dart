import 'package:drift/drift.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';
import 'package:mochi_moon/features/mood/domain/mood_repository.dart';

class DriftMoodRepository implements MoodRepository {
  DriftMoodRepository(this._db);

  final AppDatabase _db;

  SimpleSelectStatement<$MoodEntriesTable, MoodEntry> get _oldestFirst =>
      _db.select(_db.moodEntries)..orderBy([(t) => OrderingTerm.asc(t.date)]);

  @override
  Future<List<DayMood>> entries() async => _toMoods(await _oldestFirst.get());

  @override
  Stream<List<DayMood>> watch() => _oldestFirst.watch().map(_toMoods);

  @override
  Future<void> set(DayMood mood) async {
    await _db
        .into(_db.moodEntries)
        .insertOnConflictUpdate(
          MoodEntriesCompanion.insert(
            date: moodDateKey(mood.day),
            mood: mood.mood.id,
          ),
        );
  }

  @override
  Future<List<DayMood>> unsynced() async => _toMoods(
    await (_oldestFirst..where((t) => t.synced.equals(false))).get(),
  );

  @override
  Future<void> markSynced(List<DayMood> moods) async {
    await _db.batch((batch) {
      for (final mood in moods) {
        // Only if the day still holds this mood: a newer choice stays unsent.
        batch.update(
          _db.moodEntries,
          const MoodEntriesCompanion(synced: Value(true)),
          where: (t) =>
              t.date.equals(moodDateKey(mood.day)) &
              t.mood.equals(mood.mood.id),
        );
      }
    });
  }

  @override
  Future<void> addMissing(List<DayMood> moods) async {
    await _db.batch((batch) {
      batch.insertAll(_db.moodEntries, [
        for (final mood in moods)
          MoodEntriesCompanion.insert(
            date: moodDateKey(mood.day),
            mood: mood.mood.id,
            synced: const Value(true),
          ),
      ], mode: InsertMode.insertOrIgnore);
    });
  }

  /// Rows with a date or mood this version does not know are skipped.
  List<DayMood> _toMoods(List<MoodEntry> rows) => [
    for (final row in rows)
      if (parseMoodDateKey(row.date) case final day?)
        if (Mood.fromId(row.mood) case final mood?)
          DayMood(day: day, mood: mood),
  ];
}
