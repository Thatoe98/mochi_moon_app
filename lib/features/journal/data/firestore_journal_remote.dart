import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/journal/domain/journal_repository.dart';

class FirestoreJournalRemote implements JournalRemote {
  FirestoreJournalRemote([FirebaseFirestore? firestore])
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _journal(String uid) =>
      _firestore.collection('users').doc(uid).collection('journal');

  @override
  Future<List<JournalEntry>> fetch(String uid) => _guard(() async {
    final snapshot = await _journal(uid).get();
    return [
      for (final doc in snapshot.docs)
        if (doc.data()['savedAt'] case final Timestamp savedAt)
          JournalEntry(quoteId: doc.id, savedAt: savedAt.toDate()),
    ];
  });

  @override
  Future<void> put(String uid, JournalEntry entry) => _guard(
    () => _journal(uid).doc(entry.quoteId).set({
      'savedAt': Timestamp.fromDate(entry.savedAt),
    }),
  );

  @override
  Future<void> delete(String uid, String quoteId) =>
      _guard(() => _journal(uid).doc(quoteId).delete());

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
