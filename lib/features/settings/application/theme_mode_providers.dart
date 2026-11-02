import 'package:flutter/material.dart';
import 'package:mochi_moon/features/settings/data/prefs_theme_mode_setting_repository.dart';
import 'package:mochi_moon/features/settings/domain/theme_mode_setting.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_mode_providers.g.dart';

@Riverpod(keepAlive: true)
ThemeModeSettingRepository themeModeSettingRepository(Ref ref) =>
    PrefsThemeModeSettingRepository(SharedPreferencesAsync());

/// The user's light/dark choice, kept in sync with what is saved.
@Riverpod(keepAlive: true)
class ThemeModeController extends _$ThemeModeController {
  @override
  Future<AppThemeChoice> build() =>
      ref.watch(themeModeSettingRepositoryProvider).load();

  Future<void> set(AppThemeChoice choice) async {
    await ref.read(themeModeSettingRepositoryProvider).save(choice);
    state = AsyncData(choice);
  }
}

/// The choice as Flutter's [ThemeMode] for `MaterialApp`.
@Riverpod(keepAlive: true)
ThemeMode appThemeMode(Ref ref) {
  final choice =
      ref.watch(themeModeControllerProvider).value ?? AppThemeChoice.system;
  return switch (choice) {
    AppThemeChoice.system => ThemeMode.system,
    AppThemeChoice.light => ThemeMode.light,
    AppThemeChoice.dark => ThemeMode.dark,
  };
}
