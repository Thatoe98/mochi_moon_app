import 'package:drift/drift.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/mascot/domain/mascot_repository.dart';
import 'package:mochi_moon/features/mascot/domain/mascot_state.dart';

class DriftMascotRepository implements MascotRepository {
  DriftMascotRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<MascotState> watch() =>
      (_db.select(_db.mascotInventory)..orderBy([
            (t) => OrderingTerm.asc(t.earnedAt),
            (t) => OrderingTerm.asc(t.itemId),
          ]))
          .watch()
          .map(
            (rows) => MascotState(
              owned: [for (final r in rows) r.itemId],
              equipped: {
                for (final r in rows)
                  if (r.equippedSlot != null) r.equippedSlot!: r.itemId,
              },
            ),
          );

  @override
  Future<void> grant(Iterable<String> itemIds, DateTime at) => _db.batch((b) {
    for (final id in itemIds) {
      b.insert(
        _db.mascotInventory,
        MascotInventoryCompanion.insert(itemId: id, earnedAt: at),
        mode: InsertMode.insertOrIgnore,
      );
    }
  });

  @override
  Future<void> equip(String slot, String itemId) => _db.transaction(() async {
    await unequip(slot);
    await (_db.update(_db.mascotInventory)
          ..where((t) => t.itemId.equals(itemId)))
        .write(MascotInventoryCompanion(equippedSlot: Value(slot)));
  });

  @override
  Future<void> unequip(String slot) =>
      (_db.update(_db.mascotInventory)
            ..where((t) => t.equippedSlot.equals(slot)))
          .write(const MascotInventoryCompanion(equippedSlot: Value(null)));

  @override
  Future<void> restore(MascotState remote, DateTime now) =>
      _db.transaction(() async {
        await grant(remote.owned, now);
        final local = await _db.select(_db.mascotInventory).get();
        final taken = {
          for (final r in local)
            if (r.equippedSlot != null) r.equippedSlot!,
        };
        final worn = {
          for (final r in local)
            if (r.equippedSlot != null) r.itemId,
        };
        for (final entry in remote.equipped.entries) {
          if (taken.contains(entry.key) || worn.contains(entry.value)) continue;
          if (!remote.owned.contains(entry.value)) continue;
          await equip(entry.key, entry.value);
        }
      });
}
