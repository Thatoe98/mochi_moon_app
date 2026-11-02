import 'dart:async';

import 'package:mochi_moon/core/analytics/analytics_event.dart';
import 'package:mochi_moon/core/analytics/analytics_providers.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:mochi_moon/features/paywall/data/prefs_trial_offer_repository.dart';
import 'package:mochi_moon/features/paywall/domain/trial_offer.dart';
import 'package:mochi_moon/features/ritual/application/ritual_providers.dart';
import 'package:mochi_moon/features/ritual/domain/ritual_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'trial_offer_providers.g.dart';

@Riverpod(keepAlive: true)
TrialOfferRepository trialOfferRepository(Ref ref) =>
    PrefsTrialOfferRepository(SharedPreferencesAsync());

/// Whether the one-time trial offer shows on Today right now (PRD §6.13).
///
/// Once it is on screen it stays until she answers it; it is remembered as
/// shown the moment the card appears, so it never comes back.
@riverpod
class TrialOffer extends _$TrialOffer {
  bool _active = false;

  @override
  Future<bool> build() async {
    if (ref.watch(hasPremiumProvider)) {
      _active = false;
      return false;
    }
    final finished =
        ref.watch(ritualControllerProvider).value?.phase ==
        RitualPhase.finished;
    if (_active) return finished;
    if (!finished) return false;
    try {
      final repository = ref.read(trialOfferRepositoryProvider);
      final now = ref.read(clockProvider)();
      final today = DateTime(now.year, now.month, now.day);
      final due = trialOfferDue(
        ritualDayCount:
            (await ref.read(deckRepositoryProvider).ritualDays()).length,
        finishedToday: finished,
        premium: false,
        alreadyShown: await repository.wasShown(),
        hardDayToday: await repository.openedHardDayOn(today),
      );
      _active = due;
      return due;
    } on Object {
      // A flag that cannot be read must never block Today: no offer.
      return false;
    }
  }

  /// Called once when the card appears: it counts as seen.
  Future<void> shown() async {
    await ref.read(trialOfferRepositoryProvider).markShown();
    unawaited(
      ref.read(analyticsLoggerProvider).log(AnalyticsEvent.trialOfferShown),
    );
  }

  /// "Not now": the card goes away and does not come back.
  void dismiss() {
    unawaited(
      ref.read(analyticsLoggerProvider).log(AnalyticsEvent.trialOfferDismissed),
    );
    _close();
  }

  /// She opened the paywall from the card.
  void opened() => _close();

  void _close() {
    _active = false;
    state = const AsyncData(false);
  }
}

/// Remembers that she opened the hard-day kit today, so no offer shows today.
@riverpod
Future<void> Function() noteHardDayOpened(Ref ref) => () async {
  try {
    final now = ref.read(clockProvider)();
    await ref
        .read(trialOfferRepositoryProvider)
        .noteHardDay(DateTime(now.year, now.month, now.day));
  } on Object {
    // Best effort: the kit must open whatever happens.
  }
};
