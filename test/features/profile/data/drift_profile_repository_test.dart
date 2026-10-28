import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/profile/data/drift_profile_repository.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';

void main() {
  late AppDatabase db;
  late DriftProfileRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = DriftProfileRepository(db, () => DateTime.utc(2026, 10, 28));
  });
  tearDown(() => db.close());

  final profile = UserProfile(
    displayName: 'Mochi',
    birthDate: DateTime(1998, 2, 4),
    focusAreas: const [FocusArea.calm],
  );

  test('has no profile at first', () async {
    expect(await repository.load(), isNull);
  });

  test('saves and loads a profile, and a second save replaces it', () async {
    await repository.save(profile);
    expect(await repository.load(), profile);

    final renamed = profile.copyWith(displayName: 'Luna');
    await repository.save(renamed);

    expect(await repository.load(), renamed);
    expect(await db.select(db.profileCache).get(), hasLength(1));
  });

  test('clear forgets the profile', () async {
    await repository.save(profile);
    await repository.clear();
    expect(await repository.load(), isNull);
  });

  test('a damaged row reads as no profile', () async {
    await db
        .into(db.profileCache)
        .insert(
          ProfileCacheCompanion.insert(
            id: const Value(0),
            json: '{not json',
            updatedAt: DateTime.utc(2026),
          ),
        );

    expect(await repository.load(), isNull);
  });
}
