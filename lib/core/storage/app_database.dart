import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:mochi_moon/core/storage/tables.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    CachedReadings,
    CachedReports,
    DeckHistory,
    JournalCache,
    RetroCalendar,
    PreferenceVector,
    ProfileCache,
    PartnerCache,
    MoodEntries,
    GratitudeEntries,
    CustomCards,
    RitualDays,
    RitualProgress,
    QuestStates,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'mochi_moon'));

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createTable(profileCache);
      if (from < 3) await m.createTable(partnerCache);
      if (from < 4) {
        await m.createTable(moodEntries);
        await m.createTable(gratitudeEntries);
        await m.createTable(customCards);
        await m.createTable(ritualDays);
        await m.createTable(ritualProgress);
      }
      if (from < 5) await m.createTable(questStates);
    },
  );
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
