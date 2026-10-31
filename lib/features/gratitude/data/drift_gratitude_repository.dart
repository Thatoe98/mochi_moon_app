import 'package:drift/drift.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/gratitude/domain/gratitude.dart';
import 'package:mochi_moon/features/gratitude/domain/gratitude_repository.dart';

class DriftGratitudeRepository implements GratitudeRepository {
  DriftGratitudeRepository(this._db);

  final AppDatabase _db;

  SimpleSelectStatement<$GratitudeEntriesTable, GratitudeEntry>
  get _newestFirst =>
      _db.select(_db.gratitudeEntries)
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);

  @override
  Future<List<GratitudeNote>> entries() async =>
      _toEntries(await _newestFirst.get());

  @override
  Stream<List<GratitudeNote>> watch() => _newestFirst.watch().map(_toEntries);

  @override
  Future<void> add(GratitudeNote entry) async {
    await _db
        .into(_db.gratitudeEntries)
        .insertOnConflictUpdate(_companion(entry, synced: false));
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(
      _db.gratitudeEntries,
    )..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<List<GratitudeNote>> unsynced() async => _toEntries(
    await (_newestFirst..where((t) => t.synced.equals(false))).get(),
  );

  @override
  Future<void> markSynced(List<GratitudeNote> entries) async {
    await _db.batch((batch) {
      for (final entry in entries) {
        batch.update(
          _db.gratitudeEntries,
          const GratitudeEntriesCompanion(synced: Value(true)),
          where: (t) => t.id.equals(entry.id),
        );
      }
    });
  }

  @override
  Future<void> addMissing(List<GratitudeNote> entries) async {
    await _db.batch((batch) {
      batch.insertAll(_db.gratitudeEntries, [
        for (final entry in entries) _companion(entry, synced: true),
      ], mode: InsertMode.insertOrIgnore);
    });
  }

  GratitudeEntriesCompanion _companion(
    GratitudeNote entry, {
    required bool synced,
  }) => GratitudeEntriesCompanion.insert(
    id: entry.id,
    date: gratitudeDateKey(entry.day),
    body: entry.body,
    createdAt: entry.createdAt,
    synced: Value(synced),
  );

  /// Rows with a date this version cannot read are skipped.
  List<GratitudeNote> _toEntries(List<GratitudeEntry> rows) => [
    for (final row in rows)
      if (parseGratitudeDateKey(row.date) case final day?)
        GratitudeNote(
          id: row.id,
          day: day,
          body: row.body,
          createdAt: row.createdAt,
        ),
  ];
}
