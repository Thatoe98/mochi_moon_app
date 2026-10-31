import 'dart:async';

import 'package:mochi_moon/features/letters/domain/future_letter.dart';
import 'package:mochi_moon/features/letters/domain/letter_repository.dart';

/// In-memory [LetterRepository] for tests.
class FakeLetterRepository implements LetterRepository {
  FakeLetterRepository([List<FutureLetter> seed = const []]) {
    for (final letter in seed) {
      _byId[letter.id] = letter;
      _synced.add(letter.id);
    }
  }

  final _byId = <String, FutureLetter>{};
  final _synced = <String>{};
  final _changes = StreamController<void>.broadcast();

  List<FutureLetter> get _soonestFirst =>
      [..._byId.values]..sort((a, b) => a.unlockAt.compareTo(b.unlockAt));

  /// The stored letters, soonest unlock first.
  List<FutureLetter> get all => _soonestFirst;

  @override
  Future<List<FutureLetter>> letters() async => _soonestFirst;

  @override
  Stream<List<FutureLetter>> watch() async* {
    yield _soonestFirst;
    await for (final _ in _changes.stream) {
      yield _soonestFirst;
    }
  }

  @override
  Future<void> add(FutureLetter letter) async {
    _byId[letter.id] = letter;
    _synced.remove(letter.id);
    _changes.add(null);
  }

  @override
  Future<void> delete(String id) async {
    _byId.remove(id);
    _synced.remove(id);
    _changes.add(null);
  }

  @override
  Future<List<FutureLetter>> unsynced() async => [
    for (final letter in _soonestFirst)
      if (!_synced.contains(letter.id)) letter,
  ];

  @override
  Future<void> markSynced(List<FutureLetter> letters) async {
    for (final sent in letters) {
      if (_byId.containsKey(sent.id)) _synced.add(sent.id);
    }
  }

  @override
  Future<void> addMissing(List<FutureLetter> letters) async {
    for (final letter in letters) {
      if (_byId.containsKey(letter.id)) continue;
      _byId[letter.id] = letter;
      _synced.add(letter.id);
    }
    _changes.add(null);
  }
}

/// In-memory [LetterRemote] for tests, keyed by uid.
class FakeLetterRemote implements LetterRemote {
  FakeLetterRemote([Map<String, List<FutureLetter>>? stored])
    : stored = stored ?? {};

  final Map<String, List<FutureLetter>> stored;

  @override
  Future<List<FutureLetter>> fetch(String uid) async => [...?stored[uid]];

  @override
  Future<void> put(String uid, FutureLetter letter) async {
    stored.putIfAbsent(uid, () => [])
      ..removeWhere((e) => e.id == letter.id)
      ..add(letter);
  }

  @override
  Future<void> delete(String uid, String id) async {
    stored[uid]?.removeWhere((e) => e.id == id);
  }
}

/// Records what would have been scheduled.
class FakeLetterNotifier implements LetterNotifier {
  Map<String, DateTime> openings = const {};
  LetterNotificationTexts? texts;
  final cancelled = <String>[];

  @override
  Future<void> schedule(
    Map<String, DateTime> openings,
    LetterNotificationTexts texts,
  ) async {
    this.openings = openings;
    this.texts = texts;
  }

  @override
  Future<void> cancel(String letterId) async => cancelled.add(letterId);
}
