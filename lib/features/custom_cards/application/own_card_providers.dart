import 'package:flutter/foundation.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/custom_cards/data/drift_own_card_repository.dart';
import 'package:mochi_moon/features/custom_cards/data/firestore_own_card_remote.dart';
import 'package:mochi_moon/features/custom_cards/domain/own_card.dart';
import 'package:mochi_moon/features/custom_cards/domain/own_card_repository.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'own_card_providers.g.dart';

@Riverpod(keepAlive: true)
OwnCardRepository ownCardRepository(Ref ref) =>
    DriftOwnCardRepository(ref.watch(appDatabaseProvider));

/// The Firestore copy, or null when Firebase did not start.
@Riverpod(keepAlive: true)
OwnCardRemote? ownCardRemote(Ref ref) =>
    ref.watch(firebaseReadyProvider) ? FirestoreOwnCardRemote() : null;

/// Every card she wrote, newest first.
@riverpod
Stream<List<OwnCard>> ownCards(Ref ref) =>
    ref.watch(ownCardRepositoryProvider).watch();

/// Her cards as deck cards (category `self_love`, id `own_<id>`).
@riverpod
List<Quote> ownCardQuotes(Ref ref) => [
  for (final card in ref.watch(ownCardsProvider).value ?? const <OwnCard>[])
    card.toQuote(),
];

/// Every card the deck can deal: the bundled quotes, then the ones she wrote.
/// The deck, the ritual, the journal and the widget all draw from this.
@riverpod
Future<List<Quote>> cardPool(Ref ref) async {
  final bundled = await ref.watch(quotesProvider.future);
  final own = await ref.watch(ownCardsProvider.future);
  return [...bundled, for (final card in own) card.toQuote()];
}

/// How many more cards she can write: null means no limit (Premium).
@riverpod
int? ownCardSlotsLeft(Ref ref) {
  if (ref.watch(hasPremiumProvider)) return null;
  final used = ref.watch(ownCardsProvider).value?.length ?? 0;
  return (ownCardFreeLimit - used).clamp(0, ownCardFreeLimit);
}

/// Creates a card, or edits the one with `editId`. Returns why it was not
/// saved, or null when it was. The count is read from the store, so two quick
/// taps cannot pass the free limit. Editing never counts against the limit,
/// and deleting a card frees its slot.
@riverpod
Future<OwnCardRejection?> Function(
  String text,
  String illustrationId, {
  String? editId,
})
saveOwnCard(Ref ref) => (text, illustrationId, {editId}) async {
  final repository = ref.read(ownCardRepositoryProvider);
  final isPremium = ref.read(hasPremiumProvider);
  final now = ref.read(clockProvider)();
  final existing = await repository.cards();
  final edited = editId == null
      ? null
      : existing.where((c) => c.id == editId).firstOrNull;
  final rejection = checkOwnCard(
    text,
    illustrationId,
    countBefore: existing.length,
    isPremium: isPremium,
    isNew: edited == null,
  );
  if (rejection != null) return rejection;
  await repository.save(
    edited?.copyWith(body: text.trim(), illustrationId: illustrationId) ??
        OwnCard(
          id: newOwnCardId(),
          body: text.trim(),
          illustrationId: illustrationId,
          createdAt: now,
        ),
  );
  return null;
};

/// Deletes a card here and, when signed in, in Firestore. If Firestore cannot
/// be reached the copy there comes back with the next sync.
@riverpod
Future<void> Function(String id) deleteOwnCard(Ref ref) => (id) async {
  // Read everything before the first await: this provider is not kept alive.
  final repository = ref.read(ownCardRepositoryProvider);
  final user = ref.read(authUserProvider).value;
  final remote = ref.read(ownCardRemoteProvider);
  await repository.delete(id);
  if (user == null || remote == null) return;
  try {
    await remote.delete(user.uid, id);
  } on AppFailure catch (error) {
    debugPrint('Could not delete a card in Firestore: $error');
  }
};

/// Keeps her cards in Firestore in step with the device while someone is
/// signed in: cards only Firestore has are added here, and new or edited ones
/// here are sent. A failed upload is tried again with the next change.
/// Watched from the app root.
@Riverpod(keepAlive: true)
Future<void> ownCardSync(Ref ref) async {
  final user = await ref.watch(authUserProvider.future);
  final remote = ref.watch(ownCardRemoteProvider);
  if (user == null || remote == null) return;
  final uid = user.uid;
  final repository = ref.watch(ownCardRepositoryProvider);

  try {
    await repository.addMissing(await remote.fetch(uid));
  } on AppFailure catch (error) {
    debugPrint('Could not read the cards from Firestore: $error');
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
        for (final card in await repository.unsynced()) {
          try {
            await remote.put(uid, card);
            await repository.markSynced([card]);
          } on AppFailure catch (error) {
            debugPrint('Could not save a card to Firestore: $error');
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
