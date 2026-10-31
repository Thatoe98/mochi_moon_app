import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/custom_cards/domain/own_card.dart';
import 'package:mochi_moon/features/custom_cards/domain/own_card_repository.dart';

class FirestoreOwnCardRemote implements OwnCardRemote {
  FirestoreOwnCardRemote([FirebaseFirestore? firestore])
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _cards(String uid) =>
      _firestore.collection('users').doc(uid).collection('customCards');

  @override
  Future<List<OwnCard>> fetch(String uid) => _guard(() async {
    final snapshot = await _cards(uid).get();
    return [
      for (final doc in snapshot.docs)
        if (doc.data() case {
          'text': final String text,
          'illustrationId': final String illustrationId,
          'createdAt': final Timestamp createdAt,
        })
          OwnCard(
            id: doc.id,
            body: text,
            illustrationId: illustrationId,
            createdAt: createdAt.toDate(),
          ),
    ];
  });

  @override
  Future<void> put(String uid, OwnCard card) => _guard(
    () => _cards(uid).doc(card.id).set({
      'text': card.body,
      'illustrationId': card.illustrationId,
      'createdAt': Timestamp.fromDate(card.createdAt),
      'updatedAt': Timestamp.now(),
    }),
  );

  @override
  Future<void> delete(String uid, String id) =>
      _guard(() => _cards(uid).doc(id).delete());

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
