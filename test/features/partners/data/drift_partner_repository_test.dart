import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/partners/data/drift_partner_repository.dart';

import '../support/fake_partners.dart';

void main() {
  late AppDatabase db;
  late DriftPartnerRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = DriftPartnerRepository(db);
  });
  tearDown(() => db.close());

  test('is empty at first', () async {
    expect(await repository.partners(), isEmpty);
  });

  test('saves partners and lists the oldest first', () async {
    await repository.save(
      partner('b', day: 5, birthPlace: bangkok, birthMinutes: 90),
    );
    await repository.save(partner('a', day: 2));

    final list = await repository.partners();
    expect(list.map((p) => p.id), ['a', 'b']);
    expect(list.last.birthPlace, bangkok);
    expect(list.last.birthMinutes, 90);
  });

  test('saving the same id edits the partner', () async {
    await repository.save(partner('a'));
    await repository.save(partner('a', nickname: 'Sol'));

    final list = await repository.partners();
    expect(list, hasLength(1));
    expect(list.single.nickname, 'Sol');
  });

  test('removes one partner and leaves the others', () async {
    await repository.save(partner('a'));
    await repository.save(partner('b', day: 2));
    await repository.remove('a');

    expect((await repository.partners()).map((p) => p.id), ['b']);
  });

  test('addMissing keeps the partners already here as they are', () async {
    await repository.save(partner('a', nickname: 'Mine'));
    await repository.addMissing([
      partner('a', nickname: 'Theirs'),
      partner('c', day: 3),
    ]);

    final list = await repository.partners();
    expect(list.map((p) => p.id), ['a', 'c']);
    expect(list.first.nickname, 'Mine');
  });

  test('watch emits again after each change', () async {
    final emissions = <List<String>>[];
    final sub = repository.watch().listen(
      (list) => emissions.add([for (final p in list) p.id]),
    );
    addTearDown(sub.cancel);

    await pumpEventQueue();
    await repository.save(partner('a'));
    await pumpEventQueue();
    await repository.remove('a');
    await pumpEventQueue();

    expect(
      emissions,
      containsAllInOrder([
        <String>[],
        ['a'],
        <String>[],
      ]),
    );
  });

  test('skips a row that no longer reads as a partner', () async {
    await repository.save(partner('a'));
    await db
        .into(db.partnerCache)
        .insert(
          PartnerCacheCompanion.insert(
            id: 'bad',
            json: 'not json',
            createdAt: DateTime(2026, 10, 9),
          ),
        );

    expect((await repository.partners()).map((p) => p.id), ['a']);
  });
}
