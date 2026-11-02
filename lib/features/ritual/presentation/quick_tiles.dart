import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/feature_tile.dart';
import 'package:mochi_moon/features/explore/domain/explore_feature.dart';

/// A row of four one-tap shortcuts on Today. They open the feature directly
/// (no intro sheet); the hard-day kit is always one tap away.
class QuickTiles extends StatelessWidget {
  const QuickTiles({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    Widget tile(ExploreFeature feature, String label, Color accent) => Expanded(
      child: QuickTile(
        icon: feature.icon,
        accent: accent,
        label: label,
        onTap: () => context.push(
          feature == ExploreFeature.hardDay
              ? '${feature.route}?source=today'
              : feature.route,
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tile(ExploreFeature.breathe, l10n.quickBreathe, scheme.primary),
          tile(ExploreFeature.gratitude, l10n.quickGratitude, scheme.tertiary),
          tile(ExploreFeature.mood, l10n.quickMood, scheme.secondary),
          tile(ExploreFeature.hardDay, l10n.quickHardDay, scheme.tertiary),
        ],
      ),
    );
  }
}
