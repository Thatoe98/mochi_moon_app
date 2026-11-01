import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mochi_moon/core/content/mascot_item.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/mascot/domain/mascot_repository.dart';
import 'package:mochi_moon/features/mascot/domain/mascot_state.dart';

class FirestoreMascotRemote implements MascotRemote {
  FirestoreMascotRemote([FirebaseFirestore? firestore])
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _firestore.collection('users').doc(uid).collection('state').doc('mascot');

  @override
  Future<MascotState?> fetch(String uid) => _guard(() async {
    final data = (await _doc(uid).get()).data();
    return data == null ? null : mascotStateFromMap(data);
  });

  @override
  Future<void> put(String uid, MascotState state) =>
      _guard(() => _doc(uid).set(mascotStateToMap(state)));

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

/// The fields the rules allow (PRD §8.1): `owned`, `equipped`, `updatedAt`.
/// [updatedAt] defaults to the server time.
Map<String, Object> mascotStateToMap(MascotState state, {Object? updatedAt}) =>
    {
      'owned': state.owned,
      'equipped': {'outfit': state.outfit, 'room': state.room},
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };

/// Null when a field is missing or the wrong type.
MascotState? mascotStateFromMap(Map<String, dynamic> data) {
  final owned = data['owned'];
  final equipped = data['equipped'];
  if (owned is! List || equipped is! Map) return null;
  if (owned.any((e) => e is! String)) return null;
  final slots = <String, String>{};
  final outfit = equipped['outfit'];
  if (outfit is String) slots[outfitSlot] = outfit;
  final room = equipped['room'];
  if (room is Map) {
    for (final entry in room.entries) {
      if (entry.key is String && entry.value is String) {
        slots[entry.key as String] = entry.value as String;
      }
    }
  }
  return MascotState(owned: owned.cast<String>(), equipped: slots);
}
