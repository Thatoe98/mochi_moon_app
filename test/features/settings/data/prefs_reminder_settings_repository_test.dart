// The in-memory platform ships with shared_preferences' own test tooling.
// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/settings/data/prefs_reminder_settings_repository.dart';
import 'package:mochi_moon/features/settings/domain/reminder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  late PrefsReminderSettingsRepository repository;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    repository = PrefsReminderSettingsRepository(SharedPreferencesAsync());
  });

  test('defaults to off at 08:00', () async {
    expect(await repository.load(), const ReminderSettings());
    expect((await repository.load()).time, ReminderTime.defaultTime);
  });

  test('saves and loads the choice', () async {
    const chosen = ReminderSettings(enabled: true, time: ReminderTime(21, 30));

    await repository.save(chosen);

    expect(await repository.load(), chosen);
  });
}
