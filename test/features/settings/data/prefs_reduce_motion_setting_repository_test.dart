// The in-memory platform ships with shared_preferences' own test tooling.
// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/settings/data/prefs_reduce_motion_setting_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  late PrefsReduceMotionSettingRepository repository;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    repository = PrefsReduceMotionSettingRepository(SharedPreferencesAsync());
  });

  test('is off until the user switches it on', () async {
    expect(await repository.load(), isFalse);
  });

  test('saves and loads both choices', () async {
    await repository.save(enabled: true);
    expect(await repository.load(), isTrue);

    await repository.save(enabled: false);
    expect(await repository.load(), isFalse);
  });
}
