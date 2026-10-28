import 'package:drift/drift.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/journal/domain/journal_repository.dart';

class DriftJournalRepository implements JournalRepository {
  DriftJournalRepository(this._db);

  final AppDatabase _db;

  SimpleSelectStatement<$JournalCacheTable, JournalCacheData> get _newestFirst =>
      _db.select(_db.journalCache)
        ..orderBy([(t) => OrderingTerm.desc(t.savedAt)]);

  @override
  Future<List<JournalEntry>> entries() async =>
      (await _newestFirst.get()).map(_toEntry).toList();

  @override
  Stream<List<JournalEntry>> watch() =>
      _newestFirst.watch().map((rows) => rows.map(_toEntry).toList());

  @override
  Future<void> remove(String quoteId) async {
    await (_db.delete(
      _db.journalCache,
    )..where((t) => t.quoteId.equals(quoteId))).go();
  }

  @override
  Future<void> addMissing(List<JournalEntry> entries) async {
    await _db.batch((batch) {
      batch.insertAll(_db.journalCache, [
        for (final entry in entries)
          JournalCacheCompanion.insert(
            quoteId: entry.quoteId,
            savedAt: entry.savedAt,
          ),
      ], mode: InsertMode.insertOrIgnore);
    });
  }

  JournalEntry _toEntry(JournalCacheData row) =>
      JournalEntry(quoteId: row.quoteId, savedAt: row.savedAt);
}
