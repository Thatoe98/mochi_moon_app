import 'package:mochi_moon/features/widget_bridge/domain/widget_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _key = 'widget_theme';

/// One tiny flag, which is what `shared_preferences` is for (CLAUDE.md §2).
class PrefsWidgetThemeRepository implements WidgetThemeRepository {
  PrefsWidgetThemeRepository(this._prefs);

  final SharedPreferencesAsync _prefs;

  @override
  Future<WidgetTheme> load() async =>
      WidgetTheme.fromId(await _prefs.getString(_key));

  @override
  Future<void> save(WidgetTheme theme) => _prefs.setString(_key, theme.id);
}
