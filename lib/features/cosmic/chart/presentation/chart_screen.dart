import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/chart/application/chart_providers.dart';
import 'package:mochi_moon/features/cosmic/chart/presentation/aspects_list.dart';
import 'package:mochi_moon/features/cosmic/chart/presentation/big_three_card.dart';
import 'package:mochi_moon/features/cosmic/chart/presentation/chart_labels.dart';
import 'package:mochi_moon/features/cosmic/chart/presentation/chart_wheel.dart';
import 'package:mochi_moon/features/cosmic/chart/presentation/placements_list.dart';
import 'package:mochi_moon/features/cosmic/report/presentation/full_reading_card.dart';
import 'package:mochi_moon/features/cosmic/unlock/presentation/cosmic_locked_view.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';

/// The birth chart: the Big 3 and every placement (PRD §6.11).
class ChartScreen extends ConsumerWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final chart = ref.watch(natalChartProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.chartTitle)),
      body: chart.when(
        loading: () => const LoadingView(),
        error: (error, stack) =>
            ErrorView(onRetry: () => ref.invalidate(natalChartProvider)),
        data: (data) => data == null
            ? CosmicLockedView(
                title: l10n.chartNeedsBirthDateTitle,
                body: l10n.chartNeedsBirthDateBody,
              )
            : _ChartView(chart: data),
      ),
    );
  }
}

class _ChartView extends ConsumerWidget {
  const _ChartView({required this.chart});

  final NatalChart chart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final rising = chart.ascendantSign;
    final premium = ref.watch(hasPremiumProvider);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        if (!chart.timeKnown) const _NoTimeBanner(),
        ChartWheel(chart: chart, showAspects: premium),
        const SizedBox(height: AppSpacing.md),
        Semantics(
          header: true,
          child: Text(
            l10n.chartBigThreeTitle,
            style: theme.textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        BigThreeCard(
          role: BigThreeRole.sun,
          sign: chart.placementOf(Body.sun).sign,
        ),
        BigThreeCard(
          role: BigThreeRole.moon,
          sign: chart.placementOf(Body.moon).sign,
          approximate: chart.moonIsApproximate,
        ),
        if (rising != null)
          BigThreeCard(role: BigThreeRole.rising, sign: rising),
        if (chart.risingMayBeUnreliable)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(
              l10n.chartHighLatitudeNote,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        PlacementsList(chart: chart, detailed: premium),
        AspectsList(chart: chart, locked: !premium),
        FullReadingCard(locked: !premium),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Text(
            l10n.cosmicDisclaimer,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

/// Invites the user to add the birth time, which unlocks Rising and houses.
class _NoTimeBanner extends StatelessWidget {
  const _NoTimeBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: colors.secondaryContainer,
        borderRadius: AppRadii.cardRadius,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.chartNoTimeTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.onSecondaryContainer,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.chartNoTimeBody,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
