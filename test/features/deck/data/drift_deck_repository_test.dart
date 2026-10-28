import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/deck/data/drift_deck_repository.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';

void main() {
  late AppDatabase db;
  late DriftDeckRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = DriftDeckRepository(db);
  });
  tearDown(() => db.close());

  Future<int> journalCount() async =>
      (await db.select(db.journalCache).get()).length;

  test('history is empty at first', () async {
    expect(await repo.history(), isEmpty);
  });

  test('watchHistory emits the history again after each change', () async {
    final seen = <int>[];
    final sub = repo.watchHistory().listen((events) => seen.add(events.length));
    addTearDown(sub.cancel);

    await pumpEventQueue();
    final event = await repo.record('q1', DeckAction.skipped, DateTime(2026));
    await pumpEventQueue();
    await repo.undo(event);
    await pumpEventQueue();

    expect(seen.first, 0);
    expect(seen, contains(1));
    expect(seen.last, 0);
  });

  test('record returns the stored event and history is oldest first', () async {
    final later = await repo.record(
      'q2',
      DeckAction.skipped,
      DateTime(2026, 10, 28),
    );
    final earlier = await repo.record(
      'q1',
      DeckAction.shared,
      DateTime(2026, 10, 27),
    );

    expect(later.quoteId, 'q2');
    expect(later.action, DeckAction.skipped);
    final history = await repo.history();
    expect(history.map((e) => e.id), [earlier.id, later.id]);
    expect(history.first.action, DeckAction.shared);
  });

  test('only saved cards reach the journal', () async {
    await repo.record('q1', DeckAction.skipped, DateTime(2026, 10, 28));
    await repo.record('q2', DeckAction.shared, DateTime(2026, 10, 28));
    expect(await journalCount(), 0);

    await repo.record('q3', DeckAction.saved, DateTime(2026, 10, 28));
    final journal = await db.select(db.journalCache).get();
    expect(journal.single.quoteId, 'q3');
  });

  test('undo removes the event and its journal entry', () async {
    final event = await repo.record(
      'q1',
      DeckAction.saved,
      DateTime(2026, 10, 28),
    );

    await repo.undo(event);

    expect(await repo.history(), isEmpty);
    expect(await journalCount(), 0);
  });

  test('undoing a skip leaves the journal alone', () async {
    await repo.record('q1', DeckAction.saved, DateTime(2026, 10, 27));
    final skip = await repo.record(
      'q1',
      DeckAction.skipped,
      DateTime(2026, 10, 28),
    );

    await repo.undo(skip);

    expect(await journalCount(), 1);
    expect(await repo.history(), hasLength(1));
  });

  test(
    'undo keeps the journal entry when the card was saved earlier too',
    () async {
      await repo.record('q1', DeckAction.saved, DateTime(2026, 10, 20));
      final again = await repo.record(
        'q1',
        DeckAction.saved,
        DateTime(2026, 10, 28),
      );

      await repo.undo(again);

      expect(await journalCount(), 1);
      expect(await repo.history(), hasLength(1));
    },
  );
}
