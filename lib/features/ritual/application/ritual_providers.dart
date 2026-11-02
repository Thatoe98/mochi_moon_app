import 'dart:async';

import 'package:mochi_moon/core/analytics/analytics_event.dart';
import 'package:mochi_moon/core/analytics/analytics_providers.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/custom_cards/application/own_card_providers.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/ritual/data/drift_ritual_progress_repository.dart';
import 'package:mochi_moon/features/ritual/domain/ritual_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ritual_providers.g.dart';

@Riverpod(keepAlive: true)
RitualProgressRepository ritualProgressRepository(Ref ref) =>
    DriftRitualProgressRepository(ref.watch(appDatabaseProvider));

/// Today's daily ritual (PRD §6.15): mood, three cards, a gratitude line and
/// a celebration. It resumes at the same step when she leaves and returns the
/// same day, and starts again when the day turns.
@riverpod
class RitualController extends _$RitualController {
  DateTime _day = DateTime(0);

  @override
  Future<RitualState> build() async {
    final now = ref.watch(clockProvider)();
    _day = DateTime(now.year, now.month, now.day);
    // A second of margin, so an early timer never rebuilds the same day.
    final timer = Timer(
      DateTime(now.year, now.month, now.day + 1).difference(now) +
          const Duration(seconds: 1),
      ref.invalidateSelf,
    );
    ref.onDispose(timer.cancel);

    final deckRepository = ref.watch(deckRepositoryProvider);
    if ((await deckRepository.ritualDays()).contains(_day)) {
      return const RitualState(phase: RitualPhase.finished);
    }
    final saved = await ref.watch(ritualProgressRepositoryProvider).load(_day);
    if (saved == null) return const RitualState(phase: RitualPhase.notStarted);

    final quotes = await ref.watch(cardPoolProvider.future);
    final byId = {for (final quote in quotes) quote.id: quote};
    final cards = [for (final id in saved.quoteIds) ?byId[id]];
    // Cards she already finished are in today's history, so the ritual picks
    // up at the first one that is not.
    final doneToday = {
      for (final event in await deckRepository.history())
        if (DateTime(event.at.year, event.at.month, event.at.day) == _day)
          event.quoteId,
    };
    final position = cards.takeWhile((c) => doneToday.contains(c.id)).length;
    return RitualState(phase: saved.phase, cards: cards, position: position);
  }

  /// Begins the ritual with the next cards of today's deck. The free limit
  /// applies: fewer than three cards left means the ritual uses what is left,
  /// and none left skips the card step.
  Future<void> start() async {
    final deck = await ref.read(deckProvider.future);
    final cards = deck.cards.skip(deck.position).take(ritualCardCount).toList();
    await _go(RitualState(phase: RitualPhase.mood, cards: cards));
    unawaited(
      ref.read(analyticsLoggerProvider).log(AnalyticsEvent.ritualStarted),
    );
  }

  /// Leaves the mood step. Her mood, if she picked one, is stored by the
  /// mood providers; skipping stores nothing.
  Future<void> finishMood() async {
    final current = state.value;
    if (current == null || current.phase != RitualPhase.mood) return;
    await _go(
      RitualState(
        phase: current.cards.isEmpty
            ? RitualPhase.gratitude
            : RitualPhase.cards,
        cards: current.cards,
      ),
    );
  }

  /// Records the ritual card on top with [action]. The cards count toward the
  /// day's free limit like any other card.
  Future<void> completeCard(DeckAction action) async {
    final current = state.value;
    if (current == null ||
        current.phase != RitualPhase.cards ||
        current.position >= current.cards.length) {
      return;
    }
    final quote = current.cards[current.position];
    await ref
        .read(deckRepositoryProvider)
        .record(
          quote.id,
          action,
          ref.read(clockProvider)(),
          source: DeckSource.ritual,
        );
    // The deck deals again without the card, with the new count and streak.
    ref.invalidate(deckProvider);
    final position = current.position + 1;
    await _go(
      RitualState(
        phase: position == current.cards.length
            ? RitualPhase.gratitude
            : RitualPhase.cards,
        cards: current.cards,
        position: position,
      ),
    );
  }

  /// Leaves the gratitude step and finishes the ritual: the day counts for
  /// the streak.
  Future<void> finishGratitude() async {
    final current = state.value;
    if (current == null || current.phase != RitualPhase.gratitude) return;
    await ref.read(deckProvider.notifier).completeRitualDay();
    state = const AsyncData(RitualState(phase: RitualPhase.finished));
    unawaited(
      ref.read(analyticsLoggerProvider).log(AnalyticsEvent.ritualCompleted),
    );
  }

  Future<void> _go(RitualState next) async {
    await ref
        .read(ritualProgressRepositoryProvider)
        .save(
          SavedRitual(
            day: _day,
            phase: next.phase,
            quoteIds: [for (final card in next.cards) card.id],
          ),
        );
    state = AsyncData(next);
  }
}
