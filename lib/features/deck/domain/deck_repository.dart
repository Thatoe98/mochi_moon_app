import 'package:mochi_moon/features/deck/domain/deck_action.dart';

/// Local record of completed cards and the journal of saved ones.
abstract interface class DeckRepository {
  /// Every completed card, oldest first.
  Future<List<DeckEvent>> history();

  /// [history], emitted again after every change.
  Stream<List<DeckEvent>> watchHistory();

  /// Records a completed card. A [DeckAction.saved] card also lands in the
  /// journal. [source] says where it was read (PRD §6.2). Returns the new event.
  Future<DeckEvent> record(
    String quoteId,
    DeckAction action,
    DateTime at, {
    DeckSource source = DeckSource.deck,
  });

  /// Reverts [event], including its journal entry when it was saved.
  Future<void> undo(DeckEvent event);

  /// The local days (at midnight) on which the daily ritual was finished. A
  /// ritual day counts for the streak like a completed card (PRD 6.2, 6.15).
  Future<Set<DateTime>> ritualDays();

  /// [ritualDays], emitted again after every change.
  Stream<Set<DateTime>> watchRitualDays();

  /// Marks the local day of [at] as a finished ritual day. Doing it twice for
  /// the same day changes nothing.
  Future<void> markRitualDay(DateTime at);
}
