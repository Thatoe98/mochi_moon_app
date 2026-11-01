import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/mascot_item.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/mascot/data/drift_mascot_repository.dart';
import 'package:mochi_moon/features/mascot/data/firestore_mascot_remote.dart';
import 'package:mochi_moon/features/mascot/domain/mascot_state.dart';

final _t0 = DateTime.utc(2026, 11);
final _t1 = DateTime.utc(2026, 11, 2);

void main() {
  late AppDatabase db;
  late DriftMascotRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = DriftMascotRepository(db);
  });
  tearDown(() => db.close());

  test('is empty at first', () async {
    expect(await repo.watch().first, const MascotState());
  });

  test('grant keeps the first earned time and never duplicates', () async {
    await repo.grant(['a', 'b'], _t0);
    await repo.grant(['b', 'c'], _t1);

    final state = await repo.watch().first;
    expect(state.owned.toSet(), {'a', 'b', 'c'});
    expect(state.owned, hasLength(3));
    final rows = await db.select(db.mascotInventory).get();
    expect(
      rows.firstWhere((r) => r.itemId == 'b').earnedAt.isAtSameMomentAs(_t0),
      isTrue,
    );
  });

  test('one item per slot: equipping replaces, unequip clears', () async {
    await repo.grant(['a', 'b'], _t0);
    await repo.equip('outfit', 'a');
    await repo.equip('outfit', 'b');
    expect((await repo.watch().first).equipped, {'outfit': 'b'});

    await repo.unequip('outfit');
    final state = await repo.watch().first;
    expect(state.equipped, isEmpty);
    expect(state.owned, hasLength(2));
  });

  test('restore adds items and fills only empty slots', () async {
    await repo.grant(['a'], _t0);
    await repo.equip('outfit', 'a');

    await repo.restore(
      const MascotState(
        owned: ['b', 'c', 'a'],
        equipped: {'outfit': 'b', 'shelf': 'c'},
      ),
      _t1,
    );

    final state = await repo.watch().first;
    expect(state.owned.toSet(), {'a', 'b', 'c'});
    expect(state.equipped, {'outfit': 'a', 'shelf': 'c'});
  });

  test('restore ignores an equipped item that is not owned', () async {
    await repo.restore(
      const MascotState(owned: ['a'], equipped: {'outfit': 'zzz'}),
      _t1,
    );
    expect((await repo.watch().first).equipped, isEmpty);
  });

  group('Firestore mapping', () {
    test('writes exactly the fields the rules allow', () {
      final map = mascotStateToMap(
        const MascotState(
          owned: ['a', 'b'],
          equipped: {'outfit': 'a', 'shelf': 'b'},
        ),
        updatedAt: 'now',
      );
      expect(map.keys.toSet(), {'owned', 'equipped', 'updatedAt'});
      expect(map['equipped'], {
        'outfit': 'a',
        'room': {'shelf': 'b'},
      });
    });

    test('round-trips and rejects wrong types', () {
      const state = MascotState(
        owned: ['a', 'b'],
        equipped: {'outfit': 'a', 'shelf': 'b'},
      );
      expect(mascotStateFromMap(mascotStateToMap(state, updatedAt: 1)), state);
      expect(
        mascotStateFromMap({'owned': 'x', 'equipped': <String, Object?>{}}),
        isNull,
      );
      expect(
        mascotStateFromMap({
          'owned': [1],
          'equipped': <String, Object?>{},
        }),
        isNull,
      );
      expect(
        mascotStateFromMap({
          'owned': <String>[],
          'equipped': {'outfit': null},
        }),
        const MascotState(),
      );
    });
  });

  test('bundled items are well formed', () {
    final json = jsonDecode(
      File('assets/content/mascot/mascot_items.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final items = [
      for (final e in json['items'] as List<dynamic>)
        MascotItem.fromJson(e as Map<String, dynamic>),
    ];
    expect(items.map((i) => i.id).toSet(), hasLength(items.length));
    for (final item in items) {
      expect(item.nameFor('en'), isNotEmpty, reason: item.id);
      expect(item.illustrationId, startsWith('ill_mascot_'), reason: item.id);
      expect(['streak', 'journey'], contains(item.unlock.type));
      if (item.unlock.type == 'streak') {
        expect([3, 7, 14, 30, 60, 100], contains(item.unlock.value));
      }
    }
  });
}
