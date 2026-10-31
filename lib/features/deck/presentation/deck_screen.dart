import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/deck/presentation/gated_card_deck.dart';
import 'package:mochi_moon/features/deck/presentation/share_quote.dart';
import 'package:mochi_moon/features/mood/application/mood_providers.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';
import 'package:mochi_moon/features/mood/presentation/mood_chips.dart';

/// The home tab: a swipe deck where each card stays locked until the timer
/// ring has filled (PRD §6.2).
class DeckScreen extends ConsumerStatefulWidget {
  const DeckScreen({super.key});

  @override
  ConsumerState<DeckScreen> createState() => _DeckScreenState();
}

class _DeckScreenState extends ConsumerState<DeckScreen>
    with WidgetsBindingObserver {
  /// Cards whose timer has finished, so an undone card stays unlocked even
  /// while the deck is off screen behind the limit card.
  final _read = <String>{};

  /// An undo from the limit card is in flight.
  bool _undoing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // A mood she already chose today shapes the deck; so does a new choice.
    ref.listenManual<Mood?>(todayMoodProvider, (_, mood) {
      if (mood != null) ref.read(deckProvider.notifier).applyMood(mood);
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// A new day may have started while the app was in the background.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(deckProvider.notifier).refreshIfNewDay();
    }
  }

  Future<void> _onAction(DeckAction action, Quote quote) async {
    await ref.read(deckProvider.notifier).complete(action);
    if (!mounted) return;
    if (action == DeckAction.shared) {
      // Not awaited: the card should fly off while the image renders.
      unawaited(shareQuote(context, ref, quote));
    }
  }

  Future<void> _undoFromLimitCard() async {
    setState(() => _undoing = true);
    await ref.read(deckProvider.notifier).undo();
    if (mounted) setState(() => _undoing = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final deck = ref.watch(deckProvider);

    // A new deal (a new day, or a retry) must not inherit unlocked cards: the
    // read-aloud timer applies again.
    ref.listen(deckProvider, (previous, next) {
      final before = previous?.value;
      final after = next.value;
      if (before != null &&
          after != null &&
          !identical(before.cards, after.cards)) {
        setState(_read.clear);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.deckTitle),
        actions: [
          if (deck.value case final state? when state.streak > 0)
            _StreakBadge(streak: state.streak),
        ],
      ),
      body: Column(
        children: [
          _MoodCheckIn(
            selected: ref.watch(todayMoodProvider),
            onSelected: (mood) => ref.read(setTodayMoodProvider)(mood),
          ),
          Expanded(
            child: deck.when(
              loading: () => const LoadingView(),
              error: (_, _) => ErrorView(
                onRetry: () {
                  ref
                    ..invalidate(quotesProvider)
                    ..invalidate(deckProvider);
                },
              ),
              data: _buildDeck,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeck(DeckState deck) {
    final l10n = AppLocalizations.of(context);

    if (deck.isDone) {
      if (deck.completedToday == 0) {
        return EmptyState(
          title: l10n.stateEmptyTitle,
          body: l10n.deckEmptyBody,
          illustration: AppIllustrations.emptyDeck,
          illustrationLabel: l10n.illustrationEmptyDeck,
        );
      }
      return _LimitCard(
        onUndo: deck.canUndo && !_undoing ? _undoFromLimitCard : null,
      );
    }

    return GatedCardDeck(
      cards: deck.cards,
      position: deck.position,
      canUndo: deck.canUndo,
      caption: l10n.deckCardsLeft(deck.remaining),
      readIds: _read,
      onRead: (id) => setState(() => _read.add(id)),
      onAction: _onAction,
      onUndo: ref.read(deckProvider.notifier).undo,
    );
  }
}

/// The optional mood check-in above the deck (PRD §6.2): one row she can
/// scroll sideways, so it never takes much room.
class _MoodCheckIn extends StatelessWidget {
  const _MoodCheckIn({required this.selected, required this.onSelected});

  final Mood? selected;
  final ValueChanged<Mood> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.moodCheckInTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          MoodChips(
            selected: selected,
            onSelected: onSelected,
            scrollable: true,
          ),
        ],
      ),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  const _StreakBadge({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: AppLocalizations.of(context).deckStreakSemantics(streak),
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.md),
        child: Row(
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              size: AppSpacing.lg,
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text('$streak', style: theme.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

/// Shown once the day's cards are done.
class _LimitCard extends StatelessWidget {
  const _LimitCard({required this.onUndo});

  final VoidCallback? onUndo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Expanded(
          child: EmptyState(
            title: l10n.deckLimitTitle,
            body: l10n.deckLimitBody,
            illustration: AppIllustrations.emptyDeck,
            illustrationLabel: l10n.illustrationEmptyDeck,
          ),
        ),
        TextButton.icon(
          onPressed: onUndo,
          icon: const Icon(Icons.undo_rounded),
          label: Text(l10n.deckActionUndo),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
