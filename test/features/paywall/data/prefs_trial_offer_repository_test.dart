// The in-memory platform ships with shared_preferences' own test tooling.
// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/paywall/data/prefs_trial_offer_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  late PrefsTrialOfferRepository repository;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    repository = PrefsTrialOfferRepository(SharedPreferencesAsync());
  });

  test('starts as not shown', () async {
    expect(await repository.wasShown(), isFalse);
  });

  test('remembers that it was shown', () async {
    await repository.markShown();
    expect(await repository.wasShown(), isTrue);
  });

  test('remembers the hard-day kit for that day only', () async {
    final today = DateTime(2026, 11, 3);
    expect(await repository.openedHardDayOn(today), isFalse);
    await repository.noteHardDay(DateTime(2026, 11, 3, 18));
    expect(await repository.openedHardDayOn(today), isTrue);
    expect(await repository.openedHardDayOn(DateTime(2026, 11, 4)), isFalse);
  });
}
