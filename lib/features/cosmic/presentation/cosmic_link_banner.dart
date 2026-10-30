import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';

/// A full-width banner at the top of the Cosmic tab that opens another screen
/// (PRD §6.8, §6.11). It does not wait for any data, so it is there the moment
/// the tab opens.
class CosmicLinkBanner extends StatelessWidget {
  const CosmicLinkBanner({
    required this.icon,
    required this.title,
    required this.hint,
    required this.route,
    super.key,
  });

  final IconData icon;
  final String title;
  final String hint;
  final String route;

  @override
  Widget build(BuildContext context) {
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
          onTap: () => context.push(route),
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
                  Icon(icon, color: colors.onPrimaryContainer),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colors.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          hint,
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
