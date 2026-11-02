/// The only events the app may log, and the only parameters each one may
/// carry (PRD §11). Birth data, partner names, journal text and quote text have
/// no place here, so a parameter that is not listed is dropped.
enum AnalyticsEvent {
  onboardingStarted('onboarding_started'),
  onboardingCompleted('onboarding_completed'),
  signInSuccess('sign_in_success'),
  cardCompleted('card_completed'),
  cardSwiped('card_swiped', {'direction'}),
  cardShared('card_shared'),
  dailyLimitReached('daily_limit_reached'),
  moodSelected('mood_selected', {'mood'}),
  cosmicTodayViewed('cosmic_today_viewed'),
  chartViewed('chart_viewed'),
  compatCreated('compat_created', {'mode'}),
  paywallViewed('paywall_viewed', {'source'}),
  trialStarted('trial_started'),
  trialOfferShown('trial_offer_shown'),
  trialOfferDismissed('trial_offer_dismissed'),
  purchaseCompleted('purchase_completed', {'productId'}),
  widgetAdded('widget_added'),
  notificationOpened('notification_opened', {'type'}),
  accountDeleted('account_deleted'),
  hardDayOpened('hard_day_opened', {'source'}),
  ritualStarted('ritual_started'),
  ritualCompleted('ritual_completed'),
  gratitudeAdded('gratitude_added', {'count'}),
  jarOpened('jar_opened'),
  customCardCreated('custom_card_created'),
  moodLogged('mood_logged', {'mood'}),
  breatheCompleted('breathe_completed'),
  questCompleted('quest_completed'),
  questSwapped('quest_swapped'),
  journeyStarted('journey_started', {'journeyId'}),
  journeyDayCompleted('journey_day_completed', {'journeyId', 'day'}),
  journeyCompleted('journey_completed', {'journeyId'}),
  letterSealed('letter_sealed', {'unlockDays'}),
  letterOpened('letter_opened'),
  mascotItemUnlocked('mascot_item_unlocked', {'itemId'}),
  weeklyLetterViewed('weekly_letter_viewed'),
  recapShared('recap_shared'),
  cosmicUnlocked('cosmic_unlocked');

  AnalyticsEvent(this.eventName, [this.allowedParams = const {}]);

  /// The name sent to the analytics service.
  final String eventName;

  /// The parameter names this event may carry.
  final Set<String> allowedParams;
}
