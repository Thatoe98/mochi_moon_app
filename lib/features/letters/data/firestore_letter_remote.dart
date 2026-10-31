import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/letters/domain/future_letter.dart';
import 'package:mochi_moon/features/letters/domain/letter_repository.dart';

class FirestoreLetterRemote implements LetterRemote {
  FirestoreLetterRemote([FirebaseFirestore? firestore])
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _letters(String uid) =>
      _firestore.collection('users').doc(uid).collection('letters');

  @override
  Future<List<FutureLetter>> fetch(String uid) => _guard(() async {
    final snapshot = await _letters(uid).get();
    return [
      for (final doc in snapshot.docs)
        if (doc.data() case {
          'text': final String text,
          'writtenAt': final Timestamp writtenAt,
          'unlockAt': final Timestamp unlockAt,
          'unlockDays': final int unlockDays,
        })
          FutureLetter(
            id: doc.id,
            body: text,
            writtenAt: writtenAt.toDate(),
            unlockAt: unlockAt.toDate(),
            unlockDays: unlockDays,
          ),
    ];
  });

  @override
  Future<void> put(String uid, FutureLetter letter) => _guard(
    () => _letters(uid).doc(letter.id).set({
      'text': letter.body,
      'writtenAt': Timestamp.fromDate(letter.writtenAt),
      'unlockAt': Timestamp.fromDate(letter.unlockAt),
      'unlockDays': letter.unlockDays,
    }),
  );

  @override
  Future<void> delete(String uid, String id) =>
      _guard(() => _letters(uid).doc(id).delete());

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
