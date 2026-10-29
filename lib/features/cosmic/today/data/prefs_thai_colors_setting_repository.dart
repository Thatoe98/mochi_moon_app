import 'package:mochi_moon/features/cosmic/today/domain/thai_colors_setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _key = 'show_thai_colors';

/// One tiny flag, which is what `shared_preferences` is for (CLAUDE.md §2).
class PrefsThaiColorsSettingRepository implements ThaiColorsSettingRepository {
  PrefsThaiColorsSettingRepository(this._prefs);

  final SharedPreferencesAsync _prefs;

  @override
  Future<bool?> load() => _prefs.getBool(_key);

  @override
  Future<void> save({required bool enabled}) => _prefs.setBool(_key, enabled);
}
