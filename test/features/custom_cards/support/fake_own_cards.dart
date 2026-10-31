import 'dart:async';

import 'package:mochi_moon/features/custom_cards/domain/own_card.dart';
import 'package:mochi_moon/features/custom_cards/domain/own_card_repository.dart';

/// In-memory [OwnCardRepository] for tests.
class FakeOwnCardRepository implements OwnCardRepository {
  FakeOwnCardRepository([List<OwnCard> seed = const []]) {
    for (final card in seed) {
      _byId[card.id] = card;
      _synced.add(card.id);
    }
  }

  final _byId = <String, OwnCard>{};
  final _synced = <String>{};
  final _changes = StreamController<void>.broadcast();

  List<OwnCard> get _newestFirst =>
      [..._byId.values]..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  /// The stored cards, newest first.
  List<OwnCard> get all => _newestFirst;

  @override
  Future<List<OwnCard>> cards() async => _newestFirst;

  @override
  Stream<List<OwnCard>> watch() async* {
    yield _newestFirst;
    await for (final _ in _changes.stream) {
      yield _newestFirst;
    }
  }

  @override
  Future<void> save(OwnCard card) async {
    _byId[card.id] = card;
    _synced.remove(card.id);
    _changes.add(null);
  }

  @override
  Future<void> delete(String id) async {
    _byId.remove(id);
    _synced.remove(id);
    _changes.add(null);
  }

  @override
  Future<List<OwnCard>> unsynced() async => [
    for (final card in _newestFirst)
      if (!_synced.contains(card.id)) card,
  ];

  @override
  Future<void> markSynced(List<OwnCard> cards) async {
    for (final sent in cards) {
      if (_byId[sent.id] == sent) _synced.add(sent.id);
    }
  }

  @override
  Future<void> addMissing(List<OwnCard> cards) async {
    for (final card in cards) {
      if (_byId.containsKey(card.id)) continue;
      _byId[card.id] = card;
      _synced.add(card.id);
    }
    _changes.add(null);
  }
}

/// In-memory [OwnCardRemote] for tests, keyed by uid.
class FakeOwnCardRemote implements OwnCardRemote {
  FakeOwnCardRemote([Map<String, List<OwnCard>>? stored])
    : stored = stored ?? {};

  final Map<String, List<OwnCard>> stored;

  /// When set, every call fails with it.
  Exception? error;

  @override
  Future<List<OwnCard>> fetch(String uid) async {
    if (error case final error?) throw error;
    return [...?stored[uid]];
  }

  @override
  Future<void> put(String uid, OwnCard card) async {
    if (error case final error?) throw error;
    stored.putIfAbsent(uid, () => [])
      ..removeWhere((c) => c.id == card.id)
      ..add(card);
  }

  @override
  Future<void> delete(String uid, String id) async {
    if (error case final error?) throw error;
    stored[uid]?.removeWhere((c) => c.id == id);
  }
}
