import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/auth/domain/auth_repository.dart';

/// Deletes a user's documents from Firestore. `reports` is left alone: the
/// rules only let the server write there, so the server cleans it up.
class FirestoreAccountRemote implements AccountRemote {
  FirestoreAccountRemote([
    FirebaseFirestore? firestore,
    this.timeout = const Duration(seconds: 15),
  ]) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Firestore queues writes while offline instead of failing, so each step
  /// is cut off after this long and reported as a network problem.
  final Duration timeout;

  /// Stays under Firestore's 500-writes-per-batch limit.
  static const _batchSize = 400;

  /// Subcollections the app writes under `users/{uid}`.
  static const _subcollections = ['journal', 'partners'];

  @override
  Future<void> deleteUserData(String uid) => _guard(() async {
    final user = _firestore.collection('users').doc(uid);
    for (final name in _subcollections) {
      await _deleteAll(user.collection(name));
    }
    await user.delete();
  });

  Future<void> _deleteAll(
    CollectionReference<Map<String, dynamic>> collection,
  ) async {
    final snapshot = await collection.get();
    for (var i = 0; i < snapshot.docs.length; i += _batchSize) {
      final batch = _firestore.batch();
      for (final doc in snapshot.docs.skip(i).take(_batchSize)) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
  }

  Future<void> _guard(Future<void> Function() body) async {
    try {
      await body().timeout(timeout);
    } on TimeoutException {
      throw const NetworkFailure();
    } on FirebaseException catch (error) {
      throw error.code == 'unavailable'
          ? const NetworkFailure()
          : UnknownFailure(error);
    }
  }
}
