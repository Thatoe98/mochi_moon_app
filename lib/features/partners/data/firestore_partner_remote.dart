import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/partners/data/partner_codec.dart';
import 'package:mochi_moon/features/partners/domain/partner.dart';
import 'package:mochi_moon/features/partners/domain/partner_repository.dart';

class FirestorePartnerRemote implements PartnerRemote {
  FirestorePartnerRemote([FirebaseFirestore? firestore])
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _partners(String uid) =>
      _firestore.collection('users').doc(uid).collection('partners');

  @override
  Future<List<Partner>> fetch(String uid) => _guard(() async {
    final snapshot = await _partners(uid).get();
    return [
      for (final doc in snapshot.docs) ?partnerFromMap(doc.id, doc.data()),
    ];
  });

  @override
  Future<void> put(String uid, Partner partner) => _guard(
    () => _partners(uid).doc(partner.id).set({
      ...partnerToMap(partner),
      'createdAt': Timestamp.fromDate(partner.createdAt),
    }),
  );

  @override
  Future<void> delete(String uid, String id) =>
      _guard(() => _partners(uid).doc(id).delete());

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
