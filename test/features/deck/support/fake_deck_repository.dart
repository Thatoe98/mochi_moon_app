import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/deck/domain/deck_repository.dart';

/// In-memory [DeckRepository] for tests.
class FakeDeckRepository implements DeckRepository {
  FakeDeckRepository([List<DeckEvent> seed = const []]) : events = [...seed];

  final List<DeckEvent> events;
  var _nextId = 100;

  @override
  Future<List<DeckEvent>> history() async => [...events];

  @override
  Future<DeckEvent> record(
    String quoteId,
    DeckAction action,
    DateTime at,
  ) async {
    final event = DeckEvent(
      id: _nextId++,
      quoteId: quoteId,
      action: action,
      at: at,
    );
    events.add(event);
    return event;
  }

  @override
  Future<void> undo(DeckEvent event) async =>
      events.removeWhere((e) => e.id == event.id);
}
