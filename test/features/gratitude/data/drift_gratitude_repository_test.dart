import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/gratitude/data/drift_gratitude_repository.dart';
import 'package:mochi_moon/features/gratitude/domain/gratitude.dart';

GratitudeNote _note(String id, int day, [int hour = 9]) => GratitudeNote(
  id: id,
  day: DateTime(2026, 10, day),
  body: 'Thanks $id',
  createdAt: DateTime(2026, 10, day, hour),
);

void main() {
  late AppDatabase db;
  late DriftGratitudeRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = DriftGratitudeRepository(db);
  });
  tearDown(() => db.close());

  test('starts empty', () async {
    expect(await repo.entries(), isEmpty);
  });

  test('stores entries newest first and keeps their text and day', () async {
    await repo.add(_note('a', 1));
    await repo.add(_note('b', 2));

    final entries = await repo.entries();
    expect(entries.map((e) => e.id), ['b', 'a']);
    expect(entries.first, _note('b', 2));
  });

  test('watch emits again after a change', () async {
    final seen = <int>[];
    final sub = repo.watch().listen((e) => seen.add(e.length));
    await pumpEventQueue();
    await repo.add(_note('a', 1));
    await pumpEventQueue();
    await sub.cancel();

    expect(seen, [0, 1]);
  });

  test('delete removes only that entry', () async {
    await repo.add(_note('a', 1));
    await repo.add(_note('b', 2));
    await repo.delete('a');

    expect((await repo.entries()).map((e) => e.id), ['b']);
  });

  test('new entries are unsynced until marked', () async {
    await repo.add(_note('a', 1));
    expect((await repo.unsynced()).map((e) => e.id), ['a']);

    await repo.markSynced([_note('a', 1)]);
    expect(await repo.unsynced(), isEmpty);
  });

  test('addMissing adds new ids as synced and keeps existing ones', () async {
    await repo.add(
      GratitudeNote(
        id: 'a',
        day: DateTime(2026, 10),
        body: 'local text',
        createdAt: DateTime(2026, 10, 1, 9),
      ),
    );
    await repo.addMissing([_note('a', 1), _note('b', 2)]);

    final entries = await repo.entries();
    expect(entries.map((e) => e.id), ['b', 'a']);
    expect(entries.last.body, 'local text');
    // Only the local one is still waiting to be sent.
    expect((await repo.unsynced()).map((e) => e.id), ['a']);
  });
}
