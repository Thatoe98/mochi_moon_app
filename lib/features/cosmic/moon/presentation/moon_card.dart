import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/utils/english_dates.dart';
import 'package:mochi_moon/features/cosmic/moon/application/moon_providers.dart';
import 'package:mochi_moon/features/cosmic/moon/presentation/moon_glyph.dart';
import 'package:mochi_moon/features/cosmic/moon/presentation/moon_labels.dart';
import 'package:mochi_moon/features/cosmic/presentation/zodiac_labels.dart';

/// The Moon right now: phase, how much is lit, its sign, the next new and full
/// moon, and an affirmation for the phase (PRD §6.8).
class MoonCard extends ConsumerWidget {
  const MoonCard({super.key});

  static const double _glyphSize = AppSpacing.xxl + AppSpacing.md;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final moon = ref.watch(moonNowProvider);
    final phase = moonPhaseLabel(l10n, moon.name);
    final percent = (moon.illumination * 100).round();

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(l10n.moonTitle, style: theme.textTheme.titleMedium),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                MoonGlyph(
                  illumination: moon.illumination,
                  isWaxing: moon.isWaxing,
                  size: _glyphSize,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(phase, style: theme.textTheme.titleLarge),
                      Text(
                        l10n.moonIlluminated(percent),
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        l10n.cosmicMoonIn(zodiacSignLabel(l10n, moon.moonSign)),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              moonAffirmation(l10n, moon.name),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.moonNextNew(_date(moon.nextNewMoon)),
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              l10n.moonNextFull(_date(moon.nextFullMoon)),
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  /// The day of [utc] in the phone's time zone, like the retrograde dates.
  static String _date(DateTime utc) =>
      englishDates.formatMediumDate(utc.toLocal());
}
