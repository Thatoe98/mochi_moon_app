import 'package:flutter/foundation.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/onboarding/data/prefs_onboarding_repository.dart';
import 'package:mochi_moon/features/onboarding/domain/onboarding_repository.dart';
import 'package:mochi_moon/features/onboarding/domain/sample_cards.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_providers.g.dart';

@Riverpod(keepAlive: true)
OnboardingRepository onboardingRepository(Ref ref) =>
    PrefsOnboardingRepository(SharedPreferencesAsync());

/// The saved first-run flag, read before the app starts so the router knows
/// where to begin. `bootstrap` overrides it; so do tests.
@Riverpod(keepAlive: true)
bool initialOnboardingComplete(Ref ref) =>
    throw UnimplementedError('initialOnboardingComplete must be overridden');

/// Whether the first-run flow is done. The router watches it.
@Riverpod(keepAlive: true)
class OnboardingComplete extends _$OnboardingComplete {
  @override
  bool build() => ref.watch(initialOnboardingCompleteProvider);

  /// Ends the flow. A flag that cannot be saved only means the flow shows
  /// again next time, so it never blocks the user.
  Future<void> complete() async {
    try {
      await ref.read(onboardingRepositoryProvider).markComplete();
    } on Exception catch (error) {
      debugPrint('Could not save the onboarding flag: $error');
    }
    state = true;
  }
}

/// The sample cards and how far the user is through them.
class SampleDeckState {
  const SampleDeckState({
    required this.cards,
    required this.position,
    required this.canUndo,
  });

  final List<Quote> cards;
  final int position;
  final bool canUndo;

  /// True once every sample card is done (or there are none to show).
  bool get isDone => position >= cards.length;

  SampleDeckState copyWith({int? position, bool? canUndo}) => SampleDeckState(
    cards: cards,
    position: position ?? this.position,
    canUndo: canUndo ?? this.canUndo,
  );
}

/// The three cards shown before sign-in. Swipes go through the deck
/// repository like any other, so a saved sample card is already in the journal.
@riverpod
class SampleDeck extends _$SampleDeck {
  DeckEvent? _last;

  @override
  Future<SampleDeckState> build() async {
    final quotes = await ref.watch(quotesProvider.future);
    final history = await ref.watch(deckRepositoryProvider).history();
    final cards = pickSampleCards(quotes);
    _last = null;
    return SampleDeckState(
      cards: cards,
      position: sampleProgress(cards, history),
      canUndo: false,
    );
  }

  /// Records the top card as completed with [action].
  Future<void> complete(DeckAction action) async {
    final current = state.value;
    if (current == null || current.isDone) return;

    _last = await ref
        .read(deckRepositoryProvider)
        .record(
          current.cards[current.position].id,
          action,
          ref.read(clockProvider)(),
        );
    state = AsyncData(
      current.copyWith(position: current.position + 1, canUndo: true),
    );
  }

  /// Takes back the last completed card (one level).
  Future<void> undo() async {
    final current = state.value;
    final last = _last;
    if (current == null || last == null || current.position == 0) return;

    await ref.read(deckRepositoryProvider).undo(last);
    _last = null;
    state = AsyncData(
      current.copyWith(position: current.position - 1, canUndo: false),
    );
  }
}
