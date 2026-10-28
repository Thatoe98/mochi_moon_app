import 'package:mochi_moon/features/deck/domain/deck_action.dart';

/// Local record of completed cards and the journal of saved ones.
abstract interface class DeckRepository {
  /// Every completed card, oldest first.
  Future<List<DeckEvent>> history();

  /// Records a completed card. A [DeckAction.saved] card also lands in the
  /// journal. Returns the new event.
  Future<DeckEvent> record(String quoteId, DeckAction action, DateTime at);

  /// Reverts [event], including its journal entry when it was saved.
  Future<void> undo(DeckEvent event);
}
