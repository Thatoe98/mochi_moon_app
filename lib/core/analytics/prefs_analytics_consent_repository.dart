import 'package:mochi_moon/core/analytics/analytics_consent_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _key = 'analytics_consent';

/// One tiny flag, which is what `shared_preferences` is for (CLAUDE.md §2).
class PrefsAnalyticsConsentRepository implements AnalyticsConsentRepository {
  PrefsAnalyticsConsentRepository(this._prefs);

  final SharedPreferencesAsync _prefs;

  @override
  Future<bool?> load() => _prefs.getBool(_key);

  @override
  Future<void> save({required bool granted}) => _prefs.setBool(_key, granted);
}
