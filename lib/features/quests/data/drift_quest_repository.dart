import 'package:drift/drift.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/quests/domain/quest_day.dart';
import 'package:mochi_moon/features/quests/domain/quest_repository.dart';

class DriftQuestRepository implements QuestRepository {
  DriftQuestRepository(this._db);

  final AppDatabase _db;

  SimpleSelectStatement<$QuestStatesTable, QuestState> get _latest =>
      _db.select(_db.questStates)
        ..orderBy([(t) => OrderingTerm.desc(t.date)])
        ..limit(1);

  QuestDay? _toDay(QuestState? row) => row == null
      ? null
      : QuestDay(
          date: row.date,
          questId: row.questId,
          done: row.done,
          swapped: row.swapped,
        );

  @override
  Stream<QuestDay?> watch() =>
      _latest.watchSingleOrNull().map<QuestDay?>(_toDay);

  @override
  Future<void> save(QuestDay day) => _write(day, synced: false);

  Future<void> _write(QuestDay day, {required bool synced}) =>
      _db.transaction(() async {
        await _db.delete(_db.questStates).go();
        await _db
            .into(_db.questStates)
            .insert(
              QuestStatesCompanion.insert(
                date: day.date,
                questId: day.questId,
                done: Value(day.done),
                swapped: Value(day.swapped),
                synced: Value(synced),
              ),
            );
      });

  @override
  Future<QuestDay?> unsynced() async => _toDay(
    await (_latest..where((t) => t.synced.equals(false))).getSingleOrNull(),
  );

  @override
  Future<void> markSynced(QuestDay day) async {
    await (_db.update(_db.questStates)..where(
          (t) =>
              t.date.equals(day.date) &
              t.questId.equals(day.questId) &
              t.done.equals(day.done) &
              t.swapped.equals(day.swapped),
        ))
        .write(const QuestStatesCompanion(synced: Value(true)));
  }

  @override
  Future<void> restore(QuestDay day) async {
    final local = await _latest.getSingleOrNull();
    if (local != null && local.date.compareTo(day.date) >= 0) return;
    await _write(day, synced: true);
  }
}
