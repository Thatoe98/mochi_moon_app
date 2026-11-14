import 'package:mochi_moon/features/review/domain/review_policy.dart';

/// Remembers, on this device only, when she was last asked to rate the app.
abstract interface class ReviewHistoryRepository {
  Future<ReviewHistory> load();

  Future<void> markAsked(DateTime now);
}

/// Talks to Google Play for ratings.
abstract interface class ReviewService {
  /// Shows the Play in-app review sheet when Play allows it. Never throws.
  Future<void> requestReview();

  /// Opens the app's Play listing so she can rate it. False when it could not
  /// be opened.
  Future<bool> openStoreListing();
}
