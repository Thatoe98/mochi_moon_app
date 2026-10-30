import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/partners/data/partner_codec.dart';
import 'package:mochi_moon/features/partners/domain/partner.dart';
import 'package:mochi_moon/features/partners/domain/partner_repository.dart';

class DriftPartnerRepository implements PartnerRepository {
  DriftPartnerRepository(this._db);

  final AppDatabase _db;

  SimpleSelectStatement<$PartnerCacheTable, PartnerCacheData>
  get _oldestFirst =>
      _db.select(_db.partnerCache)
        ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);

  @override
  Future<List<Partner>> partners() async => _decode(await _oldestFirst.get());

  @override
  Stream<List<Partner>> watch() => _oldestFirst.watch().map(_decode);

  @override
  Future<void> save(Partner partner) async {
    await _db
        .into(_db.partnerCache)
        .insertOnConflictUpdate(_toCompanion(partner));
  }

  @override
  Future<void> remove(String id) async {
    await (_db.delete(_db.partnerCache)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> addMissing(List<Partner> partners) async {
    await _db.batch((batch) {
      batch.insertAll(_db.partnerCache, [
        for (final partner in partners) _toCompanion(partner),
      ], mode: InsertMode.insertOrIgnore);
    });
  }

  PartnerCacheCompanion _toCompanion(Partner partner) =>
      PartnerCacheCompanion.insert(
        id: partner.id,
        json: jsonEncode(partnerToMap(partner)),
        createdAt: partner.createdAt,
      );

  /// A row that no longer reads as a partner is skipped rather than failing
  /// the whole list.
  List<Partner> _decode(List<PartnerCacheData> rows) => [
    for (final row in rows) ?_decodeRow(row),
  ];

  Partner? _decodeRow(PartnerCacheData row) {
    try {
      final map = jsonDecode(row.json);
      if (map is! Map<String, Object?>) return null;
      return partnerFromMap(row.id, map);
    } on FormatException {
      return null;
    }
  }
}
