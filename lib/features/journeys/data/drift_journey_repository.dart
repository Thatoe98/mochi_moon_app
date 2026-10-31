import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/journeys/domain/journey_progress.dart';
import 'package:mochi_moon/features/journeys/domain/journey_repository.dart';

class DriftJourneyRepository implements JourneyRepository {
  DriftJourneyRepository(this._db);

  final AppDatabase _db;

  JourneyProgress _toProgress(JourneyProgressEntry row) => JourneyProgress(
    journeyId: row.journeyId,
    startedAt: row.startedAt,
    currentDay: row.currentDay,
    completedDays: [
      for (final day in jsonDecode(row.completedDays) as List<dynamic>)
        day as int,
    ],
    reflections: {
      for (final entry
          in (jsonDecode(row.reflections) as Map<String, dynamic>).entries)
        int.parse(entry.key): entry.value as String,
    },
    completedAt: row.completedAt,
    lastDoneOn: row.lastDoneOn,
  );

  JourneyProgressEntriesCompanion _toRow(
    JourneyProgress progress, {
    required bool synced,
  }) => JourneyProgressEntriesCompanion.insert(
    journeyId: progress.journeyId,
    startedAt: progress.startedAt,
    currentDay: Value(progress.currentDay),
    completedDays: Value(jsonEncode(progress.completedDays)),
    reflections: Value(
      jsonEncode({
        for (final entry in progress.reflections.entries)
          '${entry.key}': entry.value,
      }),
    ),
    completedAt: Value(progress.completedAt),
    lastDoneOn: Value(progress.lastDoneOn),
    synced: Value(synced),
  );

  @override
  Stream<List<JourneyProgress>> watchAll() =>
      (_db.select(_db.journeyProgressEntries)
            ..orderBy([(t) => OrderingTerm.asc(t.startedAt)]))
          .watch()
          .map((rows) => rows.map(_toProgress).toList());

  @override
  Future<void> save(JourneyProgress progress) => _db
      .into(_db.journeyProgressEntries)
      .insertOnConflictUpdate(_toRow(progress, synced: false));

  @override
  Future<List<JourneyProgress>> unsynced() async {
    final rows = await (_db.select(
      _db.journeyProgressEntries,
    )..where((t) => t.synced.equals(false))).get();
    return rows.map(_toProgress).toList();
  }

  @override
  Future<void> markSynced(JourneyProgress progress) async {
    final saved = await (_db.select(
      _db.journeyProgressEntries,
    )..where((t) => t.journeyId.equals(progress.journeyId))).getSingleOrNull();
    if (saved == null || _toProgress(saved) != progress) return;
    await (_db.update(_db.journeyProgressEntries)
          ..where((t) => t.journeyId.equals(progress.journeyId)))
        .write(const JourneyProgressEntriesCompanion(synced: Value(true)));
  }

  @override
  Future<void> restore(JourneyProgress progress) async {
    final saved = await (_db.select(
      _db.journeyProgressEntries,
    )..where((t) => t.journeyId.equals(progress.journeyId))).getSingleOrNull();
    if (saved != null) {
      final local = _toProgress(saved);
      if (local.completedDays.length >= progress.completedDays.length) return;
      // Keep the date of the last finished day, so a restore cannot let her
      // finish a second day today.
      await _db
          .into(_db.journeyProgressEntries)
          .insertOnConflictUpdate(
            _toRow(
              JourneyProgress(
                journeyId: progress.journeyId,
                startedAt: progress.startedAt,
                currentDay: progress.currentDay,
                completedDays: progress.completedDays,
                reflections: progress.reflections,
                completedAt: progress.completedAt,
                lastDoneOn: local.lastDoneOn,
              ),
              synced: true,
            ),
          );
      return;
    }
    await _db
        .into(_db.journeyProgressEntries)
        .insertOnConflictUpdate(_toRow(progress, synced: true));
  }
}
