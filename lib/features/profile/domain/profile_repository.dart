import 'package:mochi_moon/features/profile/domain/user_profile.dart';

/// The profile kept on this device. It works signed out and offline.
abstract interface class ProfileRepository {
  /// The saved profile, or null before onboarding saved one.
  Future<UserProfile?> load();

  Future<void> save(UserProfile profile);

  Future<void> clear();
}

/// The copy of the profile in Firestore (`users/{uid}`, PRD §8.1).
abstract interface class ProfileRemote {
  /// The stored profile, or null when the account has none yet.
  Future<UserProfile?> fetch(String uid);

  /// Writes [profile], creating `users/{uid}` on first use. [locale] is the
  /// app language and [reminderTime] the daily reminder as `HH:mm` (null when
  /// off); both live on the same document.
  Future<void> upsert(
    String uid,
    UserProfile profile, {
    required String locale,
    String? reminderTime,
  });
}
