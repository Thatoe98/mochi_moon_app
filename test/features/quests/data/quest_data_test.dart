import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/quests/data/drift_quest_repository.dart';
import 'package:mochi_moon/features/quests/data/firestore_quest_remote.dart';
import 'package:mochi_moon/features/quests/domain/quest_day.dart';

const _monday = QuestDay(date: '2026-11-02', questId: 'qst_001');
const _tuesday = QuestDay(date: '2026-11-03', questId: 'qst_002');

void main() {
  late AppDatabase db;
  late DriftQuestRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = DriftQuestRepository(db);
  });
  tearDown(() => db.close());

  test('is empty at first', () async {
    expect(await repo.watch().first, isNull);
    expect(await repo.unsynced(), isNull);
  });

  test('keeps only the latest saved day', () async {
    await repo.save(_monday);
    await repo.save(_tuesday);

    expect(await repo.watch().first, _tuesday);
    expect(await db.select(db.questStates).get(), hasLength(1));
  });

  test(
    'a saved day is unsynced until marked, and a newer save stays',
    () async {
      await repo.save(_monday);
      expect(await repo.unsynced(), _monday);

      final done = _monday.copyWith(done: true);
      await repo.save(done);
      await repo.markSynced(_monday);
      expect(await repo.unsynced(), done);

      await repo.markSynced(done);
      expect(await repo.unsynced(), isNull);
    },
  );

  test(
    'restore fills an empty device and replaces an older day only',
    () async {
      await repo.restore(_monday);
      expect(await repo.watch().first, _monday);
      expect(await repo.unsynced(), isNull);

      await repo.restore(_tuesday);
      expect(await repo.watch().first, _tuesday);

      await repo.restore(_monday);
      expect(await repo.watch().first, _tuesday);
    },
  );

  test('the Firestore map has exactly the fields the rules allow', () {
    const day = QuestDay(
      date: '2026-11-02',
      questId: 'qst_004',
      done: true,
      swapped: true,
    );
    final map = questDayToMap(day);

    expect(map.keys, unorderedEquals(['date', 'questId', 'done', 'swapped']));
    expect(questDayFromMap(map), day);
  });

  test('a document with a missing or wrong field is ignored', () {
    expect(questDayFromMap({'date': '2026-11-02'}), isNull);
    expect(
      questDayFromMap({
        'date': '2026-11-02',
        'questId': 'q',
        'done': 'yes',
        'swapped': false,
      }),
      isNull,
    );
  });
}
