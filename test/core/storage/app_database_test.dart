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

  test(
    'upgrading from version 1 adds the profile table and keeps data',
    () async {
      final v1 = AppDatabase(
        NativeDatabase.memory(
          setup: (raw) {
            raw
              ..execute(
                'CREATE TABLE deck_history (id INTEGER PRIMARY KEY AUTOINCREMENT, '
                'quote_id TEXT NOT NULL, action TEXT NOT NULL, at INTEGER NOT NULL)',
              )
              ..execute(
                'INSERT INTO deck_history (quote_id, action, at) '
                "VALUES ('q_0001', 'saved', 1792000000)",
              )
              ..execute('PRAGMA user_version = 1');
          },
        ),
      );
      addTearDown(v1.close);

      await v1
          .into(v1.profileCache)
          .insert(
            ProfileCacheCompanion.insert(
              json: '{"displayName":"Mochi"}',
              updatedAt: DateTime.utc(2026, 10, 28),
            ),
          );

      expect(await v1.select(v1.profileCache).get(), hasLength(1));
      final history = await v1.select(v1.deckHistory).get();
      expect(history.single.quoteId, 'q_0001');
    },
  );

  test('upgrading from version 3 adds the self-love tables and keeps data', () async {
    final v3 = AppDatabase(
      NativeDatabase.memory(
        setup: (raw) {
          raw
            ..execute(
              'CREATE TABLE journal_cache (quote_id TEXT NOT NULL PRIMARY KEY, '
              'saved_at INTEGER NOT NULL)',
            )
            ..execute(
              "INSERT INTO journal_cache (quote_id, saved_at) VALUES ('q_0001', 1792000000)",
            )
            ..execute(
              'CREATE TABLE profile_cache (id INTEGER NOT NULL PRIMARY KEY, '
              'json TEXT NOT NULL, updated_at INTEGER NOT NULL)',
            )
            ..execute(
              'INSERT INTO profile_cache (id, json, updated_at) '
              '''VALUES (0, '{"displayName":"Mochi"}', 1792000000)''',
            )
            ..execute('PRAGMA user_version = 3');
        },
      ),
    );
    addTearDown(v3.close);

    expect((await v3.select(v3.journalCache).get()).single.quoteId, 'q_0001');
    expect(
      (await v3.select(v3.profileCache).get()).single.json,
      '{"displayName":"Mochi"}',
    );

    await v3
        .into(v3.moodEntries)
        .insert(MoodEntriesCompanion.insert(date: '2026-10-31', mood: 'calm'));
    await v3
        .into(v3.gratitudeEntries)
        .insert(
          GratitudeEntriesCompanion.insert(
            id: 'g1',
            date: '2026-10-31',
            body: 'Warm tea',
            createdAt: DateTime.utc(2026, 10, 31),
          ),
        );
    await v3
        .into(v3.customCards)
        .insert(
          CustomCardsCompanion.insert(
            id: 'c1',
            body: 'I am enough',
            illustrationId: 'ill_0001',
            createdAt: DateTime.utc(2026, 10, 31),
          ),
        );
    await v3
        .into(v3.ritualDays)
        .insert(
          RitualDaysCompanion.insert(
            date: '2026-10-31',
            completedAt: DateTime.utc(2026, 10, 31),
          ),
        );
    await v3
        .into(v3.ritualProgress)
        .insert(
          RitualProgressCompanion.insert(
            date: '2026-10-31',
            step: 1,
            quoteIds: '["q1","q2","q3"]',
          ),
        );

    expect((await v3.select(v3.moodEntries).get()).single.synced, isFalse);
    expect(await v3.select(v3.gratitudeEntries).get(), hasLength(1));
    expect(await v3.select(v3.customCards).get(), hasLength(1));
    expect(await v3.select(v3.ritualDays).get(), hasLength(1));
    expect(await v3.select(v3.ritualProgress).get(), hasLength(1));
  });
}
