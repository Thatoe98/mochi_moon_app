import 'package:flutter/material.dart';

/// Bundled mascot art (PRD §8.4). Files live in `assets/illustrations/`.
abstract final class AppIllustrations {
  static const onboardingWelcome =
      'assets/illustrations/ill_onboarding_welcome.webp';
  static const onboardingSave = 'assets/illustrations/ill_onboarding_save.webp';
  static const emptyDeck = 'assets/illustrations/ill_empty_deck.webp';

  static const calm = 'assets/illustrations/ill_calm_01.webp';
  static const confidence = 'assets/illustrations/ill_confidence_01.webp';
  static const healing = 'assets/illustrations/ill_healing_01.webp';
  static const selfWorth = 'assets/illustrations/ill_selfworth_01.webp';
  static const rest = 'assets/illustrations/ill_rest_01.webp';

  /// The theme art a card of [category] wears. Unknown categories get [calm],
  /// so new content never ships without a picture.
  static String forCategory(String category) => switch (category) {
    'confidence' => confidence,
    'healing' => healing,
    'self_love' || 'body_kindness' => selfWorth,
    'study_work' => rest,
    _ => calm,
  };

  /// The art she can put on a card of her own: id (as stored) to asset.
  static const Map<String, String> ownCardArt = {
    'calm_01': calm,
    'confidence_01': confidence,
    'healing_01': healing,
    'selfworth_01': selfWorth,
    'rest_01': rest,
  };

  /// The art for a card: its own pick when [illustrationId] names bundled
  /// art, otherwise the theme art of its [category].
  static String forCard(String category, String? illustrationId) =>
      ownCardArt[illustrationId] ?? forCategory(category);

  static const List<String> all = [
    onboardingWelcome,
    onboardingSave,
    emptyDeck,
    calm,
    confidence,
    healing,
    selfWorth,
    rest,
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
