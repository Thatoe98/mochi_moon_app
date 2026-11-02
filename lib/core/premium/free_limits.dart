/// Every free-tier limit in one place (PRD §6.13, M4b). Limits only ever stop
/// her from making something NEW; what she already made always stays.
abstract final class FreeLimits {
  /// New cards a day from the ritual and the deck (PRD §6.2). Premium has no
  /// limit. Sample, journey-day and hard-day cards do not count.
  static const int deckCardsPerDay = 5;

  /// Cards of her own (PRD §6.17).
  static const int ownCards = 1;

  /// Sealed letters to future me at the same time (PRD §6.22).
  static const int sealedLetters = 1;

  /// Saved partners (PRD §6.12).
  static const int partners = 1;

  /// Calendar months of mood history shown in full: this one and the last
  /// (PRD §6.18).
  static const int moodMonths = 2;
}
