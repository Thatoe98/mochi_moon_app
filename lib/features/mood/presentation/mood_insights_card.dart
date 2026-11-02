import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/mood/application/mood_providers.dart';
import 'package:mochi_moon/features/mood/domain/insights.dart';
import 'package:mochi_moon/features/mood/presentation/mood_labels.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';

/// Premium mood insights (PRD §6.18): a few gentle patterns from her own
/// check-ins, or an invitation when she is not Premium or has too few days.
class MoodInsightsCard extends ConsumerWidget {
  const MoodInsightsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final premium = ref.watch(hasPremiumProvider);
    final result = ref.watch(moodInsightsProvider);

    final String title;
    final List<String> lines;
    if (!premium) {
      title = l10n.moodInsightsPremiumTitle;
      lines = [l10n.moodInsightsPremiumBody];
    } else if (result == null) {
      return const SizedBox.shrink();
    } else if (!result.enoughData) {
      title = l10n.moodInsightsTitle;
      lines = [l10n.moodInsightsNotEnough(result.daysToGo)];
    } else if (result.insights.isEmpty) {
      title = l10n.moodInsightsTitle;
      lines = [l10n.moodInsightsNone];
    } else {
      title = l10n.moodInsightsTitle;
      lines = [
        for (final insight in result.insights) ...[
          switch (insight.kind) {
            MoodInsightKind.mostOften => l10n.moodInsightMostOften(
              insight.mood!.label(l10n),
              insight.count,
              insight.total,
            ),
            MoodInsightKind.ritualLift => l10n.moodInsightRitualLift,
          },
          switch (insight.kind) {
            MoodInsightKind.mostOften => l10n.moodInsightMostOftenStep,
            MoodInsightKind.ritualLift => l10n.moodInsightRitualLiftStep,
          },
        ],
      ];
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(title, style: theme.textTheme.titleMedium),
            ),
            for (final line in lines) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(line, style: theme.textTheme.bodyLarge),
            ],
            if (!premium)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: () => unawaited(
                    context.push('${AppRoutes.paywall}?source=mood_insights'),
                  ),
                  child: Text(l10n.paywallSeePremium),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
