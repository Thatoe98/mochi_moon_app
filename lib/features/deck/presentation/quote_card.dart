import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';

/// One affirmation card: illustration on top (~60%), the text, a category chip.
class QuoteCard extends StatelessWidget {
  const QuoteCard({
    required this.text,
    required this.category,
    this.categoryLabel,
    super.key,
  });

  final String text;

  /// The category id, which picks the art.
  final String category;
  final String? categoryLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(flex: 6, child: QuoteIllustration(category: category)),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Text(
                          text,
                          style: theme.textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  if (categoryLabel != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Chip(
                      label: Text(categoryLabel!),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadii.chipRadius,
                      ),
                      visualDensity: VisualDensity.compact,
                      side: BorderSide.none,
                      backgroundColor: theme.colorScheme.primaryContainer,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The theme art for a card of [category], with its TalkBack label.
class QuoteIllustration extends StatelessWidget {
  const QuoteIllustration({required this.category, super.key});

  final String category;

  @override
  Widget build(BuildContext context) {
    final asset = AppIllustrations.forCategory(category);
    return MochiIllustration(
      asset: asset,
      semanticLabel: _label(AppLocalizations.of(context), asset),
    );
  }
}

String _label(AppLocalizations l10n, String asset) => switch (asset) {
  AppIllustrations.confidence => l10n.illustrationConfidence,
  AppIllustrations.healing => l10n.illustrationHealing,
  AppIllustrations.selfWorth => l10n.illustrationSelfWorth,
  AppIllustrations.rest => l10n.illustrationRest,
  _ => l10n.illustrationCalm,
};
