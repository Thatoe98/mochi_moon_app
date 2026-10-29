import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/retrograde/application/retrograde_providers.dart';
import 'package:mochi_moon/features/cosmic/retrograde/domain/retrograde_status.dart';
import 'package:mochi_moon/features/cosmic/retrograde/presentation/retrograde_labels.dart';

/// Mercury's retrograde status, linking to the full Retrogrades screen
/// (PRD §6.8). Stays out of the way while loading and when the calendar fails;
/// the Retrogrades screen has the retry.
class RetrogradeStatusCard extends ConsumerWidget {
  const RetrogradeStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(retrogradeOverviewProvider).value;
    if (overview == null) return const SizedBox.shrink();
    final status = retrogradeStatus(
      Body.mercury,
      overview.now,
      overview.of(Body.mercury),
    );
    if (status == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final (title, subtitle) = retrogradeStatusText(
      context,
      Body.mercury,
      status,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      clipBehavior: Clip.antiAlias,
      child: Semantics(
        button: true,
        hint: l10n.retroCardHint,
        child: InkWell(
          onTap: () => context.push(AppRoutes.retrogrades),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSpacing.minTouchTarget,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      Icons.published_with_changes_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: theme.textTheme.titleMedium),
                        if (subtitle != null)
                          Text(subtitle, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  ExcludeSemantics(
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
