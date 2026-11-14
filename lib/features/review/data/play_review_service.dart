import 'package:in_app_review/in_app_review.dart';
import 'package:mochi_moon/core/utils/url_opener.dart';
import 'package:mochi_moon/features/paywall/domain/play_links.dart';
import 'package:mochi_moon/features/review/domain/review_repositories.dart';

/// Ratings through Google Play: the in-app review sheet, and the listing page
/// as a fallback for the "Rate" row.
class PlayReviewService implements ReviewService {
  PlayReviewService({required this._openUrl, InAppReview? inAppReview})
    : _inAppReview = inAppReview ?? InAppReview.instance;

  final UrlOpener _openUrl;
  final InAppReview _inAppReview;

  @override
  Future<void> requestReview() async {
    try {
      if (await _inAppReview.isAvailable()) {
        await _inAppReview.requestReview();
      }
    } on Object {
      // A rating prompt must never get in her way.
    }
  }

  @override
  Future<bool> openStoreListing() async {
    try {
      await _inAppReview.openStoreListing();
      return true;
    } on Object {
      return await _openUrl(playListingUrl);
    }
  }
}
