import 'package:flutter/foundation.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/profile/data/drift_profile_repository.dart';
import 'package:mochi_moon/features/profile/data/firestore_profile_remote.dart';
import 'package:mochi_moon/features/profile/data/profile_codec.dart';
import 'package:mochi_moon/features/profile/domain/profile_repository.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_providers.g.dart';

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) =>
    DriftProfileRepository(ref.watch(appDatabaseProvider));

/// The Firestore copy, or null when Firebase did not start.
@Riverpod(keepAlive: true)
ProfileRemote? profileRemote(Ref ref) =>
    ref.watch(firebaseReadyProvider) ? FirestoreProfileRemote() : null;

/// The user's profile, local first: it is saved on the device, then copied to
/// Firestore when someone is signed in.
@Riverpod(keepAlive: true)
class ProfileController extends _$ProfileController {
  @override
  Future<UserProfile?> build() => ref.watch(profileRepositoryProvider).load();

  /// Saves [profile] on the device and, if signed in, to Firestore. A failed
  /// upload is not an error for the user; it is retried by [reconcile].
  Future<void> save(UserProfile profile) async {
    await ref.read(profileRepositoryProvider).save(profile);
    state = AsyncData(profile);
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) await _push(user.uid, profile);
  }

  /// Brings the device and Firestore copies together for [uid] after sign-in
  /// or app start. A local profile with a name and birth data is uploaded. A
  /// local profile with only a name is uploaded too, after taking over any
  /// birth data the account already holds (set on another device or before
  /// this profile was reset). With no local profile, one from Firestore (for
  /// example after a reinstall) is taken. Returns the profile now in use.
  Future<UserProfile?> reconcile(String uid) async {
    final local = await future;
    if (local != null && local.hasAccountProfile && local.hasBirthData) {
      await _push(uid, local);
      return local;
    }
    final remote = ref.read(profileRemoteProvider);
    if (remote == null) return local;
    try {
      final fetched = await remote.fetch(uid);
      if (local != null && local.hasAccountProfile) {
        final merged = fetched != null && fetched.hasBirthData
            ? local.copyWith(
                birthDate: fetched.birthDate,
                birthMinutes: fetched.birthMinutes,
                birthPlace: fetched.birthPlace,
              )
            : local;
        if (merged != local) {
          await ref.read(profileRepositoryProvider).save(merged);
          state = AsyncData(merged);
        }
        await _push(uid, merged);
        return merged;
      }
      if (fetched != null && fetched.hasAccountProfile) {
        await ref.read(profileRepositoryProvider).save(fetched);
        state = AsyncData(fetched);
        return fetched;
      }
    } on AppFailure catch (error) {
      debugPrint('Could not read the profile from Firestore: $error');
    }
    return local;
  }

  Future<void> _push(String uid, UserProfile profile) async {
    final remote = ref.read(profileRemoteProvider);
    if (remote == null) return;
    final reminder = ref.read(reminderControllerProvider).value;
    try {
      await remote.upsert(
        uid,
        profile,
        locale: ref.read(reminderLanguageProvider),
        reminderTime: reminder != null && reminder.enabled
            ? formatMinutes(reminder.time.minutesSinceMidnight)
            : null,
      );
    } on AppFailure catch (error) {
      debugPrint('Could not save the profile to Firestore: $error');
    }
  }
}

/// Reconciles the profile whenever an account is signed in, so a failed
/// upload is retried the next time the app opens. Watched from the app root.
@Riverpod(keepAlive: true)
Future<void> profileSync(Ref ref) async {
  final user = await ref.watch(authUserProvider.future);
  if (user == null) return;
  await ref.read(profileControllerProvider.notifier).reconcile(user.uid);
}
