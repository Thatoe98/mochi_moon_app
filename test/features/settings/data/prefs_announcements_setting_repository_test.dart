// The in-memory platform ships with shared_preferences' own test tooling.
// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/settings/data/prefs_announcements_setting_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  late PrefsAnnouncementsSettingRepository repository;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    repository = PrefsAnnouncementsSettingRepository(SharedPreferencesAsync());
  });

  test('is on until the user switches it off', () async {
    expect(await repository.load(), isTrue);
  });

  test('saves and loads both choices', () async {
    await repository.save(enabled: false);
    expect(await repository.load(), isFalse);

    await repository.save(enabled: true);
    expect(await repository.load(), isTrue);
  });
}
