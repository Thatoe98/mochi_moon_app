import 'dart:async';

import 'package:mochi_moon/core/utils/url_opener.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/mood/application/mood_providers.dart';
import 'package:mochi_moon/features/review/data/play_review_service.dart';
import 'package:mochi_moon/features/review/data/prefs_review_history_repository.dart';
import 'package:mochi_moon/features/review/domain/review_policy.dart';
import 'package:mochi_moon/features/review/domain/review_repositories.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'review_providers.g.dart';

@Riverpod(keepAlive: true)
ReviewHistoryRepository reviewHistoryRepository(Ref ref) =>
    PrefsReviewHistoryRepository(SharedPreferencesAsync());

@Riverpod(keepAlive: true)
ReviewService reviewService(Ref ref) =>
    PlayReviewService(openUrl: ref.watch(urlOpenerProvider));

/// How long the celebration has the screen to itself before the sheet shows.
@Riverpod(keepAlive: true)
Duration reviewPromptDelay(Ref ref) => const Duration(seconds: 2);

/// After a finished ritual: asks Google Play for a rating when it is a kind
/// moment (see [shouldAskForReview]). Silent on every failure.
@Riverpod(keepAlive: true)
Future<void> Function() maybeAskForReview(Ref ref) {
  return () async {
    try {
      final deck = await ref.read(deckProvider.future);
      final now = ref.read(clockProvider)();
      final history = await ref.read(reviewHistoryRepositoryProvider).load();
      final ask = shouldAskForReview(
        streak: deck.streak,
        todayMood: ref.read(todayMoodProvider),
        history: history,
        now: now,
      );
      if (!ask) return;
      await Future<void>.delayed(ref.read(reviewPromptDelayProvider));
      await ref.read(reviewHistoryRepositoryProvider).markAsked(now);
      await ref.read(reviewServiceProvider).requestReview();
    } on Object {
      // A rating prompt must never get in her way.
    }
  };
}
