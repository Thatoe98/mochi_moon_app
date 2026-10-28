/// A card the user saved with "This is me".
class JournalEntry {
  const JournalEntry({required this.quoteId, required this.savedAt});

  final String quoteId;
  final DateTime savedAt;
}

/// The local journal of saved cards.
abstract interface class JournalRepository {
  /// Every saved card, newest first.
  Future<List<JournalEntry>> entries();

  /// [entries], emitted again after every change.
  Stream<List<JournalEntry>> watch();

  /// Takes [quoteId] out of the journal. Its deck history is left alone.
  Future<void> remove(String quoteId);

  /// Adds the [entries] that are not saved here yet, for example cards
  /// restored from Firestore. Cards already saved keep their date.
  Future<void> addMissing(List<JournalEntry> entries);
}

/// The copy of the journal in Firestore (`users/{uid}/journal/{quoteId}`,
/// PRD §8.1). Methods throw an `AppFailure`.
abstract interface class JournalRemote {
  Future<List<JournalEntry>> fetch(String uid);

  Future<void> put(String uid, JournalEntry entry);

  Future<void> delete(String uid, String quoteId);
}
