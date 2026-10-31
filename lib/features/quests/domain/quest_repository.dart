import 'package:mochi_moon/features/quests/domain/quest_day.dart';

/// The quest state kept on the device: one record, the latest day.
abstract interface class QuestRepository {
  /// The saved day, or null when she has not touched a quest yet.
  Stream<QuestDay?> watch();

  /// Saves [day], replacing any other day, and marks it not yet sent.
  Future<void> save(QuestDay day);

  /// The saved day if Firestore does not have it yet.
  Future<QuestDay?> unsynced();

  /// Marks [day] as sent, only if it is still what is saved.
  Future<void> markSynced(QuestDay day);

  /// Takes [day] from Firestore when nothing is saved here or this device's
  /// day is older. A newer or equal local day stays.
  Future<void> restore(QuestDay day);
}

/// The copy in Firestore (`users/{uid}/state/quest`, PRD §8.1). Methods throw
/// an `AppFailure`.
abstract interface class QuestRemote {
  Future<QuestDay?> fetch(String uid);

  Future<void> put(String uid, QuestDay day);
}
