import 'package:mochi_moon/features/settings/domain/reminder.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _enabledKey = 'reminder_enabled';
const _minutesKey = 'reminder_minutes';

/// Two tiny flags, which is what `shared_preferences` is for (CLAUDE.md §2).
class PrefsReminderSettingsRepository implements ReminderSettingsRepository {
  PrefsReminderSettingsRepository(this._prefs);

  final SharedPreferencesAsync _prefs;

  @override
  Future<ReminderSettings> load() async {
    final enabled = await _prefs.getBool(_enabledKey) ?? false;
    final minutes = await _prefs.getInt(_minutesKey);
    return ReminderSettings(
      enabled: enabled,
      time: minutes == null
          ? ReminderTime.defaultTime
          : ReminderTime.fromMinutes(minutes),
    );
  }

  @override
  Future<void> save(ReminderSettings settings) async {
    await _prefs.setBool(_enabledKey, settings.enabled);
    await _prefs.setInt(_minutesKey, settings.time.minutesSinceMidnight);
  }
}
