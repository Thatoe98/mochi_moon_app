import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';

/// A soft lock (PRD §6.13): the Premium content shows blurred under a small
/// "Premium" chip, and one tap opens the paywall. Locked things never
/// disappear. It carries no countdown and no guilt copy.
///
/// [child] is shown blurred and is hidden from screen readers; [semanticLabel]
/// says in a few words what is behind the lock. [source] is the
/// `paywall_viewed` source (PRD §6.13 table).
class PremiumPreview extends StatelessWidget {
  const PremiumPreview({
    required this.source,
    required this.semanticLabel,
    required this.child,
    this.onOpen,
    super.key,
  });

  final String source;
  final String semanticLabel;
  final Widget child;

  /// Replaces the default (open the paywall); for tests.
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Semantics(
      button: true,
      label: l10n.premiumPreviewSemantics(semanticLabel),
      excludeSemantics: true,
      onTap: () => _open(context),
      child: ClipRRect(
        borderRadius: AppRadii.cardRadius,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _open(context),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: AppSpacing.minTouchTarget,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Opacity(opacity: 0.7, child: child),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      borderRadius: AppRadii.chipRadius,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock_rounded,
                            size: 16,
                            color: colors.onPrimaryContainer,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            l10n.premiumPreviewChip,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: colors.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
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

  void _open(BuildContext context) {
    final callback = onOpen;
    if (callback != null) {
      callback();
      return;
    }
    unawaited(context.push('${AppRoutes.paywall}?source=$source'));
  }
}
