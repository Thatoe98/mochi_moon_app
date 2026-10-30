import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/profile/data/profile_codec.dart';
import 'package:mochi_moon/features/profile/domain/profile_repository.dart';
import 'package:mochi_moon/features/profile/domain/profile_signs.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';

class FirestoreProfileRemote implements ProfileRemote {
  FirestoreProfileRemote([FirebaseFirestore? firestore])
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _firestore.collection('users').doc(uid);

  @override
  Future<UserProfile?> fetch(String uid) => _guard(() async {
    final snapshot = await _doc(uid).get();
    final data = snapshot.data();
    if (data == null) return null;
    // A document made before the profile step has a name at most.
    if (data['profile'] == null) return null;
    return profileFromMap(data);
  });

  @override
  Future<void> upsert(
    String uid,
    UserProfile profile, {
    required String locale,
    String? reminderTime,
  }) => _guard(() async {
    final doc = _doc(uid);
    final exists = (await doc.get()).exists;
    final signs = signsOfProfile(profile);
    final map = profileToMap(profile);
    await doc.set({
      ...map,
      // The signs are derived from the birth data, so they are rewritten on
      // every save and never go stale.
      'profile': {
        ...(map['profile']! as Map<String, Object?>),
        if (signs != null) ...signs.toMap(),
      },
      'locale': locale,
      'settings': {'reminderTime': reminderTime},
      'updatedAt': FieldValue.serverTimestamp(),
      if (!exists) 'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  });

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on FirebaseException catch (error) {
      throw error.code == 'unavailable'
          ? const NetworkFailure()
          : UnknownFailure(error);
    }
  }
}
