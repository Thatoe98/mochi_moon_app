import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mochi_moon/core/analytics/analytics_event.dart';
import 'package:mochi_moon/core/analytics/analytics_providers.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/gratitude/data/drift_gratitude_repository.dart';
import 'package:mochi_moon/features/gratitude/data/firestore_gratitude_remote.dart';
import 'package:mochi_moon/features/gratitude/domain/gratitude.dart';
import 'package:mochi_moon/features/gratitude/domain/gratitude_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gratitude_providers.g.dart';

@Riverpod(keepAlive: true)
GratitudeRepository gratitudeRepository(Ref ref) =>
    DriftGratitudeRepository(ref.watch(appDatabaseProvider));

/// The Firestore copy, or null when Firebase did not start.
@Riverpod(keepAlive: true)
GratitudeRemote? gratitudeRemote(Ref ref) =>
    ref.watch(firebaseReadyProvider) ? FirestoreGratitudeRemote() : null;

/// Every entry, newest first.
@riverpod
Stream<List<GratitudeNote>> gratitudeEntries(Ref ref) =>
    ref.watch(gratitudeRepositoryProvider).watch();

/// How many entries she has written today.
@riverpod
int gratitudeCountToday(Ref ref) {
  final today = ref.watch(clockProvider)();
  return gratitudeCountOn(
    ref.watch(gratitudeEntriesProvider).value ?? const <GratitudeNote>[],
    today,
  );
}

/// Adds today's entry. Returns why it was not added, or null when it was.
/// The count is read from the store, so two quick taps cannot pass the limit.
@riverpod
Future<GratitudeRejection?> Function(String text) addGratitude(Ref ref) =>
    (text) async {
      final analytics = ref.read(analyticsLoggerProvider);
      final repository = ref.read(gratitudeRepositoryProvider);
      final now = ref.read(clockProvider)();
      final countToday = gratitudeCountOn(await repository.entries(), now);
      final rejection = checkGratitude(text, countToday: countToday);
      if (rejection != null) return rejection;
      await repository.add(
        GratitudeNote(
          id: newGratitudeId(),
          day: now,
          body: text.trim(),
          createdAt: now,
        ),
      );
      // Only the count goes out, never the text she wrote.
      unawaited(
        analytics.log(
          AnalyticsEvent.gratitudeAdded,
          params: {'count': '${countToday + 1}'},
        ),
      );
      return null;
    };

/// Deletes an entry here and, when signed in, in Firestore. If Firestore
/// cannot be reached the copy there comes back with the next sync.
@riverpod
Future<void> Function(String id) deleteGratitude(Ref ref) => (id) async {
  // Read everything before the first await: this provider is not kept alive.
  final repository = ref.read(gratitudeRepositoryProvider);
  final user = ref.read(authUserProvider).value;
  final remote = ref.read(gratitudeRemoteProvider);
  await repository.delete(id);
  if (user == null || remote == null) return;
  try {
    await remote.delete(user.uid, id);
  } on AppFailure catch (error) {
    debugPrint('Could not delete a gratitude entry in Firestore: $error');
  }
};

/// Keeps the entries in Firestore in step with the device while someone is
/// signed in: entries only Firestore has are added here, and new ones here are
/// sent. A failed upload is tried again with the next change. Watched from the
/// app root.
@Riverpod(keepAlive: true)
Future<void> gratitudeSync(Ref ref) async {
  final user = await ref.watch(authUserProvider.future);
  final remote = ref.watch(gratitudeRemoteProvider);
  if (user == null || remote == null) return;
  final uid = user.uid;
  final repository = ref.watch(gratitudeRepositoryProvider);

  try {
    await repository.addMissing(await remote.fetch(uid));
  } on AppFailure catch (error) {
    debugPrint('Could not read the gratitude entries from Firestore: $error');
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
        for (final entry in await repository.unsynced()) {
          try {
            await remote.put(uid, entry);
            await repository.markSynced([entry]);
          } on AppFailure catch (error) {
            debugPrint('Could not save a gratitude entry to Firestore: $error');
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
