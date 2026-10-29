import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/retrograde/domain/retrograde_alerts.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _planetsKey = 'retrograde_alert_planets';

/// The chosen planets as a list of body names. A missing key means the user
/// never chose, so the defaults apply; an empty list means all are off.
class PrefsRetrogradeAlertSettingsRepository
    implements RetrogradeAlertSettingsRepository {
  PrefsRetrogradeAlertSettingsRepository(this._prefs);

  final SharedPreferencesAsync _prefs;

  @override
  Future<Set<Body>> load() async {
    final names = await _prefs.getStringList(_planetsKey);
    if (names == null) return defaultRetrogradeAlertPlanets;
    return {
      for (final body in retrogradeAlertBodies)
        if (names.contains(body.name)) body,
    };
  }

  @override
  Future<void> save(Set<Body> planets) => _prefs.setStringList(_planetsKey, [
    for (final body in planets) body.name,
  ]);
}
