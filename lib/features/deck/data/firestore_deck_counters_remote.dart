import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/deck/domain/deck_counters.dart';

class FirestoreDeckCountersRemote implements DeckCountersRemote {
  FirestoreDeckCountersRemote([FirebaseFirestore? firestore])
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<void> put(String uid, DeckCounters counters) async {
    try {
      final doc = _firestore.collection('users').doc(uid);
      final exists = (await doc.get()).exists;
      await doc.set({
        'deck': {
          'streak': counters.streak,
          'lastCompletedDate': _date(counters.lastCompletedDate),
          'todayCount': counters.todayCount,
          'todayDate': _date(counters.todayDate),
        },
        'updatedAt': FieldValue.serverTimestamp(),
        if (!exists) 'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } on FirebaseException catch (error) {
      throw error.code == 'unavailable'
          ? const NetworkFailure()
          : UnknownFailure(error);
    }
  }

  /// `YYYY-MM-DD`, as in PRD §8.1.
  String? _date(DateTime? day) => day == null
      ? null
      : '${day.year.toString().padLeft(4, '0')}-'
            '${day.month.toString().padLeft(2, '0')}-'
            '${day.day.toString().padLeft(2, '0')}';
}
