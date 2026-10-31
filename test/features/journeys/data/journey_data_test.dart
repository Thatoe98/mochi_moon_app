import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/journeys/data/drift_journey_repository.dart';
import 'package:mochi_moon/features/journeys/data/firestore_journey_remote.dart';
import 'package:mochi_moon/features/journeys/domain/journey_progress.dart';

final _started = DateTime(2026, 11, 2, 8);

JourneyProgress _run({
  String id = 'confidence',
  List<int> done = const [],
  Map<int, String> notes = const {},
  String? lastDoneOn,
}) => JourneyProgress(
  journeyId: id,
  startedAt: _started,
  currentDay: done.length + 1,
  completedDays: done,
  reflections: notes,
  lastDoneOn: lastDoneOn,
);

void main() {
  late AppDatabase db;
  late DriftJourneyRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = DriftJourneyRepository(db);
  });
  tearDown(() => db.close());

  test('is empty at first', () async {
    expect(await repo.watchAll().first, isEmpty);
    expect(await repo.unsynced(), isEmpty);
  });

  test('saves and reads back days, notes and dates', () async {
    final run = _run(
      done: [1, 2],
      notes: {1: 'first', 2: 'second'},
      lastDoneOn: '2026-11-03',
    );
    await repo.save(run);
    await repo.save(_run(id: 'calm'));

    final all = await repo.watchAll().first;
    expect(all, hasLength(2));
    expect(all.firstWhere((p) => p.journeyId == 'confidence'), run);
  });

  test(
    'a saved record is unsynced until marked, and a newer save stays',
    () async {
      final first = _run(done: [1]);
      await repo.save(first);
      expect(await repo.unsynced(), [first]);

      final second = _run(done: [1, 2]);
      await repo.save(second);
      await repo.markSynced(first);
      expect(await repo.unsynced(), [second]);

      await repo.markSynced(second);
      expect(await repo.unsynced(), isEmpty);
    },
  );

  test('restore fills a gap and only moves progress forward', () async {
    await repo.restore(_run(done: [1, 2]));
    expect((await repo.watchAll().first).single.completedDays, [1, 2]);
    expect(await repo.unsynced(), isEmpty);

    await repo.restore(_run(done: [1]));
    expect((await repo.watchAll().first).single.completedDays, [1, 2]);

    await repo.restore(_run(done: [1, 2, 3], notes: {3: 'x'}));
    expect((await repo.watchAll().first).single.completedDays, [1, 2, 3]);
  });

  test('restore keeps the date of the last finished day', () async {
    await repo.save(_run(done: [1], lastDoneOn: '2026-11-03'));
    await repo.restore(_run(done: [1, 2]));

    final saved = (await repo.watchAll().first).single;
    expect(saved.completedDays, [1, 2]);
    expect(saved.lastDoneOn, '2026-11-03');
  });

  test('the Firestore map has exactly the fields the rules allow', () {
    final run = _run(done: [1, 2], notes: {2: 'note'});
    final map = journeyProgressToMap(run);

    expect(
      map.keys,
      unorderedEquals([
        'startedAt',
        'currentDay',
        'completedDays',
        'reflections',
        'completedAt',
      ]),
    );
    expect(map['startedAt'], isA<Timestamp>());
    expect(map['completedAt'], isNull);
    expect(map['reflections'], {'2': 'note'});

    final back = journeyProgressFromMap('confidence', map.cast());
    expect(back?.completedDays, [1, 2]);
    expect(back?.reflections, {2: 'note'});
    expect(back?.currentDay, 3);
    expect(back?.startedAt, _started);
  });

  test('a document with a missing or wrong field is ignored', () {
    final good = journeyProgressToMap(_run());
    expect(journeyProgressFromMap('x', {...good}..remove('startedAt')), isNull);
    expect(journeyProgressFromMap('x', {...good, 'currentDay': '1'}), isNull);
    expect(
      journeyProgressFromMap('x', {
        ...good,
        'completedDays': ['1'],
      }),
      isNull,
    );
    expect(journeyProgressFromMap('x', {...good, 'completedAt': 5}), isNull);
  });
}
