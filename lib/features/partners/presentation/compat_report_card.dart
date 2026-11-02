import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';

/// The door to the full compatibility report (PRD §6.12). When [locked] (free
/// users) it shows a lock and opens the paywall instead, so the report never
/// disappears from the result.
class CompatReportCard extends StatelessWidget {
  const CompatReportCard({
    required this.partnerId,
    this.locked = false,
    super.key,
  });

  final String partnerId;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Material(
      color: colors.primaryContainer,
      borderRadius: AppRadii.cardRadius,
      child: InkWell(
        borderRadius: AppRadii.cardRadius,
        onTap: () => locked
            ? unawaited(
                context.push('${AppRoutes.paywall}?source=compat_report'),
              )
            : unawaited(
                context.push(
                  Uri(
                    path: AppRoutes.partnerReport,
                    queryParameters: {'id': partnerId},
                  ).toString(),
                ),
              ),
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
                    Icons.auto_stories_rounded,
                    color: colors.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.compatReportCardTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colors.onPrimaryContainer,
                        ),
                      ),
                      Text(
                        l10n.compatReportCardBody,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  locked ? Icons.lock_rounded : Icons.chevron_right_rounded,
                  color: colors.onPrimaryContainer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
