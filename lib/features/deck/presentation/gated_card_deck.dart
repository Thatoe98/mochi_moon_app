import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/sparkle.dart';
import 'package:mochi_moon/core/widgets/timer_ring.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/deck/domain/read_aloud_gate.dart';
import 'package:mochi_moon/features/deck/presentation/category_label.dart';
import 'package:mochi_moon/features/deck/presentation/quote_card.dart';

/// A swipe deck whose top card stays locked until its read-aloud timer ring
/// has filled (PRD §6.2). The daily deck and the sample cards shown before
/// sign-in both use it, so the gate is the same everywhere.
///
/// The widget owns the swiper and the in-flight state. The caller owns the
/// deck: which [cards] there are, how far along it is ([position]) and which
/// cards were already read ([readIds], so an undone card stays unlocked).
class GatedCardDeck extends StatefulWidget {
  const GatedCardDeck({
    required this.cards,
    required this.position,
    required this.canUndo,
    required this.caption,
    required this.readIds,
    required this.onRead,
    required this.onAction,
    required this.onUndo,
    this.allowShare = true,
    super.key,
  });

  final List<Quote> cards;

  /// How many of [cards] are done; the card at this index is on top.
  final int position;

  final bool canUndo;

  /// Line above the deck, such as how many cards are left.
  final String caption;

  /// Ids of the cards whose timer has finished.
  final Set<String> readIds;

  /// A card's timer finished.
  final ValueChanged<String> onRead;

  /// An unlocked card was swiped (or its button pressed). Completes when the
  /// card has been recorded.
  final Future<void> Function(DeckAction action, Quote quote) onAction;

  /// The undo button was pressed. Completes when the card was taken back.
  final Future<void> Function() onUndo;

  /// Whether swiping up (and the share button) is offered.
  final bool allowShare;

  @override
  State<GatedCardDeck> createState() => _GatedCardDeckState();
}

class _GatedCardDeckState extends State<GatedCardDeck> {
  final _controller = CardSwiperController();

  /// A button-triggered swipe or an undo is in flight.
  bool _busy = false;

  late final AllowedSwipeDirection _swipeDirections =
      AllowedSwipeDirection.only(
        left: true,
        right: true,
        up: widget.allowShare,
      );

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  void _unlock(String id) {
    unawaited(HapticFeedback.lightImpact());
    widget.onRead(id);
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
      CardSwiperDirection.top when widget.allowShare => DeckAction.shared,
      _ => null,
    };

    // Backstop for the gate: refuse anything that is not an unlocked card.
    var accepted = false;
    if (action != null && widget.position < widget.cards.length) {
      final swiped = widget.cards[widget.position];
      if (widget.readIds.contains(swiped.id)) {
        await widget.onAction(action, swiped);
        accepted = true;
      }
    }
    if (mounted) setState(() => _busy = false);
    return accepted;
  }

  Future<void> _undo() async {
    setState(() => _busy = true);
    await widget.onUndo();
    if (!mounted) return;
    setState(() => _busy = false);
    _controller.undo();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final cards = widget.cards;
    final current = cards[widget.position];
    final unlocked = widget.readIds.contains(current.id);
    final canAct = unlocked && !_busy;

    return Column(
      children: [
        Text(widget.caption, style: Theme.of(context).textTheme.bodyMedium),
        Expanded(
          child: CardSwiper(
            // A rebuilt deck is a new card list, so start a fresh swiper.
            key: ObjectKey(cards),
            controller: _controller,
            cardsCount: cards.length,
            initialIndex: widget.position,
            numberOfCardsDisplayed: math.min(2, cards.length),
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
              final quote = cards[index];
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
          onUndo: widget.canUndo && !_busy ? _undo : null,
          onSkip: canAct
              ? () => _swipeWithButton(CardSwiperDirection.left)
              : null,
          onShare: widget.allowShare && canAct
              ? () => _swipeWithButton(CardSwiperDirection.top)
              : null,
          onSave: canAct
              ? () => _swipeWithButton(CardSwiperDirection.right)
              : null,
          showShare: widget.allowShare,
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
    required this.showShare,
  });

  final VoidCallback? onUndo;
  final VoidCallback? onSkip;
  final VoidCallback? onShare;
  final VoidCallback? onSave;
  final bool showShare;

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
        if (showShare) ...[
          const SizedBox(width: AppSpacing.sm),
          IconButton.filledTonal(
            tooltip: l10n.deckActionShare,
            onPressed: onShare,
            icon: const Icon(Icons.ios_share_rounded),
          ),
        ],
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
