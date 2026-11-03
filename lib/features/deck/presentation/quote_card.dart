import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';

/// One affirmation card: illustration on top (~55%), the text, a category chip.
class QuoteCard extends StatelessWidget {
  const QuoteCard({
    required this.text,
    required this.category,
    this.illustrationId,
    this.categoryLabel,
    super.key,
  });

  final String text;

  /// The category id, which picks the art.
  final String category;

  /// A picked art id (her own cards); null uses the category art.
  final String? illustrationId;
  final String? categoryLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleLarge;
    // Room for about one and a half lines of the affirmation, so a short
    // screen never squeezes the words down to nothing.
    final lineHeight =
        MediaQuery.textScalerOf(
          context,
        ).scale(titleStyle?.fontSize ?? AppSpacing.lg) *
        (titleStyle?.height ?? 1.3);
    final minTextArea = AppSpacing.md * 2 + lineHeight * 1.5;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final proportional =
              constraints.maxHeight * _textShare / (_artShare + _textShare);
          // The chip only stays when the text keeps its room beside it.
          final showChip =
              categoryLabel != null &&
              proportional >=
                  minTextArea + AppSpacing.sm + _compactChipHeight;
          final textArea = proportional < minTextArea
              ? minTextArea
              : proportional;
          return Column(
            children: [
              Expanded(
                child: QuoteIllustration(
                  category: category,
                  illustrationId: illustrationId,
                ),
              ),
              SizedBox(
                height: textArea,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      Expanded(
                        // A long affirmation shrinks to fit rather than
                        // hiding words.
                        child: LayoutBuilder(
                          builder: (context, textConstraints) => Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: SizedBox(
                                width: textConstraints.maxWidth,
                                child: Text(
                                  text,
                                  style: titleStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (showChip) ...[
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
          );
        },
      ),
    );
  }
}

// The art and text share the card 11 : 9 when there is room.
const double _artShare = 11;
const double _textShare = 9;

// Height of the compact category chip, to decide whether it still fits.
const double _compactChipHeight = 32;

/// The theme art for a card of [category], with its TalkBack label.
class QuoteIllustration extends StatelessWidget {
  const QuoteIllustration({
    required this.category,
    this.illustrationId,
    super.key,
  });

  final String category;
  final String? illustrationId;

  @override
  Widget build(BuildContext context) {
    final asset = AppIllustrations.forCard(category, illustrationId);
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
