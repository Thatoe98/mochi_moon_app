import 'package:drift/drift.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/letters/domain/future_letter.dart';
import 'package:mochi_moon/features/letters/domain/letter_repository.dart';

class DriftLetterRepository implements LetterRepository {
  DriftLetterRepository(this._db);

  final AppDatabase _db;

  SimpleSelectStatement<$FutureLetterEntriesTable, FutureLetterEntry>
  get _soonestFirst =>
      _db.select(_db.futureLetterEntries)
        ..orderBy([(t) => OrderingTerm.asc(t.unlockAt)]);

  @override
  Future<List<FutureLetter>> letters() async =>
      _toLetters(await _soonestFirst.get());

  @override
  Stream<List<FutureLetter>> watch() => _soonestFirst.watch().map(_toLetters);

  @override
  Future<void> add(FutureLetter letter) async {
    await _db
        .into(_db.futureLetterEntries)
        .insertOnConflictUpdate(_companion(letter, synced: false));
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(
      _db.futureLetterEntries,
    )..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<List<FutureLetter>> unsynced() async => _toLetters(
    await (_soonestFirst..where((t) => t.synced.equals(false))).get(),
  );

  @override
  Future<void> markSynced(List<FutureLetter> letters) async {
    await _db.batch((batch) {
      for (final letter in letters) {
        batch.update(
          _db.futureLetterEntries,
          const FutureLetterEntriesCompanion(synced: Value(true)),
          where: (t) => t.id.equals(letter.id),
        );
      }
    });
  }

  @override
  Future<void> addMissing(List<FutureLetter> letters) async {
    await _db.batch((batch) {
      batch.insertAll(_db.futureLetterEntries, [
        for (final letter in letters) _companion(letter, synced: true),
      ], mode: InsertMode.insertOrIgnore);
    });
  }

  FutureLetterEntriesCompanion _companion(
    FutureLetter letter, {
    required bool synced,
  }) => FutureLetterEntriesCompanion.insert(
    id: letter.id,
    body: letter.body,
    writtenAt: letter.writtenAt,
    unlockAt: letter.unlockAt,
    unlockDays: letter.unlockDays,
    synced: Value(synced),
  );

  List<FutureLetter> _toLetters(List<FutureLetterEntry> rows) => [
    for (final row in rows)
      FutureLetter(
        id: row.id,
        body: row.body,
        writtenAt: row.writtenAt,
        unlockAt: row.unlockAt,
        unlockDays: row.unlockDays,
      ),
  ];
}
