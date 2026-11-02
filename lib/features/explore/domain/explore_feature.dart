import 'package:flutter/material.dart';
import 'package:mochi_moon/app/router.dart';

/// The groups on the Explore tab.
enum ExploreGroup { feelBetter, grow, collection, love }

/// Which theme color tints a feature icon circle.
enum FeatureAccent { lavender, peach, pink }

/// A self-love feature that has a tile on Explore. [name] is saved when its
/// first-time intro has been seen, so a rename would show the intro again.
enum ExploreFeature {
  breathe(
    route: AppRoutes.breathe,
    icon: Icons.self_improvement_rounded,
    group: ExploreGroup.feelBetter,
    accent: FeatureAccent.lavender,
  ),
  mood(
    route: AppRoutes.mood,
    icon: Icons.mood_rounded,
    group: ExploreGroup.feelBetter,
    accent: FeatureAccent.peach,
  ),
  gratitude(
    route: AppRoutes.gratitude,
    icon: Icons.local_florist_rounded,
    group: ExploreGroup.feelBetter,
    accent: FeatureAccent.pink,
  ),
  hardDay(
    route: AppRoutes.hardDay,
    icon: Icons.favorite_rounded,
    group: ExploreGroup.feelBetter,
    accent: FeatureAccent.pink,
    hasIntro: false,
  ),
  journeys(
    route: AppRoutes.journeys,
    icon: Icons.route_rounded,
    group: ExploreGroup.grow,
    accent: FeatureAccent.lavender,
  ),
  ownCards(
    route: AppRoutes.ownCards,
    icon: Icons.edit_note_rounded,
    group: ExploreGroup.grow,
    accent: FeatureAccent.peach,
  ),
  letters(
    route: AppRoutes.letters,
    icon: Icons.mail_rounded,
    group: ExploreGroup.grow,
    accent: FeatureAccent.pink,
  ),
  journal(
    route: AppRoutes.journal,
    icon: Icons.favorite_border_rounded,
    group: ExploreGroup.collection,
    accent: FeatureAccent.pink,
  ),
  mascotRoom(
    route: AppRoutes.mascotRoom,
    icon: Icons.cottage_rounded,
    group: ExploreGroup.collection,
    accent: FeatureAccent.peach,
  ),
  recap(
    route: AppRoutes.recap,
    icon: Icons.auto_awesome_rounded,
    group: ExploreGroup.collection,
    accent: FeatureAccent.lavender,
  ),
  partners(
    route: AppRoutes.partners,
    icon: Icons.people_alt_rounded,
    group: ExploreGroup.love,
    accent: FeatureAccent.pink,
  );

  ExploreFeature({
    required this.route,
    required this.icon,
    required this.group,
    required this.accent,
    this.hasIntro = true,
  });

  final String route;
  final IconData icon;
  final ExploreGroup group;
  final FeatureAccent accent;

  /// False for the hard-day kit: it must open straight away, never behind a
  /// sheet (PRD safety rule).
  final bool hasIntro;

  static List<ExploreFeature> inGroup(ExploreGroup group) => [
    for (final feature in values)
      if (feature.group == group) feature,
  ];

  /// Where a tap goes. The hard-day kit also carries where it was opened.
  String get location =>
      this == ExploreFeature.hardDay ? '$route?source=explore' : route;
}
