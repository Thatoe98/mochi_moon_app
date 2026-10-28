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

  /// Takes [quoteId] out of the journal. Its deck history is left alone.
  Future<void> remove(String quoteId);
}
