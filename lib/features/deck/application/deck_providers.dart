import 'dart:math';

import 'package:mochi_moon/core/content/card_of_the_day.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/deck/data/drift_deck_repository.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/deck/domain/deck_planner.dart';
import 'package:mochi_moon/features/deck/domain/deck_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'deck_providers.g.dart';

@Riverpod(keepAlive: true)
DeckRepository deckRepository(Ref ref) =>
    DriftDeckRepository(ref.watch(appDatabaseProvider));

/// Current time; overridden in tests.
@Riverpod(keepAlive: true)
DateTime Function() clock(Ref ref) => DateTime.now;

@Riverpod(keepAlive: true)
Random random(Ref ref) => Random();

/// Cards per day on the free plan. Premium (M4) overrides this.
@Riverpod(keepAlive: true)
int dailyCardLimit(Ref ref) => 10;

/// Today's deck: [cards] is fixed for the session and [position] is how many
/// of them have been completed.
class DeckState {
  const DeckState({
    required this.cards,
    required this.position,
    required this.completedToday,
    required this.streak,
    required this.canUndo,
  });

  final List<Quote> cards;
  final int position;
  final int completedToday;
  final int streak;
  final bool canUndo;

  int get remaining => cards.length - position;

  /// True once nothing is left to swipe today.
  bool get isDone => remaining == 0;

  DeckState copyWith({
    int? position,
    int? completedToday,
    int? streak,
    bool? canUndo,
  }) => DeckState(
    cards: cards,
    position: position ?? this.position,
    completedToday: completedToday ?? this.completedToday,
    streak: streak ?? this.streak,
    canUndo: canUndo ?? this.canUndo,
  );
}

@riverpod
class Deck extends _$Deck {
  List<DeckEvent> _history = [];
  DeckEvent? _last;

  @override
  Future<DeckState> build() async {
    final repo = ref.watch(deckRepositoryProvider);
    final now = ref.watch(clockProvider)();
    final quotes = await ref.watch(quotesProvider.future);
    final limit = ref.watch(dailyCardLimitProvider);

    _history = await repo.history();
    _last = null;

    final byId = {for (final q in quotes) q.id: q};
    final plan = planDeck(
      quoteIds: byId.keys.toList(),
      history: _history,
      now: now,
      random: ref.watch(randomProvider),
    );
    final pinned = _pinCardOfTheDay(plan, quotes, now);
    final completed = completedOnDay(_history, now);
    final left = (limit - completed).clamp(0, plan.length);

    return DeckState(
      cards: [for (final id in pinned.take(left)) byId[id]!],
      position: 0,
      completedToday: completed,
      streak: currentStreak(_history, now),
      canUndo: false,
    );
  }

  /// Moves today's [cardOfTheDay] to the front of [plan] (the card the widget
  /// and the reminder show), unless it was already completed today.
  List<String> _pinCardOfTheDay(
    List<String> plan,
    List<Quote> quotes,
    DateTime now,
  ) {
    final card = cardOfTheDay(quotes, now);
    if (card == null || !plan.contains(card.id)) return plan;
    final seenToday = _history.any(
      (e) => e.quoteId == card.id && completedOnDay([e], now) > 0,
    );
    if (seenToday) return plan;
    return [card.id, ...plan.where((id) => id != card.id)];
  }

  /// Records the top card as completed with [action].
  Future<void> complete(DeckAction action) async {
    final current = state.value;
    if (current == null || current.isDone) return;

    final now = ref.read(clockProvider)();
    final quote = current.cards[current.position];
    final event = await ref
        .read(deckRepositoryProvider)
        .record(quote.id, action, now);
    _history = [..._history, event];
    _last = event;

    state = AsyncData(
      current.copyWith(
        position: current.position + 1,
        completedToday: completedOnDay(_history, now),
        streak: currentStreak(_history, now),
        canUndo: true,
      ),
    );
  }

  /// Takes back the last completed card (one level).
  Future<void> undo() async {
    final current = state.value;
    final last = _last;
    if (current == null || last == null || current.position == 0) return;

    final now = ref.read(clockProvider)();
    await ref.read(deckRepositoryProvider).undo(last);
    _history = _history.where((e) => e.id != last.id).toList();
    _last = null;

    state = AsyncData(
      current.copyWith(
        position: current.position - 1,
        completedToday: completedOnDay(_history, now),
        streak: currentStreak(_history, now),
        canUndo: false,
      ),
    );
  }
}
