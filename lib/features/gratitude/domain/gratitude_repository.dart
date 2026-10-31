import 'package:mochi_moon/features/gratitude/domain/gratitude.dart';

/// The gratitude and wins entries kept on the device.
abstract interface class GratitudeRepository {
  /// Every entry, newest first.
  Future<List<GratitudeNote>> entries();

  /// [entries], emitted again after every change.
  Stream<List<GratitudeNote>> watch();

  /// Stores [entry]; it counts as not yet sent to Firestore. The limits are
  /// checked by the caller.
  Future<void> add(GratitudeNote entry);

  Future<void> delete(String id);

  /// The entries added here that Firestore does not have yet.
  Future<List<GratitudeNote>> unsynced();

  Future<void> markSynced(List<GratitudeNote> entries);

  /// Adds the entries not stored here yet, for example ones restored from
  /// Firestore. An id that exists here is left as it is.
  Future<void> addMissing(List<GratitudeNote> entries);
}

/// The copy in Firestore (`users/{uid}/gratitude/{id}`, PRD §8.1). Methods
/// throw an `AppFailure`.
abstract interface class GratitudeRemote {
  Future<List<GratitudeNote>> fetch(String uid);

  Future<void> put(String uid, GratitudeNote entry);

  Future<void> delete(String uid, String id);
}
