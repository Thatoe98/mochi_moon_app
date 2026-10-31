// The in-memory platform ships with shared_preferences' own test tooling.
// ignore_for_file: depend_on_referenced_packages

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/auth/data/drift_local_data_eraser.dart';
import 'package:mochi_moon/features/deck/data/drift_deck_repository.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  late AppDatabase db;
  late SharedPreferencesAsync prefs;
  late DriftLocalDataEraser eraser;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    db = AppDatabase(NativeDatabase.memory());
    prefs = SharedPreferencesAsync();
    eraser = DriftLocalDataEraser(db, prefs);
  });
  tearDown(() => db.close());

  test('empties the database and every saved preference', () async {
    await DriftDeckRepository(db)
        .record('q1', DeckAction.saved, DateTime(2026, 10, 29));
    await prefs.setBool('onboarding_complete', true);
    await prefs.setString('language', 'my');

    await eraser.eraseAll();

    expect(await db.select(db.deckHistory).get(), isEmpty);
    expect(await prefs.getBool('onboarding_complete'), isNull);
    expect(await prefs.getString('language'), isNull);
  });

  test('also empties the self-love tables', () async {
    final now = DateTime(2026, 10, 31);
    await db
        .into(db.moodEntries)
        .insert(MoodEntriesCompanion.insert(date: '2026-10-31', mood: 'calm'));
    await db
        .into(db.gratitudeEntries)
        .insert(
          GratitudeEntriesCompanion.insert(
            id: 'g1',
            date: '2026-10-31',
            body: 'Warm tea',
            createdAt: now,
          ),
        );
    await db
        .into(db.customCards)
        .insert(
          CustomCardsCompanion.insert(
            id: 'c1',
            body: 'I am enough',
            illustrationId: 'ill_0001',
            createdAt: now,
          ),
        );
    await db
        .into(db.ritualDays)
        .insert(
          RitualDaysCompanion.insert(date: '2026-10-31', completedAt: now),
        );
    await db
        .into(db.ritualProgress)
        .insert(
          RitualProgressCompanion.insert(
            date: '2026-10-31',
            step: 2,
            quoteIds: '[]',
          ),
        );

    await eraser.eraseAll();

    expect(await db.select(db.moodEntries).get(), isEmpty);
    expect(await db.select(db.gratitudeEntries).get(), isEmpty);
    expect(await db.select(db.customCards).get(), isEmpty);
    expect(await db.select(db.ritualDays).get(), isEmpty);
    expect(await db.select(db.ritualProgress).get(), isEmpty);
  });

  test('is fine on an already empty phone', () async {
    await expectLater(eraser.eraseAll(), completes);
  });
}
