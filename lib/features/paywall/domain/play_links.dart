/// The app's Google Play page, where she can leave a rating. Always the
/// production package.
final Uri playListingUrl = Uri.https('play.google.com', '/store/apps/details', {
  'id': 'com.mochimoon.mochi_moon',
});

/// Where Google Play lets her manage or cancel a subscription. Always the
/// production package, so the dev flavor opens the real page too.
final Uri manageSubscriptionUrl = Uri.https(
  'play.google.com',
  '/store/account/subscriptions',
  {'package': 'com.mochimoon.mochi_moon'},
);
