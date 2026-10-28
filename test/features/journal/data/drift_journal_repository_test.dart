import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/deck/data/drift_deck_repository.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/journal/data/drift_journal_repository.dart';

void main() {
  late AppDatabase db;
  late DriftJournalRepository journal;
  late DriftDeckRepository deck;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    journal = DriftJournalRepository(db);
    deck = DriftDeckRepository(db);
  });
  tearDown(() => db.close());

  test('is empty at first', () async {
    expect(await journal.entries(), isEmpty);
  });

  test('lists cards saved from the deck, newest first', () async {
    await deck.record('q1', DeckAction.saved, DateTime(2026, 10, 26));
    await deck.record('q2', DeckAction.saved, DateTime(2026, 10, 28));
    await deck.record('q3', DeckAction.skipped, DateTime(2026, 10, 29));

    final entries = await journal.entries();

    expect(entries.map((e) => e.quoteId), ['q2', 'q1']);
    expect(entries.first.savedAt, DateTime(2026, 10, 28));
  });

  test('remove drops the card but keeps the deck history', () async {
    await deck.record('q1', DeckAction.saved, DateTime(2026, 10, 26));
    await deck.record('q2', DeckAction.saved, DateTime(2026, 10, 27));

    await journal.remove('q1');

    expect((await journal.entries()).map((e) => e.quoteId), ['q2']);
    expect(await deck.history(), hasLength(2));
  });

  test('removing a card that is not saved does nothing', () async {
    await deck.record('q1', DeckAction.saved, DateTime(2026, 10, 26));

    await journal.remove('missing');

    expect(await journal.entries(), hasLength(1));
  });

  test('saving a removed card again brings it back', () async {
    await deck.record('q1', DeckAction.saved, DateTime(2026, 10, 26));
    await journal.remove('q1');

    await deck.record('q1', DeckAction.saved, DateTime(2026, 10, 28));

    final entries = await journal.entries();
    expect(entries.single.savedAt, DateTime(2026, 10, 28));
  });
}
