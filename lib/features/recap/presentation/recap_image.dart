import 'package:flutter/material.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/deck/presentation/share_card_image.dart';

/// The monthly glow recap as a 9:16 story image (PRD §6.25). It is given only
/// finished words and numbers: there is no parameter that could carry
/// something she wrote.
class RecapImage extends StatelessWidget {
  const RecapImage({
    required this.headline,
    required this.wordmark,
    this.days,
    this.daysLabel,
    this.moodEmoji,
    this.moodLine,
    this.favouriteLabel,
    this.favouriteText,
    this.welcomeBody,
    super.key,
  });

  final String headline;
  final String wordmark;

  /// The days she showed up; null on the welcome-back variant.
  final int? days;
  final String? daysLabel;
  final String? moodEmoji;
  final String? moodLine;
  final String? favouriteLabel;
  final String? favouriteText;

  /// The welcome-back message; when set, the numbers are not drawn.
  final String? welcomeBody;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final width = shareImageSize.width - 2 * AppSpacing.lg;
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                headline,
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SizedBox(
                    width: width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (welcomeBody != null)
                          Text(
                            welcomeBody!,
                            style: theme.textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          )
                        else ...[
                          Text(
                            '$days',
                            style: theme.textTheme.displayLarge?.copyWith(
                              color: scheme.primary,
                            ),
                          ),
                          if (daysLabel != null)
                            Text(
                              daysLabel!,
                              style: theme.textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                          if (moodLine != null) ...[
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              moodEmoji ?? '',
                              style: theme.textTheme.displayMedium,
                            ),
                            Text(
                              moodLine!,
                              style: theme.textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                          if (favouriteText != null) ...[
                            const SizedBox(height: AppSpacing.lg),
                            if (favouriteLabel != null)
                              Text(
                                favouriteLabel!,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: scheme.primary,
                                ),
                              ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              favouriteText!,
                              style: theme.textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: 0.6,
              child: Text(wordmark, style: theme.textTheme.titleMedium),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
