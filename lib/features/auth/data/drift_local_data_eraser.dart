import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/auth/domain/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Empties every table of the local database and every saved preference, so
/// the app starts again like a fresh install.
class DriftLocalDataEraser implements LocalDataEraser {
  DriftLocalDataEraser(this._db, this._prefs);

  final AppDatabase _db;
  final SharedPreferencesAsync _prefs;

  @override
  Future<void> eraseAll() async {
    await _db.transaction(() async {
      for (final table in _db.allTables) {
        await _db.delete(table).go();
      }
    });
    await _prefs.clear();
  }
}
