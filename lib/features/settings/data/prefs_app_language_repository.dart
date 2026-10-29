import 'package:mochi_moon/features/settings/domain/app_language.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _key = 'app_language';

/// One tiny flag, which is what `shared_preferences` is for (CLAUDE.md §2).
class PrefsAppLanguageRepository implements AppLanguageRepository {
  PrefsAppLanguageRepository(this._prefs);

  final SharedPreferencesAsync _prefs;

  @override
  Future<AppLanguage> load() async =>
      AppLanguage.fromCode(await _prefs.getString(_key));

  @override
  Future<void> save(AppLanguage language) async {
    final code = language.code;
    if (code == null) {
      await _prefs.remove(_key);
    } else {
      await _prefs.setString(_key, code);
    }
  }
}
