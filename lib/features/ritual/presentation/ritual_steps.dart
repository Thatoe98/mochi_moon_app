import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';
import 'package:mochi_moon/core/widgets/sparkle.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/deck/presentation/gated_card_deck.dart';
import 'package:mochi_moon/features/deck/presentation/share_quote.dart';
import 'package:mochi_moon/features/mood/application/mood_providers.dart';
import 'package:mochi_moon/features/mood/presentation/mood_chips.dart';
import 'package:mochi_moon/features/ritual/application/ritual_providers.dart';
import 'package:mochi_moon/features/ritual/domain/ritual_state.dart';

/// "Step n of 4" with a soft bar, shown above every step of the ritual.
class RitualProgressHeader extends StatelessWidget {
  const RitualProgressHeader({required this.step, super.key});

  final int step;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.ritualStepOf(step, ritualStepCount),
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.button),
            child: LinearProgressIndicator(value: step / ritualStepCount),
          ),
        ],
      ),
    );
  }
}

/// Before the ritual is started: a gentle invitation.
class RitualIntro extends StatelessWidget {
  const RitualIntro({
    required this.streak,
    required this.onStart,
    required this.onBrowseDeck,
    super.key,
  });

  final int streak;
  final VoidCallback onStart;
  final VoidCallback onBrowseDeck;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyState(
      title: streak > 0 ? l10n.todayStreak(streak) : l10n.todayNoStreak,
      body: l10n.ritualIntroBody,
      illustration: AppIllustrations.emptyDeck,
      illustrationLabel: l10n.illustrationEmptyDeck,
      action: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilledButton(onPressed: onStart, child: Text(l10n.ritualStart)),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: onBrowseDeck,
            child: Text(l10n.ritualBrowseDeck),
          ),
        ],
      ),
    );
  }
}

/// Step 1: how she feels. Skipping stores nothing.
class RitualMoodStep extends ConsumerWidget {
  const RitualMoodStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(todayMoodProvider);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.moodCheckInTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        MoodChips(
          selected: selected,
          onSelected: (mood) => ref.read(setTodayMoodProvider)(mood),
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton(
          onPressed: () =>
              ref.read(ritualControllerProvider.notifier).finishMood(),
          child: Text(selected == null ? l10n.ritualSkip : l10n.ritualNext),
        ),
      ],
    );
  }
}

/// Step 2: the three ritual cards, locked by the same read-aloud timer as
/// the deck.
class RitualCardsStep extends ConsumerStatefulWidget {
  const RitualCardsStep({required this.ritual, super.key});

  final RitualState ritual;

  @override
  ConsumerState<RitualCardsStep> createState() => _RitualCardsStepState();
}

class _RitualCardsStepState extends ConsumerState<RitualCardsStep> {
  /// Cards whose timer has finished.
  final _read = <String>{};

  Future<void> _onAction(DeckAction action, Quote quote) async {
    await ref.read(ritualControllerProvider.notifier).completeCard(action);
    if (!mounted) return;
    if (action == DeckAction.shared) {
      // Not awaited: the card should fly off while the image renders.
      unawaited(shareQuote(context, ref, quote));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ritual = widget.ritual;
    return GatedCardDeck(
      cards: ritual.cards,
      position: ritual.position,
      canUndo: false,
      caption: AppLocalizations.of(context)
          .ritualCardsLeft(ritual.cards.length - ritual.position),
      readIds: _read,
      onRead: (id) => setState(() => _read.add(id)),
      onAction: _onAction,
      onUndo: () async {},
    );
  }
}

/// Step 3: one grateful thought. Writing it down arrives with the gratitude
/// jar; until then this is a quiet moment.
class RitualGratitudeStep extends ConsumerWidget {
  const RitualGratitudeStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.ritualGratitudeTitle,
            style: theme.textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(l10n.ritualGratitudeBody, style: theme.textTheme.bodyLarge),
        const SizedBox(height: AppSpacing.lg),
        FilledButton(
          onPressed: () =>
              ref.read(ritualControllerProvider.notifier).finishGratitude(),
          child: Text(l10n.ritualFinish),
        ),
      ],
    );
  }
}

/// Step 4: the celebration. A still star stays when reduce motion is on; the
/// sparkle plays only otherwise.
class RitualFinished extends StatelessWidget {
  const RitualFinished({required this.streak, this.reward, super.key});

  final int streak;

  /// The cosmic reward card, shown under the celebration.
  final Widget? reward;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Stack(
      children: [
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Semantics(
                  label: l10n.ritualDoneSemantics,
                  child: ExcludeSemantics(
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      size: AppSpacing.xxl,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Semantics(
                  header: true,
                  child: Text(
                    l10n.ritualDoneTitle,
                    style: theme.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                if (streak > 0) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.todayStreak(streak),
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.ritualDoneBody,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                if (reward != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  reward!,
                ],
              ],
            ),
          ),
        ),
        const Positioned.fill(child: Sparkle()),
      ],
    );
  }
}
