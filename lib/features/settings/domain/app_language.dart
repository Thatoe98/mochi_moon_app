/// The language the user picked for the app (PRD §6.14). Thai joins once it
/// has a native reviewer (CLAUDE.md §7).
enum AppLanguage {
  /// Follow the device language.
  system(null),
  english('en'),
  burmese('my');

  AppLanguage(this.code);

  /// The language code, or null to follow the device.
  final String? code;

  /// The language saved under [code]; unknown or missing codes follow the
  /// device.
  static AppLanguage fromCode(String? code) => values.firstWhere(
    (language) => language.code == code,
    orElse: () => system,
  );
}

abstract interface class AppLanguageRepository {
  /// The saved choice; [AppLanguage.system] until the user chooses.
  Future<AppLanguage> load();

  Future<void> save(AppLanguage language);
}
