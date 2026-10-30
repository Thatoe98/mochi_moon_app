import 'package:mochi_moon/features/settings/domain/reduce_motion_setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _key = 'reduce_motion';

/// One tiny flag, which is what `shared_preferences` is for (CLAUDE.md §2).
class PrefsReduceMotionSettingRepository
    implements ReduceMotionSettingRepository {
  PrefsReduceMotionSettingRepository(this._prefs);

  final SharedPreferencesAsync _prefs;

  @override
  Future<bool> load() async => await _prefs.getBool(_key) ?? false;

  @override
  Future<void> save({required bool enabled}) => _prefs.setBool(_key, enabled);
}
