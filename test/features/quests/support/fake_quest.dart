import 'dart:async';

import 'package:mochi_moon/features/quests/domain/quest_day.dart';
import 'package:mochi_moon/features/quests/domain/quest_repository.dart';

/// In-memory [QuestRepository] for tests.
class FakeQuestRepository implements QuestRepository {
  FakeQuestRepository([QuestDay? seed]) : _day = seed, _synced = seed != null;

  QuestDay? _day;
  bool _synced;
  final _changes = StreamController<void>.broadcast();

  /// The saved day, if any.
  QuestDay? get saved => _day;

  @override
  Stream<QuestDay?> watch() async* {
    yield _day;
    await for (final _ in _changes.stream) {
      yield _day;
    }
  }

  @override
  Future<void> save(QuestDay day) async {
    _day = day;
    _synced = false;
    _changes.add(null);
  }

  @override
  Future<QuestDay?> unsynced() async => _synced ? null : _day;

  @override
  Future<void> markSynced(QuestDay day) async {
    if (_day == day) _synced = true;
  }

  @override
  Future<void> restore(QuestDay day) async {
    final local = _day;
    if (local != null && local.date.compareTo(day.date) >= 0) return;
    _day = day;
    _synced = true;
    _changes.add(null);
  }
}

/// In-memory [QuestRemote] for tests, keyed by uid.
class FakeQuestRemote implements QuestRemote {
  FakeQuestRemote([Map<String, QuestDay>? stored]) : stored = stored ?? {};

  final Map<String, QuestDay> stored;

  /// When set, every call fails with it.
  Exception? error;

  @override
  Future<QuestDay?> fetch(String uid) async {
    if (error case final error?) throw error;
    return stored[uid];
  }

  @override
  Future<void> put(String uid, QuestDay day) async {
    if (error case final error?) throw error;
    stored[uid] = day;
  }
}
