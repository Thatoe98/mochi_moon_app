import 'package:mochi_moon/features/settings/domain/announcements.dart';

/// [saved] is on until the user switches it off, like the real repository.
class FakeAnnouncementsSettingRepository
    implements AnnouncementsSettingRepository {
  FakeAnnouncementsSettingRepository({this.saved = true});

  bool saved;

  @override
  Future<bool> load() async => saved;

  @override
  Future<void> save({required bool enabled}) async => saved = enabled;
}

class FakeAnnouncementsTopic implements AnnouncementsTopic {
  FakeAnnouncementsTopic({this.failWith});

  final Exception? failWith;

  /// Every call, in order: `subscribe` or `unsubscribe`.
  final calls = <String>[];

  @override
  Future<void> subscribe() async {
    calls.add('subscribe');
    final error = failWith;
    if (error != null) throw error;
  }

  @override
  Future<void> unsubscribe() async {
    calls.add('unsubscribe');
    final error = failWith;
    if (error != null) throw error;
  }
}
