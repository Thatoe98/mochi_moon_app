import 'package:flutter/foundation.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quest.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';
import 'package:mochi_moon/features/quests/data/drift_quest_repository.dart';
import 'package:mochi_moon/features/quests/data/firestore_quest_remote.dart';
import 'package:mochi_moon/features/quests/domain/daily_quest.dart';
import 'package:mochi_moon/features/quests/domain/quest_day.dart';
import 'package:mochi_moon/features/quests/domain/quest_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quest_providers.g.dart';

@Riverpod(keepAlive: true)
QuestRepository questRepository(Ref ref) =>
    DriftQuestRepository(ref.watch(appDatabaseProvider));

/// The Firestore copy, or null when Firebase did not start.
@Riverpod(keepAlive: true)
QuestRemote? questRemote(Ref ref) =>
    ref.watch(firebaseReadyProvider) ? FirestoreQuestRemote() : null;

/// The saved quest day (the latest one she used), or null.
@riverpod
Stream<QuestDay?> savedQuestDay(Ref ref) =>
    ref.watch(questRepositoryProvider).watch();

List<String> _focusIds(UserProfile? profile) => [
  for (final area in profile?.focusAreas ?? const <FocusArea>[]) area.id,
];

/// Today's quest as she sees it.
@immutable
class TodayQuest {
  const TodayQuest({
    required this.quest,
    required this.done,
    required this.swapped,
  });

  final Quest quest;
  final bool done;
  final bool swapped;

  /// She may trade once a day, and not after finishing it.
  bool get canSwap => !swapped && !done;
}

/// Today's quest, or null while the quests load or when there are none. It is
/// the day's deterministic pick until she swaps or finishes it.
@riverpod
TodayQuest? todayQuest(Ref ref) {
  final quests = ref.watch(questsProvider).value;
  if (quests == null) return null;
  final now = ref.watch(clockProvider)();
  final focus = _focusIds(ref.watch(profileControllerProvider).value);
  final saved = ref.watch(savedQuestDayProvider).value;
  final today = saved != null && saved.date == questDateKey(now) ? saved : null;

  Quest? byId(String id) {
    for (final quest in quests) {
      if (quest.id == id) return quest;
    }
    return null;
  }

  final quest =
      (today == null ? null : byId(today.questId)) ??
      dailyQuest(
        quests,
        now,
        focusAreas: focus,
        swapped: today?.swapped ?? false,
      );
  if (quest == null) return null;
  return TodayQuest(
    quest: quest,
    done: today?.done ?? false,
    swapped: today?.swapped ?? false,
  );
}

/// Marks today's quest done.
@riverpod
Future<void> Function() completeQuest(Ref ref) => () async {
  final current = ref.read(todayQuestProvider);
  if (current == null || current.done) return;
  await ref
      .read(questRepositoryProvider)
      .save(
        QuestDay(
          date: questDateKey(ref.read(clockProvider)()),
          questId: current.quest.id,
          done: true,
          swapped: current.swapped,
        ),
      );
};

/// Trades today's quest for the other pick, once a day.
@riverpod
Future<void> Function() swapQuest(Ref ref) => () async {
  final current = ref.read(todayQuestProvider);
  final quests = ref.read(questsProvider).value;
  if (current == null || quests == null || !current.canSwap) return;
  final now = ref.read(clockProvider)();
  final focus = _focusIds(ref.read(profileControllerProvider).value);
  final other = dailyQuest(quests, now, focusAreas: focus, swapped: true);
  if (other == null) return;
  await ref
      .read(questRepositoryProvider)
      .save(
        QuestDay(date: questDateKey(now), questId: other.id, swapped: true),
      );
};

/// Keeps the quest state in Firestore in step with the device while someone
/// is signed in. The device wins when its day is the same or newer. A failed
/// upload is retried with the next change. Watched from the app root.
@Riverpod(keepAlive: true)
Future<void> questSync(Ref ref) async {
  final user = await ref.watch(authUserProvider.future);
  final remote = ref.watch(questRemoteProvider);
  if (user == null || remote == null) return;
  final uid = user.uid;
  final repository = ref.watch(questRepositoryProvider);

  try {
    final fetched = await remote.fetch(uid);
    if (fetched != null) await repository.restore(fetched);
  } on AppFailure catch (error) {
    debugPrint('Could not read the quest from Firestore: $error');
  }

  var busy = false;
  var again = false;
  Future<void> push() async {
    if (busy) {
      again = true;
      return;
    }
    busy = true;
    try {
      do {
        again = false;
        final day = await repository.unsynced();
        if (day == null) continue;
        try {
          await remote.put(uid, day);
          await repository.markSynced(day);
        } on AppFailure catch (error) {
          debugPrint('Could not save the quest to Firestore: $error');
        }
      } while (again);
    } finally {
      busy = false;
    }
  }

  final subscription = repository.watch().listen((_) => push());
  ref.onDispose(subscription.cancel);
}
