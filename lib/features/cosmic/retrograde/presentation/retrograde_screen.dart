import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/retrograde/application/retrograde_providers.dart';
import 'package:mochi_moon/features/cosmic/retrograde/domain/retrograde_status.dart';
import 'package:mochi_moon/features/cosmic/retrograde/presentation/retrograde_alerts_section.dart';
import 'package:mochi_moon/features/cosmic/retrograde/presentation/retrograde_calendar.dart';
import 'package:mochi_moon/features/cosmic/retrograde/presentation/retrograde_labels.dart';

/// Which planets are retrograde now, with gentle tips for them, then a month
/// calendar for what is coming and the switches for heads-up notifications
/// (PRD §6.8).
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
          onRetry: () => ref
            ..invalidate(retrogradePeriodsProvider)
            ..invalidate(retrogradeOverviewProvider),
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
    final current = overview.retrogradeNow;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Semantics(
          header: true,
          child: Text(l10n.retroNowTitle, style: theme.textTheme.titleLarge),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (current.isEmpty)
          const _AllForwardCard()
        else
          for (final body in current)
            _GentleTipsCard(body: body, overview: overview),
        const SizedBox(height: AppSpacing.md),
        RetrogradeCalendar(overview: overview),
        const SizedBox(height: AppSpacing.sm),
        const RetrogradeAlertsSection(),
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

/// Shown when no planet is retrograde.
class _AllForwardCard extends StatelessWidget {
  const _AllForwardCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            ExcludeSemantics(
              child: Icon(
                Icons.nightlight_round,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.retroCalmTitle, style: theme.textTheme.titleMedium),
                  Text(l10n.retroCalmBody, style: theme.textTheme.bodyLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A planet that is retrograde now. The tips are the point of the card, so
/// they get the room and the larger type; the date is one short line.
class _GentleTipsCard extends StatelessWidget {
  const _GentleTipsCard({required this.body, required this.overview});

  final Body body;
  final RetrogradeOverview overview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final status = retrogradeStatus(body, overview.now, overview.of(body));
    final statusText = status == null
        ? null
        : retrogradeStatusText(context, body, status).$1;

    return Card(
      color: theme.colorScheme.primaryContainer,
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
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              if (statusText != null)
                Text(statusText, style: theme.textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.md),
              Text(l10n.retroTipsTitle, style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(retrogradeTip(l10n, body), style: theme.textTheme.bodyLarge),
              const SizedBox(height: AppSpacing.sm),
              for (final tip in retrogradeTips(l10n, body))
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExcludeSemantics(
                        child: Icon(
                          Icons.favorite_rounded,
                          size: AppSpacing.md,
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(tip, style: theme.textTheme.bodyLarge),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
