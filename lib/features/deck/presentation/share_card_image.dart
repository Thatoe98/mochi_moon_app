import 'package:flutter/material.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/deck/presentation/quote_card.dart';

/// The story image is laid out at 360x640 and captured at 3x, giving the
/// 1080x1920 PNG from PRD §6.4.
const shareImageSize = Size(360, 640);
const shareImagePixelRatio = 3.0;

/// One affirmation as a 9:16 story image: illustration, text, and a subtle
/// wordmark with an optional handle.
class ShareCardImage extends StatelessWidget {
  const ShareCardImage({
    required this.text,
    required this.wordmark,
    this.categoryLabel,
    this.handle,
    super.key,
  });

  final String text;
  final String wordmark;
  final String? categoryLabel;
  final String? handle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return SizedBox.fromSize(
      size: shareImageSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [scheme.primaryContainer, scheme.surface],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xl),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: SizedBox(
                height: 330,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: AppRadii.cardRadius,
                  child: IllustrationPlaceholder(iconSize: 72),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                // Long affirmations shrink instead of overflowing.
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SizedBox(
                    width: shareImageSize.width - 2 * AppSpacing.lg,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          text,
                          style: theme.textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        if (categoryLabel != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            categoryLabel!,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: scheme.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: 0.6,
              child: Column(
                children: [
                  Text(wordmark, style: theme.textTheme.titleMedium),
                  if (handle != null)
                    Text(handle!, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
