import 'package:flutter/material.dart';

/// Bundled mascot art (PRD §8.4). Files live in `assets/illustrations/`.
abstract final class AppIllustrations {
  static const onboardingWelcome =
      'assets/illustrations/ill_onboarding_welcome.webp';
  static const onboardingSave = 'assets/illustrations/ill_onboarding_save.webp';
  static const emptyDeck = 'assets/illustrations/ill_empty_deck.webp';

  static const List<String> all = [
    onboardingWelcome,
    onboardingSave,
    emptyDeck,
  ];
}

/// One piece of bundled art. The label is required so no image is left
/// without a description for TalkBack.
class MochiIllustration extends StatelessWidget {
  const MochiIllustration({
    required this.asset,
    required this.semanticLabel,
    this.fit = BoxFit.cover,
    super.key,
  });

  final String asset;
  final String semanticLabel;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) =>
      Image.asset(asset, fit: fit, semanticLabel: semanticLabel);
}
