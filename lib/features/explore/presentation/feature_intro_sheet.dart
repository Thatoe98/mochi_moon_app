import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/feature_tile.dart';
import 'package:mochi_moon/features/explore/domain/explore_feature.dart';
import 'package:mochi_moon/features/explore/presentation/explore_copy.dart';

/// Shows the short intro for [feature]. Completes with true when she taps
/// "Let's go", false when she dismisses it.
Future<bool> showFeatureIntro(
  BuildContext context,
  ExploreFeature feature,
) async {
  final go = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _FeatureIntroSheet(feature: feature),
  );
  return go ?? false;
}

class _FeatureIntroSheet extends StatelessWidget {
  const _FeatureIntroSheet({required this.feature});

  final ExploreFeature feature;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconBadge(
              icon: feature.icon,
              color: feature.color(theme.colorScheme),
              size: AppSpacing.xxl + AppSpacing.lg,
            ),
            const SizedBox(height: AppSpacing.md),
            Semantics(
              header: true,
              child: Text(
                feature.title(l10n),
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              feature.intro(l10n),
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.exploreIntroGo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
