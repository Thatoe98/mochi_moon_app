/// Whether the Thai birthday and day colors show on Today (PRD §6.7). Only
/// the user's explicit choice is stored; until they choose, it is on when the
/// phone's region is Thailand. It never shows outside Thailand.
abstract interface class ThaiColorsSettingRepository {
  /// The saved choice, or null when the user has not chosen.
  Future<bool?> load();

  Future<void> save({required bool enabled});
}

/// The default while the user has not chosen.
bool thaiColorsDefaultFor({required bool inThailand}) => inThailand;
