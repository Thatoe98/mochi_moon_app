import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:mochi_moon/core/analytics/analytics_event.dart';
import 'package:mochi_moon/core/analytics/analytics_providers.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/premium/free_limits.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/letters/data/drift_letter_repository.dart';
import 'package:mochi_moon/features/letters/data/firestore_letter_remote.dart';
import 'package:mochi_moon/features/letters/data/local_notifications_letter_notifier.dart';
import 'package:mochi_moon/features/letters/domain/future_letter.dart';
import 'package:mochi_moon/features/letters/domain/letter_repository.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'letter_providers.g.dart';

@Riverpod(keepAlive: true)
LetterRepository letterRepository(Ref ref) =>
    DriftLetterRepository(ref.watch(appDatabaseProvider));

/// The Firestore copy, or null when Firebase did not start.
@Riverpod(keepAlive: true)
LetterRemote? letterRemote(Ref ref) =>
    ref.watch(firebaseReadyProvider) ? FirestoreLetterRemote() : null;

@Riverpod(keepAlive: true)
LetterNotifier letterScheduler(Ref ref) => LocalNotificationsLetterNotifier();

/// Every letter, the one that opens soonest first.
@riverpod
Stream<List<FutureLetter>> futureLetters(Ref ref) =>
    ref.watch(letterRepositoryProvider).watch();

/// The letter `letterId`, or null when there is none.
@riverpod
Future<FutureLetter?> futureLetter(Ref ref, String letterId) async {
  final letters = await ref.watch(futureLettersProvider.future);
  for (final letter in letters) {
    if (letter.id == letterId) return letter;
  }
  return null;
}

/// How many more letters she can seal right now: null means no limit
/// (Premium). Free accounts keep [FreeLimits.sealedLetters] sealed at a time;
/// a letter that has opened no longer uses the slot.
@riverpod
int? sealedLettersLeft(Ref ref) {
  if (ref.watch(hasPremiumProvider)) return null;
  final letters = ref.watch(futureLettersProvider).value ?? const [];
  final sealed = sealedCount(letters, ref.watch(clockProvider)());
  return (FreeLimits.sealedLetters - sealed).clamp(0, FreeLimits.sealedLetters);
}

/// What happened when she sealed a letter.
@immutable
class SealOutcome {
  const SealOutcome({this.rejection, this.reminderOn = false});

  /// Why it was not sealed, or null when it was.
  final LetterRejection? rejection;

  /// Whether a notification will tell her when it opens.
  final bool reminderOn;
}

/// Seals a letter written now. Asks for notification permission first, the
/// same way the daily reminder does, so the letter can announce itself.
@Riverpod(keepAlive: true)
Future<SealOutcome> Function(String text, int unlockDays) sealLetterAction(
  Ref ref,
) => (text, unlockDays) async {
  final rejection = checkLetter(text, unlockDays: unlockDays);
  if (rejection != null) return SealOutcome(rejection: rejection);
  final analytics = ref.read(analyticsLoggerProvider);
  final scheduler = ref.read(reminderSchedulerProvider);
  final repository = ref.read(letterRepositoryProvider);
  final now = ref.read(clockProvider)();
  // Counted from the store so two quick taps cannot pass the free limit.
  if (!ref.read(hasPremiumProvider) &&
      sealedCount(await repository.letters(), now) >=
          FreeLimits.sealedLetters) {
    return const SealOutcome(rejection: LetterRejection.limitReached);
  }
  var allowed = false;
  try {
    allowed =
        await scheduler.hasPermission() || await scheduler.requestPermission();
  } on Object catch (error) {
    debugPrint('Could not ask for notification permission: $error');
  }
  await repository.add(
    sealLetter(id: newLetterId(), text: text, unlockDays: unlockDays, now: now),
  );
  unawaited(
    analytics.log(
      AnalyticsEvent.letterSealed,
      params: {'unlockDays': '$unlockDays'},
    ),
  );
  return SealOutcome(reminderOn: allowed);
};

/// Deletes a letter here, its notification and, when signed in, its copy in
/// Firestore. If Firestore cannot be reached the copy there comes back with
/// the next sync.
@Riverpod(keepAlive: true)
Future<void> Function(String id) deleteLetter(Ref ref) => (id) async {
  final repository = ref.read(letterRepositoryProvider);
  final notifier = ref.read(letterSchedulerProvider);
  final user = ref.read(authUserProvider).value;
  final remote = ref.read(letterRemoteProvider);
  await repository.delete(id);
  try {
    await notifier.cancel(id);
  } on Object catch (error) {
    debugPrint('Could not cancel a letter notification: $error');
  }
  if (user == null || remote == null) return;
  try {
    await remote.delete(user.uid, id);
  } on AppFailure catch (error) {
    debugPrint('Could not delete a letter in Firestore: $error');
  }
};

/// Keeps one notification per sealed letter that has not opened yet, in the
/// app language. The notification says only that a letter is ready; it never
/// carries the letter. Re-planned whenever the letters or the language change
/// and once per app run. Watched from the app root.
@Riverpod(keepAlive: true)
Future<void> letterNotificationsSync(Ref ref) async {
  final lang = ref.watch(reminderLanguageProvider);
  final repository = ref.watch(letterRepositoryProvider);
  final notifier = ref.watch(letterSchedulerProvider);
  final scheduler = ref.watch(reminderSchedulerProvider);
  final clock = ref.watch(clockProvider);
  final l10n = lookupAppLocalizations(Locale(lang));
  final texts = LetterNotificationTexts(
    title: l10n.letterNotificationTitle,
    body: l10n.letterNotificationBody,
    channelName: l10n.letterChannelName,
    channelDescription: l10n.letterChannelDescription,
  );

  Future<void> apply(List<FutureLetter> letters) async {
    try {
      final now = clock();
      final allowed = await scheduler.hasPermission();
      await notifier.schedule({
        if (allowed)
          for (final letter in letters)
            if (!letter.isOpen(now)) letter.id: letter.unlockAt,
      }, texts);
    } on Object catch (error) {
      debugPrint('Could not schedule the letter notifications: $error');
    }
  }

  final subscription = repository.watch().listen((l) => unawaited(apply(l)));
  ref.onDispose(subscription.cancel);
}

/// Keeps the letters in Firestore in step with the device while someone is
/// signed in: letters only Firestore has are added here, and new ones here are
/// sent. A failed upload is tried again with the next change. Watched from the
/// app root.
@Riverpod(keepAlive: true)
Future<void> letterSync(Ref ref) async {
  final user = await ref.watch(authUserProvider.future);
  final remote = ref.watch(letterRemoteProvider);
  if (user == null || remote == null) return;
  final uid = user.uid;
  final repository = ref.watch(letterRepositoryProvider);

  try {
    await repository.addMissing(await remote.fetch(uid));
  } on AppFailure catch (error) {
    debugPrint('Could not read the letters from Firestore: $error');
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
        for (final letter in await repository.unsynced()) {
          try {
            await remote.put(uid, letter);
            await repository.markSynced([letter]);
          } on AppFailure catch (error) {
            debugPrint('Could not save a letter to Firestore: $error');
          }
        }
      } while (again);
    } finally {
      busy = false;
    }
  }

  final subscription = repository.watch().listen((_) => unawaited(push()));
  ref.onDispose(subscription.cancel);
}
