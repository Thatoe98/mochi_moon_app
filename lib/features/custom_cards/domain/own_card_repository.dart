import 'package:mochi_moon/features/custom_cards/domain/own_card.dart';

/// The cards she wrote, kept on the device.
abstract interface class OwnCardRepository {
  /// Every card, newest first.
  Future<List<OwnCard>> cards();

  /// [cards], emitted again after every change.
  Stream<List<OwnCard>> watch();

  /// Stores [card], replacing the one with the same id. The card counts as
  /// not yet sent to Firestore. The limits are checked by the caller.
  Future<void> save(OwnCard card);

  Future<void> delete(String id);

  /// The cards changed here that Firestore does not have yet.
  Future<List<OwnCard>> unsynced();

  /// Marks [cards] as sent, unless one was changed again meanwhile.
  Future<void> markSynced(List<OwnCard> cards);

  /// Adds the cards not stored here yet, for example ones restored from
  /// Firestore. An id that exists here is left as it is.
  Future<void> addMissing(List<OwnCard> cards);
}

/// The copy in Firestore (`users/{uid}/customCards/{id}`, PRD §8.1). Methods
/// throw an `AppFailure`.
abstract interface class OwnCardRemote {
  Future<List<OwnCard>> fetch(String uid);

  Future<void> put(String uid, OwnCard card);

  Future<void> delete(String uid, String id);
}
