/// What the user did with a card once it unlocked.
enum DeckAction {
  /// Swiped right: "This is me", saved to the journal.
  saved,

  /// Swiped left: on to the next card.
  skipped,

  /// Swiped up: opened the share sheet.
  shared,
}

/// Where a card was read. Every source counts for the streak; only the
/// ritual and the deck use up the free daily limit (PRD §6.2).
enum DeckSource {
  /// The Deck tab.
  deck(countsTowardLimit: true),

  /// The daily ritual's three cards.
  ritual(countsTowardLimit: true),

  /// The sample cards at the end of onboarding.
  sample(countsTowardLimit: false),

  /// A self-love journey's day card.
  journey(countsTowardLimit: false);

  DeckSource({required this.countsTowardLimit});

  final bool countsTowardLimit;
}

/// One completed card, as stored in the deck history.
class DeckEvent {
  const DeckEvent({
    required this.id,
    required this.quoteId,
    required this.action,
    required this.at,
    this.source = DeckSource.deck,
  });

  final int id;
  final String quoteId;
  final DeckAction action;
  final DateTime at;
  final DeckSource source;
}
