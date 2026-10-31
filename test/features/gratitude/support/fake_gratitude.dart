import 'dart:async';

import 'package:mochi_moon/features/gratitude/domain/gratitude.dart';
import 'package:mochi_moon/features/gratitude/domain/gratitude_repository.dart';

/// In-memory [GratitudeRepository] for tests.
class FakeGratitudeRepository implements GratitudeRepository {
  FakeGratitudeRepository([List<GratitudeNote> seed = const []]) {
    for (final entry in seed) {
      _byId[entry.id] = entry;
      _synced.add(entry.id);
    }
  }

  final _byId = <String, GratitudeNote>{};
  final _synced = <String>{};
  final _changes = StreamController<void>.broadcast();

  List<GratitudeNote> get _newestFirst =>
      [..._byId.values]..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  /// The stored entries, newest first.
  List<GratitudeNote> get all => _newestFirst;

  @override
  Future<List<GratitudeNote>> entries() async => _newestFirst;

  @override
  Stream<List<GratitudeNote>> watch() async* {
    yield _newestFirst;
    await for (final _ in _changes.stream) {
      yield _newestFirst;
    }
  }

  @override
  Future<void> add(GratitudeNote entry) async {
    _byId[entry.id] = entry;
    _synced.remove(entry.id);
    _changes.add(null);
  }

  @override
  Future<void> delete(String id) async {
    _byId.remove(id);
    _synced.remove(id);
    _changes.add(null);
  }

  @override
  Future<List<GratitudeNote>> unsynced() async => [
    for (final entry in _newestFirst)
      if (!_synced.contains(entry.id)) entry,
  ];

  @override
  Future<void> markSynced(List<GratitudeNote> entries) async {
    for (final sent in entries) {
      if (_byId.containsKey(sent.id)) _synced.add(sent.id);
    }
  }

  @override
  Future<void> addMissing(List<GratitudeNote> entries) async {
    for (final entry in entries) {
      if (_byId.containsKey(entry.id)) continue;
      _byId[entry.id] = entry;
      _synced.add(entry.id);
    }
    _changes.add(null);
  }
}

/// In-memory [GratitudeRemote] for tests, keyed by uid.
class FakeGratitudeRemote implements GratitudeRemote {
  FakeGratitudeRemote([Map<String, List<GratitudeNote>>? stored])
    : stored = stored ?? {};

  final Map<String, List<GratitudeNote>> stored;

  /// When set, every call fails with it.
  Exception? error;

  @override
  Future<List<GratitudeNote>> fetch(String uid) async {
    if (error case final error?) throw error;
    return [...?stored[uid]];
  }

  @override
  Future<void> put(String uid, GratitudeNote entry) async {
    if (error case final error?) throw error;
    stored.putIfAbsent(uid, () => [])
      ..removeWhere((e) => e.id == entry.id)
      ..add(entry);
  }

  @override
  Future<void> delete(String uid, String id) async {
    if (error case final error?) throw error;
    stored[uid]?.removeWhere((e) => e.id == id);
  }
}
