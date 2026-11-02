import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/premium_preview.dart';
import 'package:mochi_moon/features/cosmic/astro/aspects.dart';
import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/chart/presentation/chart_labels.dart';

/// How many aspects the list shows: the tightest ones, which matter most.
const int maxAspectsShown = 10;

/// A plain-language list of the chart's strongest aspects (PRD 6.11). Premium;
/// when [locked] the same list shows as a soft preview.
class AspectsList extends StatelessWidget {
  const AspectsList({required this.chart, required this.locked, super.key});

  final NatalChart chart;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final aspects = natalAspects(chart).take(maxAspectsShown).toList();
    if (aspects.isEmpty) return const SizedBox.shrink();

    final rows = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final aspect in aspects)
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSpacing.minTouchTarget,
            ),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                l10n.chartAspectRow(
                  bodyLabel(l10n, aspect.a),
                  _kind(l10n, aspect.type),
                  bodyLabel(l10n, aspect.b),
                ),
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ),
      ],
    );

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
                  l10n.chartAspectsTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (locked)
                PremiumPreview(
                  source: 'chart_details',
                  semanticLabel: l10n.chartAspectsTitle,
                  child: IgnorePointer(child: rows),
                )
              else
                rows,
            ],
          ),
        ),
      ),
    );
  }

  String _kind(AppLocalizations l10n, AspectType type) => switch (type) {
    AspectType.conjunction => l10n.chartAspectConjunction,
    AspectType.sextile => l10n.chartAspectSextile,
    AspectType.trine => l10n.chartAspectTrine,
    AspectType.square => l10n.chartAspectSquare,
    AspectType.opposition => l10n.chartAspectOpposition,
  };
}
