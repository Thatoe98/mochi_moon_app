// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reviewHistoryRepository)
final reviewHistoryRepositoryProvider = ReviewHistoryRepositoryProvider._();

final class ReviewHistoryRepositoryProvider
    extends
        $FunctionalProvider<
          ReviewHistoryRepository,
          ReviewHistoryRepository,
          ReviewHistoryRepository
        >
    with $Provider<ReviewHistoryRepository> {
  ReviewHistoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewHistoryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewHistoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReviewHistoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReviewHistoryRepository create(Ref ref) {
    return reviewHistoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReviewHistoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReviewHistoryRepository>(value),
    );
  }
}

String _$reviewHistoryRepositoryHash() =>
    r'b615449503812ad7589c7bc18e1560edb05e6329';

@ProviderFor(reviewService)
final reviewServiceProvider = ReviewServiceProvider._();

final class ReviewServiceProvider
    extends $FunctionalProvider<ReviewService, ReviewService, ReviewService>
    with $Provider<ReviewService> {
  ReviewServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewServiceHash();

  @$internal
  @override
  $ProviderElement<ReviewService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ReviewService create(Ref ref) {
    return reviewService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReviewService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReviewService>(value),
    );
  }
}

String _$reviewServiceHash() => r'f95903aae1e7c4c3e2f6e757445f57e6e3b57fa1';

/// How long the celebration has the screen to itself before the sheet shows.

@ProviderFor(reviewPromptDelay)
final reviewPromptDelayProvider = ReviewPromptDelayProvider._();

/// How long the celebration has the screen to itself before the sheet shows.

final class ReviewPromptDelayProvider
    extends $FunctionalProvider<Duration, Duration, Duration>
    with $Provider<Duration> {
  /// How long the celebration has the screen to itself before the sheet shows.
  ReviewPromptDelayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewPromptDelayProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewPromptDelayHash();

  @$internal
  @override
  $ProviderElement<Duration> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Duration create(Ref ref) {
    return reviewPromptDelay(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration>(value),
    );
  }
}

String _$reviewPromptDelayHash() => r'630257d5a8b5cd1879c11f1bbc3bdd0e85e75c1e';

/// After a finished ritual: asks Google Play for a rating when it is a kind
/// moment (see [shouldAskForReview]). Silent on every failure.

@ProviderFor(maybeAskForReview)
final maybeAskForReviewProvider = MaybeAskForReviewProvider._();

/// After a finished ritual: asks Google Play for a rating when it is a kind
/// moment (see [shouldAskForReview]). Silent on every failure.

final class MaybeAskForReviewProvider
    extends
        $FunctionalProvider<
          Future<void> Function(),
          Future<void> Function(),
          Future<void> Function()
        >
    with $Provider<Future<void> Function()> {
  /// After a finished ritual: asks Google Play for a rating when it is a kind
  /// moment (see [shouldAskForReview]). Silent on every failure.
  MaybeAskForReviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'maybeAskForReviewProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$maybeAskForReviewHash();

  @$internal
  @override
  $ProviderElement<Future<void> Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<void> Function() create(Ref ref) {
    return maybeAskForReview(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<void> Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<void> Function()>(value),
    );
  }
}

String _$maybeAskForReviewHash() => r'14905e7e7f97a3c87b7da113c7379e516a20d5f9';
