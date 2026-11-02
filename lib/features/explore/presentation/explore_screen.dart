import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/feature_tile.dart';
import 'package:mochi_moon/core/widgets/section_header.dart';
import 'package:mochi_moon/features/explore/application/tips_providers.dart';
import 'package:mochi_moon/features/explore/domain/explore_feature.dart';
import 'package:mochi_moon/features/explore/presentation/explore_copy.dart';
import 'package:mochi_moon/features/explore/presentation/feature_intro_sheet.dart';

/// The grid of every self-love feature, in groups (PRD §5).
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  Future<void> _open(
    BuildContext context,
    WidgetRef ref,
    ExploreFeature feature,
  ) async {
    if (feature.hasIntro) {
      final intros = ref.read(featureIntrosProvider.notifier);
      if (!await intros.isSeen(feature)) {
        if (!context.mounted) return;
        final go = await showFeatureIntro(context, feature);
        await intros.markSeen(feature);
        if (!go || !context.mounted) return;
      }
    }
    if (!context.mounted) return;
    unawaited(context.push(feature.location));
  }

  Future<void> _showIntro(BuildContext context, ExploreFeature feature) async {
    final go = await showFeatureIntro(context, feature);
    if (go && context.mounted) unawaited(context.push(feature.location));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    Widget tile(ExploreFeature feature) => FeatureTile(
      icon: feature.icon,
      accent: feature.color(scheme),
      title: feature.title(l10n),
      subtitle: feature.subtitle(l10n),
      onTap: () => _open(context, ref, feature),
      onLongPress: feature.hasIntro ? () => _showIntro(context, feature) : null,
      longPressLabel: feature.hasIntro ? l10n.exploreShowIntro : null,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.exploreTitle)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        children: [
          for (final group in ExploreGroup.values) ...[
            SectionHeader(group.title(l10n)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _TileGrid(
                tiles: [
                  for (final feature in ExploreFeature.inGroup(group))
                    tile(feature),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Two columns of equal-height tiles. Rows size to the tallest tile, so large
/// text never overflows.
class _TileGrid extends StatelessWidget {
  const _TileGrid({required this.tiles});

  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < tiles.length; i += 2) {
      if (i > 0) rows.add(const SizedBox(height: AppSpacing.md));
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: tiles[i]),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: i + 1 < tiles.length ? tiles[i + 1] : const SizedBox(),
              ),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}
