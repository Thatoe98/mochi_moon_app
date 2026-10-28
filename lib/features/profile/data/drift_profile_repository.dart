import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/profile/data/profile_codec.dart';
import 'package:mochi_moon/features/profile/domain/profile_repository.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';

class DriftProfileRepository implements ProfileRepository {
  DriftProfileRepository(this._db, [this._now = DateTime.now]);

  static const _rowId = 0;

  final AppDatabase _db;
  final DateTime Function() _now;

  @override
  Future<UserProfile?> load() async {
    final row = await (_db.select(
      _db.profileCache,
    )..where((t) => t.id.equals(_rowId))).getSingleOrNull();
    if (row == null) return null;
    try {
      final decoded = jsonDecode(row.json);
      if (decoded is Map<String, Object?>) return profileFromMap(decoded);
    } on FormatException {
      // Fall through: a damaged row reads as "no profile yet".
    }
    return null;
  }

  @override
  Future<void> save(UserProfile profile) async {
    await _db
        .into(_db.profileCache)
        .insertOnConflictUpdate(
          ProfileCacheCompanion.insert(
            id: const Value(_rowId),
            json: jsonEncode(profileToMap(profile)),
            updatedAt: _now(),
          ),
        );
  }

  @override
  Future<void> clear() async {
    await _db.delete(_db.profileCache).go();
  }
}
