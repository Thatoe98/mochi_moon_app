import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/gratitude/domain/gratitude.dart';
import 'package:mochi_moon/features/gratitude/domain/gratitude_repository.dart';

class FirestoreGratitudeRemote implements GratitudeRemote {
  FirestoreGratitudeRemote([FirebaseFirestore? firestore])
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _entries(String uid) =>
      _firestore.collection('users').doc(uid).collection('gratitude');

  @override
  Future<List<GratitudeNote>> fetch(String uid) => _guard(() async {
    final snapshot = await _entries(uid).get();
    return [
      for (final doc in snapshot.docs)
        if (doc.data() case {
          'text': final String text,
          'date': final String date,
          'createdAt': final Timestamp createdAt,
        })
          if (parseGratitudeDateKey(date) case final day?)
            GratitudeNote(
              id: doc.id,
              day: day,
              body: text,
              createdAt: createdAt.toDate(),
            ),
    ];
  });

  @override
  Future<void> put(String uid, GratitudeNote entry) => _guard(
    () => _entries(uid).doc(entry.id).set({
      'text': entry.body,
      'date': gratitudeDateKey(entry.day),
      'createdAt': Timestamp.fromDate(entry.createdAt),
    }),
  );

  @override
  Future<void> delete(String uid, String id) =>
      _guard(() => _entries(uid).doc(id).delete());

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
