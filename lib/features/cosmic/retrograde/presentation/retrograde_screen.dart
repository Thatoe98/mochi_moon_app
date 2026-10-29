import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/retrogrades.dart';
import 'package:mochi_moon/features/cosmic/retrograde/application/retrograde_providers.dart';
import 'package:mochi_moon/features/cosmic/retrograde/domain/retrograde_status.dart';
import 'package:mochi_moon/features/cosmic/retrograde/presentation/retrograde_labels.dart';
import 'package:mochi_moon/features/cosmic/retrograde/presentation/retrograde_timeline.dart';

/// Retrograde status, timeline and tips for each planet (PRD §6.8).
class RetrogradeScreen extends ConsumerWidget {
  const RetrogradeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final overview = ref.watch(retrogradeOverviewProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.retroTitle)),
      body: overview.when(
        loading: () => const LoadingView(),
        error: (error, stack) => ErrorView(
          onRetry: () => ref.invalidate(retrogradeOverviewProvider),
        ),
        data: (data) => _Overview(overview: data),
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({required this.overview});

  final RetrogradeOverview overview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    const more = [Body.jupiter, Body.saturn];
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        const _Legend(),
        const SizedBox(height: AppSpacing.sm),
        Text(l10n.retroShadowNote, style: theme.textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.md),
        for (final body in mainRetrogradeBodies)
          _PlanetCard(body: body, overview: overview),
        Theme(
          data: theme.copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(l10n.retroMore, style: theme.textTheme.titleMedium),
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.only(top: AppSpacing.sm),
            children: [
              for (final body in more)
                _PlanetCard(body: body, overview: overview),
            ],
          ),
        ),
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

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = RetrogradePalette(Theme.of(context).colorScheme);
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xs,
      children: [
        _LegendItem(color: palette.shadow, label: l10n.retroLegendPreShadow),
        _LegendItem(
          color: palette.retrograde,
          label: l10n.retroLegendRetrograde,
        ),
        _LegendItem(color: palette.shadow, label: l10n.retroLegendPostShadow),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadii.chipRadius,
          ),
          child: const SizedBox.square(dimension: AppSpacing.md),
        ),
      ),
      const SizedBox(width: AppSpacing.xs),
      Text(label, style: Theme.of(context).textTheme.bodyMedium),
    ],
  );
}

class _PlanetCard extends StatelessWidget {
  const _PlanetCard({required this.body, required this.overview});

  final Body body;
  final RetrogradeOverview overview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMd(
      Localizations.localeOf(context).toString(),
    );
    final yearFormat = DateFormat.y(Localizations.localeOf(context).toString());
    final periods = overview.of(body);
    final status = retrogradeStatus(body, overview.now, periods);
    final statusText = status == null
        ? null
        : retrogradeStatusText(context, body, status);
    final year = overview.now.year;

    String date(DateTime utc) => dateFormat.format(utc.toLocal());

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  retrogradePlanetLabel(l10n, body),
                  style: theme.textTheme.titleLarge,
                ),
              ),
              if (statusText != null) ...[
                Text(statusText.$1, style: theme.textTheme.titleMedium),
                if (statusText.$2 case final countdown?)
                  Text(countdown, style: theme.textTheme.bodyMedium),
              ],
              const SizedBox(height: AppSpacing.md),
              if (periods.isEmpty)
                Text(l10n.retroNoneThisYear, style: theme.textTheme.bodyLarge)
              else ...[
                for (final y in [year, year + 1]) ...[
                  Text(
                    l10n.retroYearHeader(yearFormat.format(DateTime(y))),
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  RetrogradeTimeline(
                    year: y,
                    periods: periods,
                    now: overview.now,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                for (final period in periods)
                  _PeriodText(period: period, date: date),
              ],
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.retroTipsTitle, style: theme.textTheme.labelLarge),
              Text(retrogradeTip(l10n, body), style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}

/// One retrograde's dates, and the shadow span around them, as text.
class _PeriodText extends StatelessWidget {
  const _PeriodText({required this.period, required this.date});

  final RetrogradePeriod period;
  final String Function(DateTime utc) date;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.retroPeriodRetrograde(
              date(period.retrogradeStart),
              date(period.retrogradeEnd),
            ),
            style: theme.textTheme.bodyLarge,
          ),
          Text(
            l10n.retroPeriodShadows(
              date(period.preShadowStart),
              date(period.postShadowEnd),
            ),
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
