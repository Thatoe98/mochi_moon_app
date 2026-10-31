import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/custom_cards/data/drift_own_card_repository.dart';
import 'package:mochi_moon/features/custom_cards/domain/own_card.dart';

OwnCard _card(String id, int day, [String body = 'Hello']) => OwnCard(
  id: id,
  body: '$body $id',
  illustrationId: 'moon_01',
  createdAt: DateTime(2026, 10, day),
);

void main() {
  late AppDatabase db;
  late DriftOwnCardRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = DriftOwnCardRepository(db);
  });
  tearDown(() => db.close());

  test('starts empty', () async {
    expect(await repo.cards(), isEmpty);
  });

  test('stores cards newest first', () async {
    await repo.save(_card('a', 1));
    await repo.save(_card('b', 2));

    expect(await repo.cards(), [_card('b', 2), _card('a', 1)]);
  });

  test('saving again edits in place and marks it unsent', () async {
    await repo.save(_card('a', 1));
    await repo.markSynced([_card('a', 1)]);
    expect(await repo.unsynced(), isEmpty);

    final edited = _card('a', 1).copyWith(body: 'New words');
    await repo.save(edited);

    expect(await repo.cards(), [edited]);
    expect(await repo.unsynced(), [edited]);
  });

  test('delete removes the card', () async {
    await repo.save(_card('a', 1));
    await repo.delete('a');

    expect(await repo.cards(), isEmpty);
  });

  test('markSynced skips a card that was edited meanwhile', () async {
    final sent = _card('a', 1);
    await repo.save(sent);
    await repo.save(sent.copyWith(body: 'Changed'));

    await repo.markSynced([sent]);

    expect(await repo.unsynced(), hasLength(1));
  });

  test('addMissing keeps a card that is already here', () async {
    await repo.save(_card('a', 1));
    await repo.addMissing([_card('a', 1, 'Other'), _card('b', 2)]);

    final cards = await repo.cards();
    expect(cards.map((c) => c.id), ['b', 'a']);
    expect(cards.last.body, 'Hello a');
    // Restored cards are already in Firestore.
    expect((await repo.unsynced()).map((c) => c.id), ['a']);
  });

  test('watch emits again after a change', () async {
    final seen = <int>[];
    final sub = repo.watch().listen((cards) => seen.add(cards.length));
    await pumpEventQueue();
    await repo.save(_card('a', 1));
    await pumpEventQueue();
    await sub.cancel();

    expect(seen, containsAllInOrder([0, 1]));
  });
}
