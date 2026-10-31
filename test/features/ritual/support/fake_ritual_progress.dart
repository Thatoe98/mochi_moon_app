import 'package:mochi_moon/features/ritual/domain/ritual_state.dart';

/// In-memory [RitualProgressRepository] for tests.
class FakeRitualProgressRepository implements RitualProgressRepository {
  final saved = <String, SavedRitual>{};

  String _key(DateTime day) => '${day.year}-${day.month}-${day.day}';

  @override
  Future<SavedRitual?> load(DateTime day) async => saved[_key(day)];

  @override
  Future<void> save(SavedRitual ritual) async =>
      saved[_key(ritual.day)] = ritual;
}
