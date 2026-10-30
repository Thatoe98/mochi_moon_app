import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';

/// The banner at the top of the Cosmic tab that leads to the Retrogrades screen
/// (PRD §6.8). It does not wait for the calendar, so it is there the moment the
/// tab opens.
class RetrogradeButton extends StatelessWidget {
  const RetrogradeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        0,
      ),
      child: Material(
        color: colors.primaryContainer,
        borderRadius: AppRadii.cardRadius,
        child: InkWell(
          borderRadius: AppRadii.cardRadius,
          onTap: () => context.push(AppRoutes.retrogrades),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSpacing.minTouchTarget,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.published_with_changes_rounded,
                    color: colors.onPrimaryContainer,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.retroTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colors.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          l10n.retroCardHint,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: colors.onPrimaryContainer,
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
