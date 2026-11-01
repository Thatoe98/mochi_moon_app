import 'package:mochi_moon/features/mascot/domain/mascot_state.dart';

/// The mascot inventory kept on the device.
abstract interface class MascotRepository {
  Stream<MascotState> watch();

  /// Adds [itemIds] she does not own yet, earned at [at]. Never removes.
  Future<void> grant(Iterable<String> itemIds, DateTime at);

  /// Puts [itemId] in [slot], replacing what was there. The caller checks
  /// ownership and Premium.
  Future<void> equip(String slot, String itemId);

  Future<void> unequip(String slot);

  /// Merges the Firestore copy: owned items are added, and a slot she has not
  /// filled here takes the remote item if she owns it.
  Future<void> restore(MascotState remote, DateTime now);
}

/// The copy in Firestore (`users/{uid}/state/mascot`, PRD §8.1). Methods
/// throw an `AppFailure`.
abstract interface class MascotRemote {
  Future<MascotState?> fetch(String uid);

  Future<void> put(String uid, MascotState state);
}
