import 'package:flutter/material.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';

/// One full-screen step of the first-run flow: art, a heading, a line of text
/// and a single button.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    required this.illustration,
    required this.illustrationLabel,
    required this.title,
    required this.body,
    required this.buttonLabel,
    required this.onPressed,
    super.key,
  });

  final String illustration;
  final String illustrationLabel;
  final String title;
  final String body;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: AppRadii.cardRadius,
              child: SizedBox.expand(
                child: MochiIllustration(
                  asset: illustration,
                  semanticLabel: illustrationLabel,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            body,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: onPressed, child: Text(buttonLabel)),
          ),
        ],
      ),
    );
  }
}
