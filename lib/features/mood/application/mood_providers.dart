import 'package:flutter/foundation.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/mood/data/drift_mood_repository.dart';
import 'package:mochi_moon/features/mood/data/firestore_mood_remote.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';
import 'package:mochi_moon/features/mood/domain/mood_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mood_providers.g.dart';

@Riverpod(keepAlive: true)
MoodRepository moodRepository(Ref ref) =>
    DriftMoodRepository(ref.watch(appDatabaseProvider));

/// The Firestore copy, or null when Firebase did not start.
@Riverpod(keepAlive: true)
MoodRemote? moodRemote(Ref ref) =>
    ref.watch(firebaseReadyProvider) ? FirestoreMoodRemote() : null;

/// Every day with a mood, oldest first.
@riverpod
Stream<List<DayMood>> dayMoods(Ref ref) =>
    ref.watch(moodRepositoryProvider).watch();

/// Today's mood, or null until she picks one.
@riverpod
Mood? todayMood(Ref ref) {
  final key = moodDateKey(ref.watch(clockProvider)());
  for (final entry in ref.watch(dayMoodsProvider).value ?? const <DayMood>[]) {
    if (moodDateKey(entry.day) == key) return entry.mood;
  }
  return null;
}

/// Stores the given mood as today's mood; the last choice of the day wins.
@riverpod
Future<void> Function(Mood mood) setTodayMood(Ref ref) =>
    (mood) => ref
        .read(moodRepositoryProvider)
        .set(DayMood(day: ref.read(clockProvider)(), mood: mood));

/// Keeps the moods in Firestore in step with the device while someone is
/// signed in. The device wins: days only Firestore has are added here, and
/// days changed here are sent. A failed upload is tried again with the next
/// change. Watched from the app root.
@Riverpod(keepAlive: true)
Future<void> moodSync(Ref ref) async {
  final user = await ref.watch(authUserProvider.future);
  final remote = ref.watch(moodRemoteProvider);
  if (user == null || remote == null) return;
  final uid = user.uid;
  final repository = ref.watch(moodRepositoryProvider);

  try {
    await repository.addMissing(await remote.fetch(uid));
  } on AppFailure catch (error) {
    debugPrint('Could not read the moods from Firestore: $error');
  }

  var busy = false;
  var again = false;
  Future<void> push() async {
    // One pass at a time; a change that arrives meanwhile is sent by the
    // pass that follows.
    if (busy) {
      again = true;
      return;
    }
    busy = true;
    try {
      do {
        again = false;
        for (final mood in await repository.unsynced()) {
          try {
            await remote.put(uid, mood);
            await repository.markSynced([mood]);
          } on AppFailure catch (error) {
            debugPrint('Could not save a mood to Firestore: $error');
          }
        }
      } while (again);
    } finally {
      busy = false;
    }
  }

  final subscription = repository.watch().listen((_) => push());
  ref.onDispose(subscription.cancel);
}
