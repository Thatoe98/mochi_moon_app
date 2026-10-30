/// The user's answer to the analytics question (PRD §6.14).
abstract interface class AnalyticsConsentRepository {
  /// True when allowed, false when declined, null until the user answers.
  Future<bool?> load();

  Future<void> save({required bool granted});
}
