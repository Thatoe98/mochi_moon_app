import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/hard_day/presentation/hard_day_screen.dart';
import 'package:mochi_moon/features/ritual/application/ritual_providers.dart';
import 'package:mochi_moon/features/ritual/domain/ritual_state.dart';
import 'package:mochi_moon/features/ritual/presentation/cosmic_reward_card.dart';
import 'package:mochi_moon/features/ritual/presentation/ritual_steps.dart';

/// The home tab (PRD §5, §6.15): today's 2-minute self-love ritual. It shows
/// where she is: not started, step n of 4, or done.
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ritual = ref.watch(ritualControllerProvider);
    final streak = ref.watch(deckProvider.select((d) => d.value?.streak)) ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.todayTitle),
        actions: [
          const HardDayButton(source: 'today'),
          IconButton(
            tooltip: l10n.breatheTitle,
            icon: const Icon(Icons.self_improvement_rounded),
            onPressed: () => context.push(AppRoutes.breathe),
          ),
        ],
      ),
      body: ritual.when(
        loading: () => const LoadingView(),
        error: (_, _) =>
            ErrorView(onRetry: () => ref.invalidate(ritualControllerProvider)),
        data: (state) => switch (state.phase) {
          RitualPhase.notStarted => RitualIntro(
            streak: streak,
            onStart: ref.read(ritualControllerProvider.notifier).start,
            onBrowseDeck: () => context.go(AppRoutes.deck),
          ),
          RitualPhase.finished => RitualFinished(
            streak: streak,
            reward: const CosmicRewardCard(),
          ),
          _ => Column(
            children: [
              RitualProgressHeader(step: state.phase.stepNumber!),
              Expanded(child: _step(state)),
            ],
          ),
        },
      ),
    );
  }

  Widget _step(RitualState state) => switch (state.phase) {
    RitualPhase.mood => const RitualMoodStep(),
    RitualPhase.cards => RitualCardsStep(ritual: state),
    RitualPhase.gratitude => const RitualGratitudeStep(),
    RitualPhase.notStarted || RitualPhase.finished => const SizedBox.shrink(),
  };
}
