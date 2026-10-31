import 'dart:async';

import 'package:mochi_moon/features/mood/domain/mood.dart';
import 'package:mochi_moon/features/mood/domain/mood_repository.dart';

/// In-memory [MoodRepository] for tests.
class FakeMoodRepository implements MoodRepository {
  FakeMoodRepository([List<DayMood> seed = const []]) {
    for (final entry in seed) {
      _byDay[moodDateKey(entry.day)] = entry;
      _synced.add(moodDateKey(entry.day));
    }
  }

  final _byDay = <String, DayMood>{};
  final _synced = <String>{};
  final _changes = StreamController<void>.broadcast();

  List<DayMood> get _sorted =>
      [..._byDay.values]..sort((a, b) => a.day.compareTo(b.day));

  /// The mood stored for [day], if any.
  Mood? moodOf(DateTime day) => _byDay[moodDateKey(day)]?.mood;

  @override
  Future<List<DayMood>> entries() async => _sorted;

  @override
  Stream<List<DayMood>> watch() async* {
    yield _sorted;
    await for (final _ in _changes.stream) {
      yield _sorted;
    }
  }

  @override
  Future<void> set(DayMood mood) async {
    final key = moodDateKey(mood.day);
    _byDay[key] = mood;
    _synced.remove(key);
    _changes.add(null);
  }

  @override
  Future<List<DayMood>> unsynced() async => [
    for (final entry in _sorted)
      if (!_synced.contains(moodDateKey(entry.day))) entry,
  ];

  @override
  Future<void> markSynced(List<DayMood> moods) async {
    for (final sent in moods) {
      final key = moodDateKey(sent.day);
      if (_byDay[key] == sent) _synced.add(key);
    }
  }

  @override
  Future<void> addMissing(List<DayMood> moods) async {
    for (final entry in moods) {
      final key = moodDateKey(entry.day);
      if (_byDay.containsKey(key)) continue;
      _byDay[key] = entry;
      _synced.add(key);
    }
    _changes.add(null);
  }
}

/// In-memory [MoodRemote] for tests, keyed by uid.
class FakeMoodRemote implements MoodRemote {
  FakeMoodRemote([Map<String, List<DayMood>>? stored]) : stored = stored ?? {};

  final Map<String, List<DayMood>> stored;

  /// When set, every call fails with it.
  Exception? error;

  @override
  Future<List<DayMood>> fetch(String uid) async {
    if (error case final error?) throw error;
    return [...?stored[uid]];
  }

  @override
  Future<void> put(String uid, DayMood mood) async {
    if (error case final error?) throw error;
    stored.putIfAbsent(uid, () => [])
      ..removeWhere((e) => moodDateKey(e.day) == moodDateKey(mood.day))
      ..add(mood);
  }
}
