// The in-memory platform ships with shared_preferences' own test tooling.
// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/settings/data/prefs_app_language_repository.dart';
import 'package:mochi_moon/features/settings/domain/app_language.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  late PrefsAppLanguageRepository repository;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    repository = PrefsAppLanguageRepository(SharedPreferencesAsync());
  });

  test('follows the device until the user chooses', () async {
    expect(await repository.load(), AppLanguage.system);
  });

  test('saves and loads each choice', () async {
    for (final language in AppLanguage.values) {
      await repository.save(language);
      expect(await repository.load(), language);
    }
  });

  test('choosing the device language clears an earlier choice', () async {
    await repository.save(AppLanguage.burmese);
    await repository.save(AppLanguage.system);
    expect(await SharedPreferencesAsync().getString('app_language'), isNull);
  });
}
