import 'package:drift/drift.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/journal/domain/journal_repository.dart';

class DriftJournalRepository implements JournalRepository {
  DriftJournalRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<JournalEntry>> entries() async {
    final rows = await (_db.select(
      _db.journalCache,
    )..orderBy([(t) => OrderingTerm.desc(t.savedAt)])).get();
    return [
      for (final row in rows)
        JournalEntry(quoteId: row.quoteId, savedAt: row.savedAt),
    ];
  }

  @override
  Future<void> remove(String quoteId) async {
    await (_db.delete(
      _db.journalCache,
    )..where((t) => t.quoteId.equals(quoteId))).go();
  }
}
