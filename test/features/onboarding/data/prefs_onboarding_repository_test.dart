// The in-memory platform ships with shared_preferences' own test tooling.
// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/onboarding/data/prefs_onboarding_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  late PrefsOnboardingRepository repository;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    repository = PrefsOnboardingRepository(SharedPreferencesAsync());
  });

  test('a new install has not finished the flow', () async {
    expect(await repository.isComplete(), isFalse);
  });

  test('remembers that the flow was finished', () async {
    await repository.markComplete();

    expect(await repository.isComplete(), isTrue);
    // A second repository over the same storage sees it too.
    expect(
      await PrefsOnboardingRepository(SharedPreferencesAsync()).isComplete(),
      isTrue,
    );
  });
}
