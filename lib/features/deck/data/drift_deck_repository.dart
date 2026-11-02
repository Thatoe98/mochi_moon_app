import 'package:drift/drift.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/deck/domain/deck_repository.dart';

class DriftDeckRepository implements DeckRepository {
  DriftDeckRepository(this._db);

  final AppDatabase _db;

  SimpleSelectStatement<$DeckHistoryTable, DeckHistoryData> get _oldestFirst =>
      _db.select(_db.deckHistory)..orderBy([
        (t) => OrderingTerm.asc(t.at),
        (t) => OrderingTerm.asc(t.id),
      ]);

  @override
  Future<List<DeckEvent>> history() async =>
      (await _oldestFirst.get()).map(_toEvent).toList();

  @override
  Stream<List<DeckEvent>> watchHistory() =>
      _oldestFirst.watch().map((rows) => rows.map(_toEvent).toList());

  @override
  Future<DeckEvent> record(
    String quoteId,
    DeckAction action,
    DateTime at, {
    DeckSource source = DeckSource.deck,
  }) {
    return _db.transaction(() async {
      final row = await _db
          .into(_db.deckHistory)
          .insertReturning(
            DeckHistoryCompanion.insert(
              quoteId: quoteId,
              action: action.name,
              at: at,
              source: Value(source.name),
            ),
          );
      if (action == DeckAction.saved) {
        await _db
            .into(_db.journalCache)
            .insertOnConflictUpdate(
              JournalCacheCompanion.insert(quoteId: quoteId, savedAt: at),
            );
      }
      return _toEvent(row);
    });
  }

  @override
  Future<void> undo(DeckEvent event) {
    return _db.transaction(() async {
      await (_db.delete(
        _db.deckHistory,
      )..where((t) => t.id.equals(event.id))).go();
      if (event.action != DeckAction.saved) return;

      // Keep the journal entry when the same card was saved on another day.
      final otherSaves =
          await (_db.select(_db.deckHistory)..where(
                (t) =>
                    t.quoteId.equals(event.quoteId) &
                    t.action.equals(DeckAction.saved.name),
              ))
              .get();
      if (otherSaves.isEmpty) {
        await (_db.delete(
          _db.journalCache,
        )..where((t) => t.quoteId.equals(event.quoteId))).go();
      }
    });
  }

  @override
  Future<Set<DateTime>> ritualDays() async =>
      (await _db.select(_db.ritualDays).get()).map(_toDay).toSet();

  @override
  Stream<Set<DateTime>> watchRitualDays() => _db
      .select(_db.ritualDays)
      .watch()
      .map((rows) => rows.map(_toDay).toSet());

  @override
  Future<void> markRitualDay(DateTime at) => _db
      .into(_db.ritualDays)
      .insert(
        RitualDaysCompanion.insert(date: _key(at), completedAt: at),
        mode: InsertMode.insertOrIgnore,
      );

  static String _key(DateTime t) =>
      '${t.year.toString().padLeft(4, '0')}-'
      '${t.month.toString().padLeft(2, '0')}-'
      '${t.day.toString().padLeft(2, '0')}';

  static DateTime _toDay(RitualDay row) {
    final parts = row.date.split('-').map(int.parse).toList();
    return DateTime(parts[0], parts[1], parts[2]);
  }

  DeckEvent _toEvent(DeckHistoryData row) => DeckEvent(
    id: row.id,
    quoteId: row.quoteId,
    action: DeckAction.values.byName(row.action),
    at: row.at,
    source: DeckSource.values.asNameMap()[row.source] ?? DeckSource.deck,
  );
}
