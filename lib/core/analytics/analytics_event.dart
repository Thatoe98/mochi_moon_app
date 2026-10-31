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
  purchaseCompleted('purchase_completed', {'productId'}),
  widgetAdded('widget_added'),
  notificationOpened('notification_opened', {'type'}),
  accountDeleted('account_deleted'),
  hardDayOpened('hard_day_opened', {'source'});

  AnalyticsEvent(this.eventName, [this.allowedParams = const {}]);

  /// The name sent to the analytics service.
  final String eventName;

  /// The parameter names this event may carry.
  final Set<String> allowedParams;
}
