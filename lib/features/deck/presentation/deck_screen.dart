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

/// The home tab: a swipe deck where each card stays locked until the timer
/// ring has filled (PRD §6.2).
class DeckScreen extends ConsumerStatefulWidget {
  const DeckScreen({super.key});

  @override
  ConsumerState<DeckScreen> createState() => _DeckScreenState();
}

class _DeckScreenState extends ConsumerState<DeckScreen> {
  /// Cards whose timer has finished, so an undone card stays unlocked even
  /// while the deck is off screen behind the limit card.
  final _read = <String>{};

  /// An undo from the limit card is in flight.
  bool _undoing = false;

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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.deckTitle),
        actions: [
          if (deck.value case final state? when state.streak > 0)
            _StreakBadge(streak: state.streak),
        ],
      ),
      body: deck.when(
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
