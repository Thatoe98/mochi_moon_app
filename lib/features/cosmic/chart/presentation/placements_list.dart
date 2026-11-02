import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/premium_preview.dart';
import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';
import 'package:mochi_moon/features/cosmic/chart/presentation/chart_glyphs.dart';
import 'package:mochi_moon/features/cosmic/chart/presentation/chart_labels.dart';
import 'package:mochi_moon/features/cosmic/presentation/zodiac_labels.dart';

/// Every placement of the chart, one row each: glyph, sign, degree, house and
/// Rx when retrograde. The Ascendant and Midheaven follow when the birth time
/// is known (PRD §6.11).
class PlacementsList extends StatelessWidget {
  const PlacementsList({required this.chart, this.detailed = true, super.key});

  final NatalChart chart;

  /// Degrees and houses are Premium (PRD 6.11). Without them the rows show
  /// the sign only, with a soft preview of what Premium adds.
  final bool detailed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ascendant = chart.ascendant;
    final midheaven = chart.midheaven;
    final rows = <Widget>[
      for (final placement in chart.placements)
        _PlacementRow(
          glyph: bodyGlyph(placement.body),
          name: bodyLabel(l10n, placement.body),
          sign: placement.sign,
          degreeInSign: placement.degreeInSign,
          house: chart.houseOf(placement.body),
          retrograde: placement.isRetrograde,
          approximate: placement.body == Body.moon && chart.moonIsApproximate,
          detailed: detailed,
        ),
      if (ascendant != null)
        _PlacementRow(
          glyph: signGlyph(chart.ascendantSign!),
          name: l10n.chartBodyAscendant,
          sign: chart.ascendantSign!,
          degreeInSign: degreeInSign(ascendant),
          house: 1,
          detailed: detailed,
        ),
      if (midheaven != null)
        _PlacementRow(
          glyph: signGlyph(chart.midheavenSign!),
          name: l10n.chartBodyMidheaven,
          sign: chart.midheavenSign!,
          degreeInSign: degreeInSign(midheaven),
          house: chart.houseOfSign(chart.midheavenSign!),
          detailed: detailed,
        ),
    ];

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              container: true,
              header: true,
              child: Text(
                l10n.chartPlacementsTitle,
                style: theme.textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...rows,
            if (!detailed)
              PremiumPreview(
                source: 'chart_details',
                semanticLabel: l10n.chartDetailsLocked,
                child: IgnorePointer(
                  child: _PlacementRow(
                    glyph: bodyGlyph(chart.placements.first.body),
                    name: bodyLabel(l10n, chart.placements.first.body),
                    sign: chart.placements.first.sign,
                    degreeInSign: chart.placements.first.degreeInSign,
                    house: chart.houseOf(chart.placements.first.body),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PlacementRow extends StatelessWidget {
  const _PlacementRow({
    required this.glyph,
    required this.name,
    required this.sign,
    required this.degreeInSign,
    this.house,
    this.retrograde = false,
    this.approximate = false,
    this.detailed = true,
  });

  final String glyph;
  final String name;
  final ZodiacSign sign;
  final double degreeInSign;
  final int? house;
  final bool retrograde;
  final bool approximate;
  final bool detailed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final signName = zodiacSignLabel(l10n, sign);
    final degrees = formatDegrees(degreeInSign);
    final houseText = !detailed || house == null
        ? null
        : l10n.chartHouse(house!);
    final shownDegrees = detailed ? ' $degrees' : '';

    // One announcement per row instead of a stop for every piece of it.
    final spoken = [
      if (detailed)
        l10n.chartRowLabel(name, signName, degrees)
      else
        l10n.chartRowLabelSign(name, signName),
      ?houseText,
      if (retrograde) l10n.chartRetrograde,
      if (approximate) l10n.chartApproximate,
    ].join(', ');

    return Semantics(
      container: true,
      label: spoken,
      excludeSemantics: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSpacing.minTouchTarget),
        child: Row(
          children: [
            SizedBox(
              width: AppSpacing.xl,
              child: Glyph(glyph, style: theme.textTheme.titleLarge),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: theme.textTheme.bodyLarge),
                  Text(
                    approximate
                        ? '$signName$shownDegrees (${l10n.chartApproximate})'
                        : '$signName$shownDegrees',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (houseText != null)
                  Text(houseText, style: theme.textTheme.bodyMedium),
                if (retrograde)
                  Text(retrogradeMark, style: theme.textTheme.labelLarge),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
