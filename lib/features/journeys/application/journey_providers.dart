import 'package:flutter/foundation.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/journey.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/journeys/data/drift_journey_repository.dart';
import 'package:mochi_moon/features/journeys/data/firestore_journey_remote.dart';
import 'package:mochi_moon/features/journeys/domain/journey_progress.dart';
import 'package:mochi_moon/features/journeys/domain/journey_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'journey_providers.g.dart';

@Riverpod(keepAlive: true)
JourneyRepository journeyRepository(Ref ref) =>
    DriftJourneyRepository(ref.watch(appDatabaseProvider));

/// The Firestore copy, or null when Firebase did not start.
@Riverpod(keepAlive: true)
JourneyRemote? journeyRemote(Ref ref) =>
    ref.watch(firebaseReadyProvider) ? FirestoreJourneyRemote() : null;

/// Every journey she has started.
@riverpod
Stream<List<JourneyProgress>> journeyProgressList(Ref ref) =>
    ref.watch(journeyRepositoryProvider).watchAll();

/// The journeys she can see, with the one she is on first.
@riverpod
Future<Journey?> journeyById(Ref ref, String journeyId) async {
  final journeys = await ref.watch(journeysProvider.future);
  for (final journey in journeys) {
    if (journey.id == journeyId) return journey;
  }
  return null;
}

/// Day `day` of `journeyId` with its cards and quest looked up, or null.
@riverpod
Future<ResolvedJourneyDay?> journeyDay(
  Ref ref,
  String journeyId,
  int day,
) async {
  final journey = await ref.watch(journeyByIdProvider(journeyId).future);
  if (journey == null) return null;
  final quotes = await ref.watch(quotesProvider.future);
  final quests = await ref.watch(questsProvider.future);
  return resolveJourneyDay(journey, day, quotes, quests);
}

/// Starts the journey `journeyId`. Does nothing when another journey is still
/// going (one at a time) or the id is unknown. A finished journey can be
/// started again.
@Riverpod(keepAlive: true)
Future<void> Function(String journeyId) startJourneyAction(Ref ref) =>
    (journeyId) async {
      final journeys = await ref.read(journeysProvider.future);
      final all = await ref.read(journeyRepositoryProvider).watchAll().first;
      if (!canStartJourney(all)) return;
      for (final journey in journeys) {
        if (journey.id != journeyId) continue;
        await ref
            .read(journeyRepositoryProvider)
            .save(startJourney(journey, ref.read(clockProvider)()));
        return;
      }
    };

/// Finishes the current day of `journeyId`, with her optional private
/// reflection. Does nothing when she already finished a day today.
@Riverpod(keepAlive: true)
Future<void> Function(String journeyId, {String? reflection})
completeJourneyDay(Ref ref) => (journeyId, {reflection}) async {
  final journeys = await ref.read(journeysProvider.future);
  final all = await ref.read(journeyRepositoryProvider).watchAll().first;
  final now = ref.read(clockProvider)();
  for (final journey in journeys) {
    if (journey.id != journeyId) continue;
    for (final run in all) {
      if (run.journeyId != journeyId) continue;
      final next = run.completeDay(
        now,
        totalDays: journey.days,
        reflection: reflection,
      );
      if (next != run) await ref.read(journeyRepositoryProvider).save(next);
    }
  }
};

/// Keeps the journey progress in Firestore in step with the device while
/// someone is signed in. Progress never goes backwards: a record from
/// Firestore only replaces the local one when it is further along. A failed
/// upload is retried with the next change. Watched from the app root.
@Riverpod(keepAlive: true)
Future<void> journeySync(Ref ref) async {
  final user = await ref.watch(authUserProvider.future);
  final remote = ref.watch(journeyRemoteProvider);
  if (user == null || remote == null) return;
  final uid = user.uid;
  final repository = ref.watch(journeyRepositoryProvider);

  try {
    for (final progress in await remote.fetchAll(uid)) {
      await repository.restore(progress);
    }
  } on AppFailure catch (error) {
    debugPrint('Could not read the journeys from Firestore: $error');
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
        for (final progress in await repository.unsynced()) {
          try {
            await remote.put(uid, progress);
            await repository.markSynced(progress);
          } on AppFailure catch (error) {
            debugPrint('Could not save a journey to Firestore: $error');
          }
        }
      } while (again);
    } finally {
      busy = false;
    }
  }

  final subscription = repository.watchAll().listen((_) => push());
  ref.onDispose(subscription.cancel);
}
