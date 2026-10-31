import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';

/// A glass jar that fills with paper stars as she adds entries. The fill is
/// capped for display ([fullAt] stars is a full jar) and eases up unless
/// reduced motion is on.
class GratitudeJar extends StatelessWidget {
  const GratitudeJar({required this.count, super.key});

  /// Stars that make the jar look full.
  static const fullAt = 20;

  /// Entries in the jar.
  final int count;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final fill = math.min(count, fullAt) / fullAt;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 400);
    return Semantics(
      label: l10n.gratitudeJarSemantics(count),
      child: ExcludeSemantics(
        child: SizedBox(
          height: 160,
          width: 120,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: scheme.primary, width: 3),
              borderRadius: BorderRadius.circular(AppRadii.card),
              color: scheme.surfaceContainerHighest,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.card - 3),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(end: fill),
                  duration: duration,
                  curve: Curves.easeOut,
                  builder: (context, value, _) => FractionallySizedBox(
                    heightFactor: value,
                    widthFactor: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: scheme.secondaryContainer,
                      ),
                      child: value > 0
                          ? Center(
                              child: Icon(
                                Icons.auto_awesome_rounded,
                                size: AppSpacing.lg,
                                color: scheme.secondary,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
