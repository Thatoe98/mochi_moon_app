import 'package:mochi_moon/features/letters/domain/future_letter.dart';

/// The letters to her future self kept on the device.
abstract interface class LetterRepository {
  /// Every letter, soonest unlock first.
  Future<List<FutureLetter>> letters();

  /// [letters], emitted again after every change.
  Stream<List<FutureLetter>> watch();

  /// Stores a sealed [letter]; it counts as not yet sent to Firestore.
  Future<void> add(FutureLetter letter);

  Future<void> delete(String id);

  Future<List<FutureLetter>> unsynced();

  Future<void> markSynced(List<FutureLetter> letters);

  /// Adds the letters not stored here yet, for example ones restored from
  /// Firestore. An id that exists here is left as it is.
  Future<void> addMissing(List<FutureLetter> letters);
}

/// The copy in Firestore (`users/{uid}/letters/{id}`, PRD §8.1). Methods throw
/// an `AppFailure`.
abstract interface class LetterRemote {
  Future<List<FutureLetter>> fetch(String uid);

  Future<void> put(String uid, FutureLetter letter);

  Future<void> delete(String uid, String id);
}

/// What the "your letter is ready" notification says. It never contains the
/// letter, which is why the scheduler is not given one.
class LetterNotificationTexts {
  const LetterNotificationTexts({
    required this.title,
    required this.body,
    required this.channelName,
    required this.channelDescription,
  });

  final String title;
  final String body;
  final String channelName;
  final String channelDescription;
}

/// Schedules the notification that tells her a letter can be opened.
abstract interface class LetterNotifier {
  /// Replaces every letter notification with one per entry of [openings]
  /// (letter id to the moment it opens). Moments in the past are skipped.
  Future<void> schedule(
    Map<String, DateTime> openings,
    LetterNotificationTexts texts,
  );

  /// Removes the notification of [letterId].
  Future<void> cancel(String letterId);
}
