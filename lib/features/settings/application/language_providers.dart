import 'dart:ui';

import 'package:mochi_moon/features/settings/data/prefs_app_language_repository.dart';
import 'package:mochi_moon/features/settings/domain/app_language.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_providers.g.dart';

@Riverpod(keepAlive: true)
AppLanguageRepository appLanguageRepository(Ref ref) =>
    PrefsAppLanguageRepository(SharedPreferencesAsync());

/// The user's language choice, kept in sync with what is saved.
@Riverpod(keepAlive: true)
class LanguageController extends _$LanguageController {
  @override
  Future<AppLanguage> build() =>
      ref.watch(appLanguageRepositoryProvider).load();

  Future<void> select(AppLanguage language) async {
    await ref.read(appLanguageRepositoryProvider).save(language);
    state = AsyncData(language);
  }
}

/// The locale the app is forced into, or null to follow the device.
@Riverpod(keepAlive: true)
Locale? appLocale(Ref ref) {
  final code = ref.watch(languageControllerProvider).value?.code;
  return code == null ? null : Locale(code);
}

/// The language code content and notifications use: the user's choice, else
/// Burmese when the device uses it, else English.
@Riverpod(keepAlive: true)
String effectiveLanguage(Ref ref) {
  final code = ref.watch(languageControllerProvider).value?.code;
  if (code != null) return code;
  return PlatformDispatcher.instance.locale.languageCode == 'my' ? 'my' : 'en';
}
