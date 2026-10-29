/// Whether the Thai birthday and day colors show on Today (PRD §6.7). Only
/// the user's explicit choice is stored; until they choose, it is on for Thai
/// and off for other languages.
abstract interface class ThaiColorsSettingRepository {
  /// The saved choice, or null when the user has not chosen.
  Future<bool?> load();

  Future<void> save({required bool enabled});
}

/// The default for [lang] while the user has not chosen.
bool thaiColorsDefaultFor(String lang) => lang == 'th';
