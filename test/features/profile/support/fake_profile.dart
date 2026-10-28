import 'package:mochi_moon/features/profile/domain/profile_repository.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';

/// In-memory [ProfileRepository] for tests.
class FakeProfileRepository implements ProfileRepository {
  FakeProfileRepository([this.profile]);

  UserProfile? profile;

  /// When set, saving fails with it.
  Exception? saveError;

  @override
  Future<UserProfile?> load() async => profile;

  @override
  Future<void> save(UserProfile profile) async {
    if (saveError case final error?) throw error;
    this.profile = profile;
  }

  @override
  Future<void> clear() async => profile = null;
}

/// One call to [FakeProfileRemote.upsert].
class Upsert {
  const Upsert(this.uid, this.profile, this.locale, this.reminderTime);

  final String uid;
  final UserProfile profile;
  final String locale;
  final String? reminderTime;
}

/// In-memory [ProfileRemote] for tests, keyed by uid.
class FakeProfileRemote implements ProfileRemote {
  FakeProfileRemote([Map<String, UserProfile>? stored]) : stored = stored ?? {};

  final Map<String, UserProfile> stored;
  final upserts = <Upsert>[];

  /// When set, every call fails with it.
  Exception? error;

  @override
  Future<UserProfile?> fetch(String uid) async {
    if (error case final error?) throw error;
    return stored[uid];
  }

  @override
  Future<void> upsert(
    String uid,
    UserProfile profile, {
    required String locale,
    String? reminderTime,
  }) async {
    if (error case final error?) throw error;
    upserts.add(Upsert(uid, profile, locale, reminderTime));
    stored[uid] = profile;
  }
}
