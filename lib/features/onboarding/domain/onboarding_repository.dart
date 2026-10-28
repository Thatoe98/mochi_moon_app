/// Whether the first-run flow has been seen.
abstract interface class OnboardingRepository {
  Future<bool> isComplete();

  Future<void> markComplete();
}

/// Where a location sends the user: the welcome flow until first run is done,
/// the deck once it is. Null means stay where you are.
String? onboardingRedirect({
  required bool complete,
  required String location,
  required String welcomeRoute,
  required String homeRoute,
}) {
  final inWelcome = location.startsWith(welcomeRoute);
  if (!complete && !inWelcome) return welcomeRoute;
  if (complete && inWelcome) return homeRoute;
  return null;
}
