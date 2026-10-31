import 'package:mochi_moon/features/journeys/domain/journey_progress.dart';

/// Her journey progress kept on the device, one record per journey.
abstract interface class JourneyRepository {
  /// Every journey she has started.
  Stream<List<JourneyProgress>> watchAll();

  /// Saves [progress] and marks it not yet sent.
  Future<void> save(JourneyProgress progress);

  /// The records Firestore does not have yet.
  Future<List<JourneyProgress>> unsynced();

  /// Marks [progress] as sent, only if it is still what is saved.
  Future<void> markSynced(JourneyProgress progress);

  /// Takes [progress] from Firestore when nothing is saved here or Firestore
  /// is further along. Progress never goes backwards.
  Future<void> restore(JourneyProgress progress);
}

/// The copy in Firestore (`users/{uid}/journeyProgress/{journeyId}`, PRD
/// §8.1). Methods throw an `AppFailure`.
abstract interface class JourneyRemote {
  Future<List<JourneyProgress>> fetchAll(String uid);

  Future<void> put(String uid, JourneyProgress progress);
}
