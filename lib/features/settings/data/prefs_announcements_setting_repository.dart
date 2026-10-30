import 'package:mochi_moon/features/settings/domain/announcements.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _key = 'announcements';

/// One tiny flag, which is what `shared_preferences` is for (CLAUDE.md §2).
class PrefsAnnouncementsSettingRepository
    implements AnnouncementsSettingRepository {
  PrefsAnnouncementsSettingRepository(this._prefs);

  final SharedPreferencesAsync _prefs;

  @override
  Future<bool> load() async => await _prefs.getBool(_key) ?? true;

  @override
  Future<void> save({required bool enabled}) => _prefs.setBool(_key, enabled);
}
