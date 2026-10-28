import 'dart:async';

import 'package:mochi_moon/features/journal/domain/journal_repository.dart';

/// In-memory [JournalRepository] for tests.
class FakeJournalRepository implements JournalRepository {
  FakeJournalRepository([List<JournalEntry> seed = const []])
    : saved = [...seed];

  final List<JournalEntry> saved;
  final _changes = StreamController<void>.broadcast();

  List<JournalEntry> get _newestFirst => [
    ...saved..sort((a, b) => b.savedAt.compareTo(a.savedAt)),
  ];

  @override
  Future<List<JournalEntry>> entries() async => _newestFirst;

  @override
  Stream<List<JournalEntry>> watch() async* {
    yield _newestFirst;
    await for (final _ in _changes.stream) {
      yield _newestFirst;
    }
  }

  @override
  Future<void> remove(String quoteId) async {
    saved.removeWhere((e) => e.quoteId == quoteId);
    _changes.add(null);
  }

  @override
  Future<void> addMissing(List<JournalEntry> entries) async {
    for (final entry in entries) {
      if (saved.every((e) => e.quoteId != entry.quoteId)) saved.add(entry);
    }
    _changes.add(null);
  }

  /// Saves a card, as the deck does on a right swipe.
  void save(JournalEntry entry) {
    saved
      ..removeWhere((e) => e.quoteId == entry.quoteId)
      ..add(entry);
    _changes.add(null);
  }
}

/// In-memory [JournalRemote] for tests, keyed by uid.
class FakeJournalRemote implements JournalRemote {
  FakeJournalRemote([Map<String, List<JournalEntry>>? stored])
    : stored = stored ?? {};

  final Map<String, List<JournalEntry>> stored;

  /// When set, every call fails with it.
  Exception? error;

  List<String> idsOf(String uid) => [
    for (final entry in stored[uid] ?? const <JournalEntry>[]) entry.quoteId,
  ];

  @override
  Future<List<JournalEntry>> fetch(String uid) async {
    if (error case final error?) throw error;
    return [...?stored[uid]];
  }

  @override
  Future<void> put(String uid, JournalEntry entry) async {
    if (error case final error?) throw error;
    stored.putIfAbsent(uid, () => [])
      ..removeWhere((e) => e.quoteId == entry.quoteId)
      ..add(entry);
  }

  @override
  Future<void> delete(String uid, String quoteId) async {
    if (error case final error?) throw error;
    stored[uid]?.removeWhere((e) => e.quoteId == quoteId);
  }
}
