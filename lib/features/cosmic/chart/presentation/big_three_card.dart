import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';
import 'package:mochi_moon/features/cosmic/chart/presentation/chart_glyphs.dart';
import 'package:mochi_moon/features/cosmic/chart/presentation/chart_labels.dart';
import 'package:mochi_moon/features/cosmic/presentation/zodiac_labels.dart';

/// One of the Big 3: the sign, and a short text about what it means
/// (PRD §6.11).
class BigThreeCard extends StatelessWidget {
  const BigThreeCard({
    required this.role,
    required this.sign,
    this.approximate = false,
    super.key,
  });

  final BigThreeRole role;
  final ZodiacSign sign;

  /// True for a Moon sign worked out from noon because the time is unknown.
  final bool approximate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final title = l10n.chartRoleIn(
      bigThreeRoleLabel(l10n, role),
      zodiacSignLabel(l10n, sign),
    );
    final glyph = switch (role) {
      BigThreeRole.sun => bodyGlyph(Body.sun),
      BigThreeRole.moon => bodyGlyph(Body.moon),
      BigThreeRole.rising => signGlyph(sign),
    };

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Glyph(glyph, style: theme.textTheme.headlineMedium),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Semantics(
                      container: true,
                      header: true,
                      child: Text(title, style: theme.textTheme.titleLarge),
                    ),
                  ),
                ],
              ),
              if (approximate)
                Text(l10n.chartApproximate, style: theme.textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                bigThreeText(l10n, role, sign),
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
