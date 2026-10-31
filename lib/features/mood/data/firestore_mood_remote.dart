import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';
import 'package:mochi_moon/features/mood/domain/mood_repository.dart';

class FirestoreMoodRemote implements MoodRemote {
  FirestoreMoodRemote([FirebaseFirestore? firestore])
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _moods(String uid) =>
      _firestore.collection('users').doc(uid).collection('moods');

  @override
  Future<List<DayMood>> fetch(String uid) => _guard(() async {
    final snapshot = await _moods(uid).get();
    return [
      for (final doc in snapshot.docs)
        if (parseMoodDateKey(doc.id) case final day?)
          if (doc.data()['mood'] case final String id)
            if (Mood.fromId(id) case final mood?) DayMood(day: day, mood: mood),
    ];
  });

  @override
  Future<void> put(String uid, DayMood mood) => _guard(
    () => _moods(uid)
        .doc(moodDateKey(mood.day))
        .set({'mood': mood.mood.id, 'updatedAt': FieldValue.serverTimestamp()}),
  );

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
