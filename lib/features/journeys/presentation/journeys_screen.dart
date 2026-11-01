import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/journey.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/journeys/application/journey_providers.dart';
import 'package:mochi_moon/features/journeys/domain/journey_progress.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';

/// Me → Journeys (PRD §6.21): the list of journeys. One is free, the rest are
/// Premium; she runs one at a time.
class JourneysScreen extends ConsumerWidget {
  const JourneysScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final journeys = ref.watch(journeysProvider);
    final runs = ref.watch(journeyProgressListProvider).value ?? const [];
    final premium = ref.watch(hasPremiumProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.journeysTitle)),
      body: journeys.when(
        loading: () => const LoadingView(),
        error: (_, _) =>
            ErrorView(onRetry: () => ref.invalidate(journeysProvider)),
        data: (all) => ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Text(
              l10n.journeysIntro,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            for (final journey in all)
              _JourneyTile(
                journey: journey,
                run: _runOf(runs, journey.id),
                locked: journey.premium && !premium,
              ),
          ],
        ),
      ),
    );
  }
}

JourneyProgress? _runOf(List<JourneyProgress> runs, String id) {
  for (final run in runs) {
    if (run.journeyId == id) return run;
  }
  return null;
}

class _JourneyTile extends StatelessWidget {
  const _JourneyTile({
    required this.journey,
    required this.run,
    required this.locked,
  });

  final Journey journey;
  final JourneyProgress? run;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final status = switch (run) {
      null => null,
      final run when run.isFinished => l10n.journeyFinishedTag,
      _ => l10n.journeyInProgressTag,
    };
    final tag = locked
        ? l10n.journeyPremiumTag
        : journey.premium
        ? l10n.journeyPremiumTag
        : l10n.journeyFreeTag;
    final cover = AppIllustrations.forJourney(journey.illustrationId);
    return Card(
      child: ListTile(
        minTileHeight: AppSpacing.minTouchTarget,
        leading: cover != null && !locked
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: MochiIllustration(
                    asset: cover,
                    semanticLabel: journey.titleFor(lang),
                  ),
                ),
              )
            : Icon(locked ? Icons.lock_rounded : Icons.route_rounded),
        title: Text(journey.titleFor(lang)),
        subtitle: Text(
          [
            journey.summaryFor(lang),
            '${l10n.journeyDaysCount(journey.days)} · ${status ?? tag}',
          ].join('\n'),
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => context.push(
          '${AppRoutes.journeys}/${Uri.encodeComponent(journey.id)}',
        ),
      ),
    );
  }
}
