/// The "App news" switch (PRD §6.6): rare news about the app, sent to everyone
/// who is subscribed to one shared topic. Nothing about the user goes with it.
abstract interface class AnnouncementsSettingRepository {
  /// Whether app news is on; true until the user switches it off.
  Future<bool> load();

  Future<void> save({required bool enabled});
}

/// The shared `announcements` topic of the push service.
abstract interface class AnnouncementsTopic {
  Future<void> subscribe();

  Future<void> unsubscribe();
}
