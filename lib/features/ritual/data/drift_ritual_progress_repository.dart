import 'dart:convert';

import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/ritual/domain/ritual_state.dart';

class DriftRitualProgressRepository implements RitualProgressRepository {
  DriftRitualProgressRepository(this._db);

  final AppDatabase _db;

  @override
  Future<SavedRitual?> load(DateTime day) async {
    final row = await (_db.select(
      _db.ritualProgress,
    )..where((t) => t.date.equals(_key(day)))).getSingleOrNull();
    if (row == null) return null;
    final phase = row.step >= 0 && row.step < RitualPhase.values.length
        ? RitualPhase.values[row.step]
        : null;
    if (phase == null) return null;
    final decoded = jsonDecode(row.quoteIds);
    return SavedRitual(
      day: DateTime(day.year, day.month, day.day),
      phase: phase,
      quoteIds: [if (decoded is List) ...decoded.whereType<String>()],
    );
  }

  @override
  Future<void> save(SavedRitual ritual) => _db
      .into(_db.ritualProgress)
      .insertOnConflictUpdate(
        RitualProgressCompanion.insert(
          date: _key(ritual.day),
          step: ritual.phase.index,
          quoteIds: jsonEncode(ritual.quoteIds),
        ),
      );

  static String _key(DateTime day) =>
      '${day.year.toString().padLeft(4, '0')}-'
      '${day.month.toString().padLeft(2, '0')}-'
      '${day.day.toString().padLeft(2, '0')}';
}
