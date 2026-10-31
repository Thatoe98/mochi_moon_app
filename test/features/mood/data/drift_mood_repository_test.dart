import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/mood/data/drift_mood_repository.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';

DayMood _mood(int day, Mood mood) =>
    DayMood(day: DateTime(2026, 10, day), mood: mood);

void main() {
  late AppDatabase db;
  late DriftMoodRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = DriftMoodRepository(db);
  });
  tearDown(() => db.close());

  test('is empty at first', () async {
    expect(await repo.entries(), isEmpty);
  });

  test('the last choice for a day wins', () async {
    await repo.set(_mood(5, Mood.sad));
    await repo.set(_mood(5, Mood.happy));

    expect(await repo.entries(), [_mood(5, Mood.happy)]);
  });

  test('lists days oldest first', () async {
    await repo.set(_mood(9, Mood.calm));
    await repo.set(_mood(2, Mood.tired));

    expect((await repo.entries()).map((e) => e.day.day), [2, 9]);
  });

  test('watch emits again after a change', () async {
    final emissions = <int>[];
    final sub = repo.watch().listen((list) => emissions.add(list.length));
    await pumpEventQueue();
    await repo.set(_mood(1, Mood.calm));
    await pumpEventQueue();
    await sub.cancel();

    expect(emissions, [0, 1]);
  });

  test('a new day is unsynced until it is marked', () async {
    await repo.set(_mood(3, Mood.calm));
    expect(await repo.unsynced(), [_mood(3, Mood.calm)]);

    await repo.markSynced([_mood(3, Mood.calm)]);
    expect(await repo.unsynced(), isEmpty);
  });

  test('a newer choice stays unsent when an older one is marked', () async {
    await repo.set(_mood(3, Mood.calm));
    await repo.set(_mood(3, Mood.sad));

    await repo.markSynced([_mood(3, Mood.calm)]);

    expect(await repo.unsynced(), [_mood(3, Mood.sad)]);
  });

  test('addMissing never overwrites a day that has a mood', () async {
    await repo.set(_mood(4, Mood.happy));

    await repo.addMissing([_mood(4, Mood.sad), _mood(6, Mood.inLove)]);

    expect(await repo.entries(), [_mood(4, Mood.happy), _mood(6, Mood.inLove)]);
    // Restored days are already in Firestore.
    expect(await repo.unsynced(), [_mood(4, Mood.happy)]);
  });
}
