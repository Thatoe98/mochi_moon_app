// The in-memory platform ships with shared_preferences' own test tooling.
// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/review/data/prefs_review_history_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  late PrefsReviewHistoryRepository repository;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    repository = PrefsReviewHistoryRepository(SharedPreferencesAsync());
  });

  test('starts with no asks', () async {
    final history = await repository.load();
    expect(history.lastAsked, isNull);
    expect(history.timesAsked, 0);
  });

  test('remembers each ask', () async {
    await repository.markAsked(DateTime(2026, 11, 14, 20));
    await repository.markAsked(DateTime(2027, 3, 20, 9));
    final history = await repository.load();
    expect(history.lastAsked, DateTime(2027, 3, 20, 9));
    expect(history.timesAsked, 2);
  });
}
