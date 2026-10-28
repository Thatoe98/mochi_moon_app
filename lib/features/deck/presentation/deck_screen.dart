import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/sparkle.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/core/widgets/timer_ring.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/deck/domain/read_aloud_gate.dart';
import 'package:mochi_moon/features/deck/presentation/category_label.dart';
import 'package:mochi_moon/features/deck/presentation/quote_card.dart';
import 'package:mochi_moon/features/deck/presentation/share_quote.dart';

/// The home tab: a swipe deck where each card stays locked until the timer
/// ring has filled (PRD §6.2).
class DeckScreen extends ConsumerStatefulWidget {
  const DeckScreen({super.key});

  @override
  ConsumerState<DeckScreen> createState() => _DeckScreenState();
}

class _DeckScreenState extends ConsumerState<DeckScreen> {
  static const _swipeDirections = AllowedSwipeDirection.only(
    left: true,
    right: true,
    up: true,
  );

  final _controller = CardSwiperController();

  /// Cards whose timer has finished, so an undone card stays unlocked.
  final _read = <String>{};

  /// A button-triggered swipe is in flight.
  bool _busy = false;

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  void _unlock(String id) {
    unawaited(HapticFeedback.lightImpact());
    setState(() => _read.add(id));
  }

  void _swipeWithButton(CardSwiperDirection direction) {
    setState(() => _busy = true);
    _controller.swipe(direction);
  }

  Future<bool> _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) async {
    final action = switch (direction) {
      CardSwiperDirection.right => DeckAction.saved,
      CardSwiperDirection.left => DeckAction.skipped,
      CardSwiperDirection.top => DeckAction.shared,
      _ => null,
    };
    final deck = ref.read(deckProvider).value;

    // Backstop for the gate: refuse anything that is not an unlocked card.
    var accepted = false;
    Quote? swiped;
    if (action != null && deck != null && !deck.isDone) {
      swiped = deck.cards[deck.position];
      if (_read.contains(swiped.id)) {
        await ref.read(deckProvider.notifier).complete(action);
        accepted = true;
      }
    }
    if (!mounted) return accepted;
    setState(() => _busy = false);
    if (accepted && action == DeckAction.shared) {
      // Not awaited: the card should fly off while the image renders.
      unawaited(shareQuote(context, ref, swiped!));
    }
    return accepted;
  }

  Future<void> _undo({required bool swiperMounted}) async {
    setState(() => _busy = true);
    await ref.read(deckProvider.notifier).undo();
    if (!mounted) return;
    setState(() => _busy = false);
    if (swiperMounted) _controller.undo();
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
        );
      }
      return _LimitCard(
        onUndo: deck.canUndo && !_busy
            ? () => _undo(swiperMounted: false)
            : null,
      );
    }

    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final current = deck.cards[deck.position];
    final unlocked = _read.contains(current.id);
    final canAct = unlocked && !_busy;

    return Column(
      children: [
        Text(
          l10n.deckCardsLeft(deck.remaining),
          style: theme.textTheme.bodyMedium,
        ),
        Expanded(
          child: CardSwiper(
            // A rebuilt deck is a new card list, so start a fresh swiper.
            key: ObjectKey(deck.cards),
            controller: _controller,
            cardsCount: deck.cards.length,
            initialIndex: deck.position,
            numberOfCardsDisplayed: math.min(2, deck.cards.length),
            isLoop: false,
            // While locked the card cannot be dragged at all.
            isDisabled: !unlocked,
            allowedSwipeDirection: _swipeDirections,
            maxAngle: reduceMotion ? 0 : 30,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.xl,
            ),
            backCardOffset: const Offset(0, AppSpacing.lg),
            onSwipe: _onSwipe,
            onUndo: (_, _, _) => true,
            cardBuilder: (context, index, _, _) {
              final quote = deck.cards[index];
              return QuoteCard(
                text: quote.textFor(lang),
                categoryLabel: categoryLabel(l10n, quote.category),
              );
            },
          ),
        ),
        _TimerArea(
          key: ValueKey(current.id),
          duration: readAloudLockDuration(current.textFor(lang)),
          unlocked: unlocked,
          onUnlocked: () => _unlock(current.id),
        ),
        const SizedBox(height: AppSpacing.md),
        _ActionBar(
          onUndo: deck.canUndo && !_busy
              ? () => _undo(swiperMounted: true)
              : null,
          onSkip: canAct
              ? () => _swipeWithButton(CardSwiperDirection.left)
              : null,
          onShare: canAct
              ? () => _swipeWithButton(CardSwiperDirection.top)
              : null,
          onSave: canAct
              ? () => _swipeWithButton(CardSwiperDirection.right)
              : null,
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

/// The ring and its hint for one card. Give it the card's key: a new card
/// starts a new timer, and a card that was already read mounts full and quiet.
class _TimerArea extends StatefulWidget {
  const _TimerArea({
    required this.duration,
    required this.unlocked,
    required this.onUnlocked,
    super.key,
  });

  final Duration duration;
  final bool unlocked;
  final VoidCallback onUnlocked;

  @override
  State<_TimerArea> createState() => _TimerAreaState();
}

class _TimerAreaState extends State<_TimerArea> {
  late final bool _wasUnlockedOnMount = widget.unlocked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unlocked = widget.unlocked;
    // Only a timer that finished while on screen celebrates.
    final sparkle = unlocked && !_wasUnlockedOnMount;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            TimerRing(
              duration: widget.duration,
              completed: _wasUnlockedOnMount,
              onCompleted: widget.onUnlocked,
            ),
            if (sparkle)
              const Positioned(
                left: -AppSpacing.xl,
                top: -AppSpacing.xl,
                right: -AppSpacing.xl,
                bottom: -AppSpacing.xl,
                child: Sparkle(),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          unlocked ? l10n.deckTimerReady : l10n.readAloudHint,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.onUndo,
    required this.onSkip,
    required this.onShare,
    required this.onSave,
  });

  final VoidCallback? onUndo;
  final VoidCallback? onSkip;
  final VoidCallback? onShare;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          tooltip: l10n.deckActionUndo,
          onPressed: onUndo,
          icon: const Icon(Icons.undo_rounded),
        ),
        const SizedBox(width: AppSpacing.sm),
        IconButton.filledTonal(
          tooltip: l10n.deckActionSkip,
          onPressed: onSkip,
          icon: const Icon(Icons.close_rounded),
        ),
        const SizedBox(width: AppSpacing.sm),
        IconButton.filledTonal(
          tooltip: l10n.deckActionShare,
          onPressed: onShare,
          icon: const Icon(Icons.ios_share_rounded),
        ),
        const SizedBox(width: AppSpacing.sm),
        IconButton.filled(
          tooltip: l10n.deckActionSave,
          onPressed: onSave,
          icon: const Icon(Icons.favorite_rounded),
        ),
      ],
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
