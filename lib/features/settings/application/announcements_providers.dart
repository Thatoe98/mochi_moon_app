import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/settings/data/fcm_announcements_topic.dart';
import 'package:mochi_moon/features/settings/data/prefs_announcements_setting_repository.dart';
import 'package:mochi_moon/features/settings/domain/announcements.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'announcements_providers.g.dart';

@Riverpod(keepAlive: true)
AnnouncementsSettingRepository announcementsSettingRepository(Ref ref) =>
    PrefsAnnouncementsSettingRepository(SharedPreferencesAsync());

@Riverpod(keepAlive: true)
AnnouncementsTopic announcementsTopic(Ref ref) =>
    ref.watch(firebaseReadyProvider)
    ? FcmAnnouncementsTopic(FirebaseMessaging.instance)
    : const NoopAnnouncementsTopic();

/// Whether "App news" is on, kept in sync with the topic subscription.
@Riverpod(keepAlive: true)
class AnnouncementsController extends _$AnnouncementsController {
  @override
  Future<bool> build() =>
      ref.watch(announcementsSettingRepositoryProvider).load();

  Future<void> set({required bool enabled}) async {
    await ref
        .read(announcementsSettingRepositoryProvider)
        .save(enabled: enabled);
    state = AsyncData(enabled);
    await _apply(enabled: enabled);
  }

  /// Joins or leaves the topic to match the saved choice. Called when the app
  /// opens, so a change that could not reach the service earlier is retried.
  Future<void> resync() async => await _apply(enabled: await future);

  Future<void> _apply({required bool enabled}) async {
    final topic = ref.read(announcementsTopicProvider);
    try {
      await (enabled ? topic.subscribe() : topic.unsubscribe());
    } on Exception catch (error) {
      // Offline or no push service: the saved choice stands and the next app
      // open tries again.
      debugPrint(
        'Could not update the announcements topic: ${error.runtimeType}',
      );
    }
  }
}

/// Matches the topic to the saved choice once per app run. Watched from the
/// app root.
@Riverpod(keepAlive: true)
Future<void> announcementsSync(Ref ref) =>
    ref.read(announcementsControllerProvider.notifier).resync();
