import 'package:flutter/foundation.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/mascot_item.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/journeys/application/journey_providers.dart';
import 'package:mochi_moon/features/mascot/data/drift_mascot_repository.dart';
import 'package:mochi_moon/features/mascot/data/firestore_mascot_remote.dart';
import 'package:mochi_moon/features/mascot/domain/mascot_repository.dart';
import 'package:mochi_moon/features/mascot/domain/mascot_state.dart';
import 'package:mochi_moon/features/mascot/domain/mascot_unlocks.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mascot_providers.g.dart';

@Riverpod(keepAlive: true)
MascotRepository mascotRepository(Ref ref) =>
    DriftMascotRepository(ref.watch(appDatabaseProvider));

/// The Firestore copy, or null when Firebase did not start.
@Riverpod(keepAlive: true)
MascotRemote? mascotRemote(Ref ref) =>
    ref.watch(firebaseReadyProvider) ? FirestoreMascotRemote() : null;

/// What Mochi owns and wears.
@riverpod
Stream<MascotState> mascotState(Ref ref) =>
    ref.watch(mascotRepositoryProvider).watch();

/// Gives Mochi every item whose rule is now met (PRD §6.23). Items are only
/// added, so a streak that breaks later takes nothing away. Watched from the
/// app root.
@Riverpod(keepAlive: true)
Future<void> mascotEarner(Ref ref) async {
  final items = await ref.watch(mascotItemsProvider.future);
  final state = await ref.watch(mascotStateProvider.future);
  final streak = ref.watch(deckProvider).value?.streak ?? 0;
  final progress = ref.watch(journeyProgressListProvider).value ?? const [];
  final finished = {
    for (final p in progress)
      if (p.isFinished) p.journeyId,
  };
  final earned = newlyEarned(
    items,
    state,
    streak: streak,
    finishedJourneyIds: finished,
  );
  if (earned.isEmpty) return;
  await ref
      .read(mascotRepositoryProvider)
      .grant(earned, ref.read(clockProvider)());
}

/// Puts `item` on Mochi, or does nothing when she does not own it or it needs
/// Premium. Returns whether it was equipped.
@Riverpod(keepAlive: true)
Future<bool> Function(MascotItem item) equipMascotItem(Ref ref) =>
    (item) async {
      final state = await ref.read(mascotStateProvider.future);
      final ok = canEquip(item, state, isPremium: ref.read(hasPremiumProvider));
      if (!ok) return false;
      await ref.read(mascotRepositoryProvider).equip(item.slot, item.id);
      return true;
    };

/// Takes whatever is in `slot` off.
@Riverpod(keepAlive: true)
Future<void> Function(String slot) unequipMascotSlot(Ref ref) =>
    (slot) => ref.read(mascotRepositoryProvider).unequip(slot);

/// Keeps the mascot document in Firestore in step with the device while
/// someone is signed in. Owned items are merged both ways. A failed upload is
/// retried with the next change. Watched from the app root.
@Riverpod(keepAlive: true)
Future<void> mascotSync(Ref ref) async {
  final user = await ref.watch(authUserProvider.future);
  final remote = ref.watch(mascotRemoteProvider);
  if (user == null || remote == null) return;
  final uid = user.uid;
  final repository = ref.watch(mascotRepositoryProvider);
  final now = ref.read(clockProvider);

  try {
    final fetched = await remote.fetch(uid);
    if (fetched != null) await repository.restore(fetched, now());
  } on AppFailure catch (error) {
    debugPrint('Could not read the mascot from Firestore: $error');
  }

  var busy = false;
  var again = false;
  var lastSent = const MascotState();
  Future<void> push() async {
    if (busy) {
      again = true;
      return;
    }
    busy = true;
    try {
      do {
        again = false;
        final state = await repository.watch().first;
        if (state.owned.isEmpty || state == lastSent) continue;
        try {
          await remote.put(uid, state);
          lastSent = state;
        } on AppFailure catch (error) {
          debugPrint('Could not save the mascot to Firestore: $error');
        }
      } while (again);
    } finally {
      busy = false;
    }
  }

  final subscription = repository.watch().listen((_) => push());
  ref.onDispose(subscription.cancel);
}
