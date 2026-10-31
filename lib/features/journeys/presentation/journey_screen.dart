import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/content/journey.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/journeys/application/journey_providers.dart';
import 'package:mochi_moon/features/journeys/domain/journey_progress.dart';
import 'package:mochi_moon/features/journeys/presentation/share_journey.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';

/// One journey (PRD §6.21): what it is, where she is (day n of N) and the
/// button for today's day. A missed day only waits; nothing resets.
class JourneyScreen extends ConsumerWidget {
  const JourneyScreen({required this.journeyId, super.key});

  final String journeyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final journey = ref.watch(journeyByIdProvider(journeyId));
    return Scaffold(
      appBar: AppBar(),
      body: journey.when(
        loading: () => const LoadingView(),
        error: (_, _) => ErrorView(
          onRetry: () => ref.invalidate(journeyByIdProvider(journeyId)),
        ),
        data: (journey) => journey == null
            ? EmptyState(title: l10n.journeyNotFound)
            : _Body(journey: journey),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.journey});

  final Journey journey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final runs = ref.watch(journeyProgressListProvider).value ?? const [];
    final premium = ref.watch(hasPremiumProvider);
    final now = ref.watch(clockProvider)();

    JourneyProgress? run;
    for (final candidate in runs) {
      if (candidate.journeyId == journey.id) run = candidate;
    }
    final other = activeJourney(runs);
    final otherRunning = other != null && other.journeyId != journey.id;
    final locked = journey.premium && !premium;

    final Widget action;
    if (locked) {
      action = Text(l10n.journeyLockedNote, style: theme.textTheme.bodyLarge);
    } else if (run != null && run.isFinished) {
      action = _Finished(journey: journey);
    } else if (run != null) {
      action = run.canCompleteDay(now)
          ? FilledButton(
              onPressed: () => context.push(
                '${AppRoutes.journeys}/${Uri.encodeComponent(journey.id)}/day',
              ),
              child: Text(l10n.journeyContinue(run.currentDay)),
            )
          : Text(l10n.journeyDoneToday, style: theme.textTheme.bodyLarge);
    } else if (otherRunning) {
      action = Text(l10n.journeyOtherRunning, style: theme.textTheme.bodyLarge);
    } else {
      action = FilledButton(
        onPressed: () async {
          await ref.read(startJourneyActionProvider)(journey.id);
          if (!context.mounted) return;
          await context.push(
            '${AppRoutes.journeys}/${Uri.encodeComponent(journey.id)}/day',
          );
        },
        child: Text(l10n.journeyStart),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(journey.titleFor(lang), style: theme.textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.sm),
        Text(journey.summaryFor(lang), style: theme.textTheme.bodyLarge),
        const SizedBox(height: AppSpacing.md),
        if (run != null && !run.isFinished) ...[
          Text(
            l10n.journeyProgressLabel(run.currentDay, journey.days),
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.button),
            child: LinearProgressIndicator(
              value: run.completedDays.length / journey.days,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (run.canCompleteDay(now))
            Text(l10n.journeyWaitsNote, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
        ],
        action,
      ],
    );
  }
}

class _Finished extends ConsumerWidget {
  const _Finished({required this.journey});

  final Journey journey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final title = journey.titleFor(lang);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.journeyCompleteTitle(title),
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(l10n.journeyCompleteBody, style: theme.textTheme.bodyLarge),
        const SizedBox(height: AppSpacing.md),
        FilledButton.icon(
          onPressed: () => shareJourneyComplete(context, ref, title),
          icon: const Icon(Icons.ios_share_rounded),
          label: Text(l10n.journeyShare),
        ),
      ],
    );
  }
}
