import 'package:mochi_moon/features/settings/domain/theme_mode_setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _key = 'theme_mode';

/// One tiny flag, which is what `shared_preferences` is for (CLAUDE.md §2).
class PrefsThemeModeSettingRepository implements ThemeModeSettingRepository {
  PrefsThemeModeSettingRepository(this._prefs);

  final SharedPreferencesAsync _prefs;

  @override
  Future<AppThemeChoice> load() async {
    final saved = await _prefs.getString(_key);
    return AppThemeChoice.values.firstWhere(
      (choice) => choice.name == saved,
      orElse: () => AppThemeChoice.system,
    );
  }

  @override
  Future<void> save(AppThemeChoice choice) =>
      _prefs.setString(_key, choice.name);
}
