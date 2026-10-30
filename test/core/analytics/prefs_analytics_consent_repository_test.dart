// The in-memory platform ships with shared_preferences' own test tooling.
// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/analytics/prefs_analytics_consent_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  late PrefsAnalyticsConsentRepository repository;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    repository = PrefsAnalyticsConsentRepository(SharedPreferencesAsync());
  });

  test('is unanswered until the user chooses', () async {
    expect(await repository.load(), isNull);
  });

  test('saves and loads both answers', () async {
    await repository.save(granted: true);
    expect(await repository.load(), isTrue);

    await repository.save(granted: false);
    expect(await repository.load(), isFalse);
  });
}
