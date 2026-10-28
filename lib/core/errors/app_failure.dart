/// A failure the UI can describe to the user. Data sources throw their own
/// exceptions; repositories translate them into one of these.
sealed class AppFailure implements Exception {
  const AppFailure();
}

/// The user backed out of a system flow (for example the Google account
/// picker). Not an error to show.
final class CancelledFailure extends AppFailure {
  const CancelledFailure();
}

/// The service is not configured in this build, for example Firebase without
/// a `google-services.json`.
final class UnavailableFailure extends AppFailure {
  const UnavailableFailure();
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure();
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure([this.cause]);

  final Object? cause;

  @override
  String toString() => 'UnknownFailure($cause)';
}
