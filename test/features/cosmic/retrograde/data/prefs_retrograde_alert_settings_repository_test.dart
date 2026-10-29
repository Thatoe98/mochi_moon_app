// The in-memory platform ships with shared_preferences' own test tooling.
// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/retrograde/data/prefs_retrograde_alert_settings_repository.dart';
import 'package:mochi_moon/features/cosmic/retrograde/domain/retrograde_alerts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  late PrefsRetrogradeAlertSettingsRepository repository;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    repository = PrefsRetrogradeAlertSettingsRepository(
      SharedPreferencesAsync(),
    );
  });

  test('defaults to Mercury only when nothing was saved', () async {
    expect(await repository.load(), defaultRetrogradeAlertPlanets);
  });

  test('keeps the chosen planets', () async {
    await repository.save({Body.venus, Body.mars});
    expect(await repository.load(), {Body.venus, Body.mars});
  });

  test('remembers that every planet was switched off', () async {
    await repository.save({});
    expect(await repository.load(), isEmpty);
  });
}
