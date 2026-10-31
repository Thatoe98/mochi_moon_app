import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/ritual/data/drift_ritual_progress_repository.dart';
import 'package:mochi_moon/features/ritual/domain/ritual_state.dart';

void main() {
  late AppDatabase db;
  late DriftRitualProgressRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = DriftRitualProgressRepository(db);
  });
  tearDown(() => db.close());

  final day = DateTime(2026, 10, 28);

  test('has nothing saved at first', () async {
    expect(await repo.load(day), isNull);
  });

  test('saves and loads the step and the cards', () async {
    await repo.save(
      SavedRitual(
        day: day,
        phase: RitualPhase.cards,
        quoteIds: const ['a', 'b', 'c'],
      ),
    );

    final loaded = await repo.load(DateTime(2026, 10, 28, 15));
    expect(loaded?.phase, RitualPhase.cards);
    expect(loaded?.quoteIds, ['a', 'b', 'c']);
    expect(loaded?.day, day);
  });

  test('saving again replaces the day, and other days are separate', () async {
    await repo.save(
      SavedRitual(day: day, phase: RitualPhase.mood, quoteIds: const ['a']),
    );
    await repo.save(
      SavedRitual(
        day: day,
        phase: RitualPhase.gratitude,
        quoteIds: const ['a'],
      ),
    );

    expect((await repo.load(day))?.phase, RitualPhase.gratitude);
    expect(await repo.load(DateTime(2026, 10, 29)), isNull);
  });
}
