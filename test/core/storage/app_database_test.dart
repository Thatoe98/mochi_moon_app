import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/storage/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('caches a reading and replaces it on the same date/sign/lang', () async {
    Future<void> put(String json) => db
        .into(db.cachedReadings)
        .insertOnConflictUpdate(
          CachedReadingsCompanion.insert(
            date: '2026-10-27',
            sign: 'scorpio',
            lang: 'en',
            version: 1,
            json: json,
            fetchedAt: DateTime.utc(2026, 10, 27),
          ),
        );

    await put('{"v":1}');
    await put('{"v":2}');

    final rows = await db.select(db.cachedReadings).get();
    expect(rows, hasLength(1));
    expect(rows.single.json, '{"v":2}');
  });

  test('records deck history', () async {
    await db
        .into(db.deckHistory)
        .insert(
          DeckHistoryCompanion.insert(
            quoteId: 'q_0001',
            action: 'saved',
            at: DateTime.utc(2026, 10, 27),
          ),
        );
    expect(await db.select(db.deckHistory).get(), hasLength(1));
  });
}
