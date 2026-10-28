import 'package:flutter/foundation.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/journal/data/drift_journal_repository.dart';
import 'package:mochi_moon/features/journal/data/firestore_journal_remote.dart';
import 'package:mochi_moon/features/journal/domain/journal_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'journal_providers.g.dart';

@Riverpod(keepAlive: true)
JournalRepository journalRepository(Ref ref) =>
    DriftJournalRepository(ref.watch(appDatabaseProvider));

/// The Firestore copy, or null when Firebase did not start.
@Riverpod(keepAlive: true)
JournalRemote? journalRemote(Ref ref) =>
    ref.watch(firebaseReadyProvider) ? FirestoreJournalRemote() : null;

/// Keeps the journal in Firestore in step with the device while someone is
/// signed in. The device stays the source of truth, so every change is applied
/// here first and mirrored afterwards.
///
/// On start, cards that only Firestore has (a reinstall, another phone) are
/// added here; the rest of the changes are mirrored as they happen. A removal
/// that could not be sent is not remembered, so that card comes back the next
/// time the app opens. Watched from the app root.
@Riverpod(keepAlive: true)
Future<void> journalSync(Ref ref) async {
  final user = await ref.watch(authUserProvider.future);
  final remote = ref.watch(journalRemoteProvider);
  if (user == null || remote == null) return;
  final uid = user.uid;
  final repository = ref.watch(journalRepositoryProvider);

  // The ids Firestore is known to hold.
  var mirrored = <String>{};
  try {
    final stored = await remote.fetch(uid);
    mirrored = {for (final entry in stored) entry.quoteId};
    final local = {for (final e in await repository.entries()) e.quoteId};
    await repository.addMissing([
      for (final entry in stored)
        if (!local.contains(entry.quoteId)) entry,
    ]);
  } on AppFailure catch (error) {
    debugPrint('Could not read the journal from Firestore: $error');
  }

  var busy = false;
  var again = false;
  Future<void> mirror() async {
    // One pass at a time; a change that arrives meanwhile is picked up by the
    // pass that follows.
    if (busy) {
      again = true;
      return;
    }
    busy = true;
    try {
      do {
        again = false;
        final current = await repository.entries();
        final ids = {for (final e in current) e.quoteId};
        for (final entry in current) {
          if (mirrored.contains(entry.quoteId)) continue;
          try {
            await remote.put(uid, entry);
            mirrored.add(entry.quoteId);
          } on AppFailure catch (error) {
            debugPrint('Could not save a journal card to Firestore: $error');
          }
        }
        for (final quoteId in mirrored.difference(ids).toList()) {
          try {
            await remote.delete(uid, quoteId);
            mirrored.remove(quoteId);
          } on AppFailure catch (error) {
            debugPrint('Could not remove a journal card from Firestore: $error');
          }
        }
      } while (again);
    } finally {
      busy = false;
    }
  }

  final subscription = repository.watch().listen((_) => mirror());
  ref.onDispose(subscription.cancel);
}

/// A saved card together with its quote.
class JournalItem {
  const JournalItem({required this.quote, required this.savedAt});

  final Quote quote;
  final DateTime savedAt;
}

/// Saved cards, newest first. Rebuilds on each visit so it never shows a
/// stale list after the deck saved something.
@riverpod
class Journal extends _$Journal {
  @override
  Future<List<JournalItem>> build() async {
    final entries = await ref.watch(journalRepositoryProvider).entries();
    final quotes = await ref.watch(quotesProvider.future);
    final byId = {for (final q in quotes) q.id: q};
    // A saved id missing from the bundled quotes (e.g. a retired card) is
    // skipped rather than shown blank.
    return [
      for (final entry in entries)
        if (byId[entry.quoteId] case final quote?)
          JournalItem(quote: quote, savedAt: entry.savedAt),
    ];
  }

  Future<void> remove(String quoteId) async {
    await ref.read(journalRepositoryProvider).remove(quoteId);
    final current = state.value;
    if (current == null) return;
    state = AsyncData([
      for (final item in current)
        if (item.quote.id != quoteId) item,
    ]);
  }
}
