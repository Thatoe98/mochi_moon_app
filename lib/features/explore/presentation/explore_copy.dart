import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/explore/domain/explore_feature.dart';

/// The words and colors for each Explore feature, all from l10n and the theme.
extension ExploreFeatureCopy on ExploreFeature {
  String title(AppLocalizations l10n) => switch (this) {
    ExploreFeature.breathe => l10n.breatheTitle,
    ExploreFeature.mood => l10n.moodScreenTitle,
    ExploreFeature.gratitude => l10n.gratitudeTitle,
    ExploreFeature.hardDay => l10n.hardDayTitle,
    ExploreFeature.journeys => l10n.journeysTitle,
    ExploreFeature.ownCards => l10n.ownCardsTitle,
    ExploreFeature.letters => l10n.lettersTitle,
    ExploreFeature.journal => l10n.journalTitle,
    ExploreFeature.mascotRoom => l10n.mascotRoomTitle,
    ExploreFeature.recap => l10n.recapTitle,
    ExploreFeature.partners => l10n.partnersTitle,
  };

  String subtitle(AppLocalizations l10n) => switch (this) {
    ExploreFeature.breathe => l10n.breatheMeSubtitle,
    ExploreFeature.mood => l10n.moodMeSubtitle,
    ExploreFeature.gratitude => l10n.gratitudeMeSubtitle,
    ExploreFeature.hardDay => l10n.exploreHardDaySubtitle,
    ExploreFeature.journeys => l10n.journeysMeSubtitle,
    ExploreFeature.ownCards => l10n.ownCardsMeSubtitle,
    ExploreFeature.letters => l10n.lettersMeSubtitle,
    ExploreFeature.journal => l10n.meJournalSubtitle,
    ExploreFeature.mascotRoom => l10n.mascotRoomMeSubtitle,
    ExploreFeature.recap => l10n.recapMeSubtitle,
    ExploreFeature.partners => l10n.mePartnersSubtitle,
  };

  /// The first-time intro. The hard-day kit has none and opens straight away.
  String intro(AppLocalizations l10n) => switch (this) {
    ExploreFeature.breathe => l10n.exploreIntroBreathe,
    ExploreFeature.mood => l10n.exploreIntroMood,
    ExploreFeature.gratitude => l10n.exploreIntroGratitude,
    ExploreFeature.hardDay => '',
    ExploreFeature.journeys => l10n.exploreIntroJourneys,
    ExploreFeature.ownCards => l10n.exploreIntroOwnCards,
    ExploreFeature.letters => l10n.exploreIntroLetters,
    ExploreFeature.journal => l10n.exploreIntroJournal,
    ExploreFeature.mascotRoom => l10n.exploreIntroMascotRoom,
    ExploreFeature.recap => l10n.exploreIntroRecap,
    ExploreFeature.partners => l10n.exploreIntroPartners,
  };

  Color color(ColorScheme scheme) => switch (accent) {
    FeatureAccent.lavender => scheme.primary,
    FeatureAccent.peach => scheme.secondary,
    FeatureAccent.pink => scheme.tertiary,
  };
}

extension ExploreGroupCopy on ExploreGroup {
  String title(AppLocalizations l10n) => switch (this) {
    ExploreGroup.feelBetter => l10n.exploreGroupFeelBetter,
    ExploreGroup.grow => l10n.exploreGroupGrow,
    ExploreGroup.collection => l10n.exploreGroupCollection,
    ExploreGroup.love => l10n.exploreGroupLove,
  };
}
