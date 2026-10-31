import 'package:mochi_moon/features/mood/domain/mood.dart';

/// The moods kept on the device, one per local day.
abstract interface class MoodRepository {
  /// Every day with a mood, oldest first.
  Future<List<DayMood>> entries();

  /// [entries], emitted again after every change.
  Stream<List<DayMood>> watch();

  /// Sets the mood of [mood]'s day; the last choice for a day wins. The day
  /// counts as not yet sent to Firestore.
  Future<void> set(DayMood mood);

  /// The days changed on this device that Firestore does not have yet.
  Future<List<DayMood>> unsynced();

  Future<void> markSynced(List<DayMood> moods);

  /// Adds the days that have no mood here yet, for example moods restored from
  /// Firestore. A day that already has one keeps it.
  Future<void> addMissing(List<DayMood> moods);
}

/// The copy of the moods in Firestore (`users/{uid}/moods/{YYYY-MM-DD}`,
/// PRD §8.1). Methods throw an `AppFailure`.
abstract interface class MoodRemote {
  Future<List<DayMood>> fetch(String uid);

  Future<void> put(String uid, DayMood mood);
}
