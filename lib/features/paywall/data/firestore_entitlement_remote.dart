import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mochi_moon/features/paywall/domain/entitlement.dart';

/// Listens to `users/{uid}.entitlement`. Firestore keeps the last value on
/// the phone, so a known Premium stays on while she is offline.
class FirestoreEntitlementRemote {
  FirestoreEntitlementRemote([FirebaseFirestore? firestore])
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<Entitlement> watch(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      final raw = snapshot.data()?['entitlement'];
      if (raw is! Map) return Entitlement.none;
      final expires = raw['expiresAt'];
      return Entitlement.fromMap({
        ...raw,
        'expiresAt': expires is Timestamp ? expires.toDate() : null,
      });
    });
  }
}
