/// What the user did with a card once it unlocked.
enum DeckAction {
  /// Swiped right: "This is me", saved to the journal.
  saved,

  /// Swiped left: on to the next card.
  skipped,

  /// Swiped up: opened the share sheet.
  shared,
}

/// One completed card, as stored in the deck history.
class DeckEvent {
  const DeckEvent({
    required this.id,
    required this.quoteId,
    required this.action,
    required this.at,
  });

  final int id;
  final String quoteId;
  final DeckAction action;
  final DateTime at;
}
