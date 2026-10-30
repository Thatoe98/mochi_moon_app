/// The "Reduce motion" switch (PRD §6.14). The app already follows the
/// system's "remove animations" setting; this switch lets the user turn it on
/// inside the app as well.
abstract interface class ReduceMotionSettingRepository {
  /// Whether the user switched it on; false until they do.
  Future<bool> load();

  Future<void> save({required bool enabled});
}
