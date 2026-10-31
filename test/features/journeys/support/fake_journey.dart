import 'dart:async';

import 'package:mochi_moon/features/journeys/domain/journey_progress.dart';
import 'package:mochi_moon/features/journeys/domain/journey_repository.dart';

/// In-memory [JourneyRepository] for tests.
class FakeJourneyRepository implements JourneyRepository {
  FakeJourneyRepository([Iterable<JourneyProgress> seed = const []]) {
    for (final progress in seed) {
      _runs[progress.journeyId] = progress;
    }
  }

  final Map<String, JourneyProgress> _runs = {};
  final Set<String> _unsynced = {};
  final _changes = StreamController<void>.broadcast();

  /// The saved record of [journeyId], if any.
  JourneyProgress? saved(String journeyId) => _runs[journeyId];

  @override
  Stream<List<JourneyProgress>> watchAll() async* {
    yield _runs.values.toList();
    await for (final _ in _changes.stream) {
      yield _runs.values.toList();
    }
  }

  @override
  Future<void> save(JourneyProgress progress) async {
    _runs[progress.journeyId] = progress;
    _unsynced.add(progress.journeyId);
    _changes.add(null);
  }

  @override
  Future<List<JourneyProgress>> unsynced() async => [
    for (final id in _unsynced) _runs[id]!,
  ];

  @override
  Future<void> markSynced(JourneyProgress progress) async {
    if (_runs[progress.journeyId] == progress) {
      _unsynced.remove(progress.journeyId);
    }
  }

  @override
  Future<void> restore(JourneyProgress progress) async {
    final local = _runs[progress.journeyId];
    if (local != null &&
        local.completedDays.length >= progress.completedDays.length) {
      return;
    }
    _runs[progress.journeyId] = progress;
    _unsynced.remove(progress.journeyId);
    _changes.add(null);
  }
}

/// In-memory [JourneyRemote] for tests, keyed by uid then journey id.
class FakeJourneyRemote implements JourneyRemote {
  FakeJourneyRemote([Map<String, Map<String, JourneyProgress>>? stored])
    : stored = stored ?? {};

  final Map<String, Map<String, JourneyProgress>> stored;

  /// When set, every call fails with it.
  Exception? error;

  @override
  Future<List<JourneyProgress>> fetchAll(String uid) async {
    if (error case final error?) throw error;
    return (stored[uid] ?? const {}).values.toList();
  }

  @override
  Future<void> put(String uid, JourneyProgress progress) async {
    if (error case final error?) throw error;
    (stored[uid] ??= {})[progress.journeyId] = progress;
  }
}
