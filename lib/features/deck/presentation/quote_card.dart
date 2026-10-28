import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';

/// One affirmation card: illustration on top (~60%), the text, a category chip.
class QuoteCard extends StatelessWidget {
  const QuoteCard({required this.text, this.categoryLabel, super.key});

  final String text;
  final String? categoryLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          const Expanded(flex: 6, child: _IllustrationPlaceholder()),
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

/// Stands in until the illustration assets exist (PRD §8.4).
class _IllustrationPlaceholder extends StatelessWidget {
  const _IllustrationPlaceholder();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      image: true,
      label: AppLocalizations.of(context).deckIllustrationSemantics,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                scheme.primaryContainer,
                scheme.tertiary.withValues(alpha: 0.5),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.nightlight_round,
              size: AppSpacing.xxl,
              color: scheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
