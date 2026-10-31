import 'package:drift/drift.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/custom_cards/domain/own_card.dart';
import 'package:mochi_moon/features/custom_cards/domain/own_card_repository.dart';

class DriftOwnCardRepository implements OwnCardRepository {
  DriftOwnCardRepository(this._db);

  final AppDatabase _db;

  SimpleSelectStatement<$CustomCardsTable, CustomCard> get _newestFirst =>
      _db.select(_db.customCards)
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);

  @override
  Future<List<OwnCard>> cards() async => _toCards(await _newestFirst.get());

  @override
  Stream<List<OwnCard>> watch() => _newestFirst.watch().map(_toCards);

  @override
  Future<void> save(OwnCard card) async {
    await _db
        .into(_db.customCards)
        .insertOnConflictUpdate(_companion(card, synced: false));
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.customCards)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<List<OwnCard>> unsynced() async => _toCards(
    await (_newestFirst..where((t) => t.synced.equals(false))).get(),
  );

  @override
  Future<void> markSynced(List<OwnCard> cards) async {
    await _db.batch((batch) {
      for (final card in cards) {
        // Only if the card still reads the same: a newer edit stays unsent.
        batch.update(
          _db.customCards,
          const CustomCardsCompanion(synced: Value(true)),
          where: (t) =>
              t.id.equals(card.id) &
              t.body.equals(card.body) &
              t.illustrationId.equals(card.illustrationId),
        );
      }
    });
  }

  @override
  Future<void> addMissing(List<OwnCard> cards) async {
    await _db.batch((batch) {
      batch.insertAll(_db.customCards, [
        for (final card in cards) _companion(card, synced: true),
      ], mode: InsertMode.insertOrIgnore);
    });
  }

  CustomCardsCompanion _companion(OwnCard card, {required bool synced}) =>
      CustomCardsCompanion.insert(
        id: card.id,
        body: card.body,
        illustrationId: card.illustrationId,
        createdAt: card.createdAt,
        synced: Value(synced),
      );

  List<OwnCard> _toCards(List<CustomCard> rows) => [
    for (final row in rows)
      OwnCard(
        id: row.id,
        body: row.body,
        illustrationId: row.illustrationId,
        createdAt: row.createdAt,
      ),
  ];
}
