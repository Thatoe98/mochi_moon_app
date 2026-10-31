import 'dart:async';

import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/deck/domain/deck_counters.dart';
import 'package:mochi_moon/features/deck/domain/deck_repository.dart';

/// In-memory [DeckRepository] for tests.
class FakeDeckRepository implements DeckRepository {
  FakeDeckRepository([List<DeckEvent> seed = const []]) : events = [...seed];

  final List<DeckEvent> events;
  final _changes = StreamController<void>.broadcast();
  var _nextId = 100;

  @override
  Future<List<DeckEvent>> history() async => [...events];

  @override
  Stream<List<DeckEvent>> watchHistory() async* {
    yield [...events];
    await for (final _ in _changes.stream) {
      yield [...events];
    }
  }

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
    _changes.add(null);
    return event;
  }

  final _ritualDays = <DateTime>{};

  @override
  Future<Set<DateTime>> ritualDays() async => {..._ritualDays};

  @override
  Stream<Set<DateTime>> watchRitualDays() async* {
    yield {..._ritualDays};
    await for (final _ in _changes.stream) {
      yield {..._ritualDays};
    }
  }

  @override
  Future<void> markRitualDay(DateTime at) async {
    _ritualDays.add(DateTime(at.year, at.month, at.day));
    _changes.add(null);
  }

  @override
  Future<void> undo(DeckEvent event) async {
    events.removeWhere((e) => e.id == event.id);
    _changes.add(null);
  }
}

/// One call to [FakeDeckCountersRemote.put].
class CountersPut {
  const CountersPut(this.uid, this.counters);

  final String uid;
  final DeckCounters counters;
}

/// In-memory [DeckCountersRemote] for tests.
class FakeDeckCountersRemote implements DeckCountersRemote {
  final puts = <CountersPut>[];

  /// When set, every call fails with it.
  Exception? error;

  @override
  Future<void> put(String uid, DeckCounters counters) async {
    if (error case final error?) throw error;
    puts.add(CountersPut(uid, counters));
  }
}
