/// How the app picks light or dark: follow the phone, or always one of them.
enum AppThemeChoice { system, light, dark }

/// Remembers the user's [AppThemeChoice] on this device.
abstract interface class ThemeModeSettingRepository {
  /// [AppThemeChoice.system] until the user picks something else.
  Future<AppThemeChoice> load();

  Future<void> save(AppThemeChoice choice);
}
