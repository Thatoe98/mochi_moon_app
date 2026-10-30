import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mochi_moon/features/settings/domain/announcements.dart';

const announcementsTopicName = 'announcements';

/// Joins and leaves the shared news topic. It needs no permission of its own;
/// showing a notification still waits for the Android 13+ prompt.
class FcmAnnouncementsTopic implements AnnouncementsTopic {
  FcmAnnouncementsTopic(this._messaging);

  final FirebaseMessaging _messaging;

  @override
  Future<void> subscribe() =>
      _messaging.subscribeToTopic(announcementsTopicName);

  @override
  Future<void> unsubscribe() =>
      _messaging.unsubscribeFromTopic(announcementsTopicName);
}

/// Used when Firebase did not start (an early dev build): there is no topic to
/// join, and the switch still saves the choice.
class NoopAnnouncementsTopic implements AnnouncementsTopic {
  const NoopAnnouncementsTopic();

  @override
  Future<void> subscribe() async {}

  @override
  Future<void> unsubscribe() async {}
}
