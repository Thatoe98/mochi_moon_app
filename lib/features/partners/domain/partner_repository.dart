import 'package:mochi_moon/features/partners/domain/partner.dart';

/// The partners saved on this device.
abstract interface class PartnerRepository {
  /// Every partner, oldest first.
  Future<List<Partner>> partners();

  /// [partners], emitted again after every change.
  Stream<List<Partner>> watch();

  /// Adds [partner], or replaces the one with the same id.
  Future<void> save(Partner partner);

  /// Removes the partner with [id].
  Future<void> remove(String id);

  /// Adds the [partners] that are not saved here yet, for example ones
  /// restored from Firestore. Partners already here are left as they are.
  Future<void> addMissing(List<Partner> partners);
}

/// The copy of the partners in Firestore (`users/{uid}/partners/{id}`,
/// PRD §8.1). Methods throw an `AppFailure`.
abstract interface class PartnerRemote {
  Future<List<Partner>> fetch(String uid);

  Future<void> put(String uid, Partner partner);

  Future<void> delete(String uid, String id);
}
