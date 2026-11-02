import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/feature_tile.dart';
import 'package:mochi_moon/features/explore/application/tips_providers.dart';

/// A dismissible card on Today that offers the tour until she has seen it.
class TourPromptCard extends ConsumerWidget {
  const TourPromptCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seen = ref.watch(tourSeenProvider).value ?? true;
    if (seen) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.all(AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            IconBadge(
              icon: Icons.lightbulb_rounded,
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.tourPromptTitle, style: theme.textTheme.titleSmall),
                  Text(l10n.tourPromptBody, style: theme.textTheme.bodySmall),
                  Wrap(
                    children: [
                      TextButton(
                        onPressed: () => context.push(AppRoutes.tour),
                        child: Text(l10n.tourPromptStart),
                      ),
                      TextButton(
                        onPressed: () =>
                            ref.read(tourSeenProvider.notifier).markSeen(),
                        child: Text(l10n.tourPromptDismiss),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
