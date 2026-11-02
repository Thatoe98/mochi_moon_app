// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The server check for a purchase.

@ProviderFor(purchaseVerifier)
final purchaseVerifierProvider = PurchaseVerifierProvider._();

/// The server check for a purchase.

final class PurchaseVerifierProvider
    extends
        $FunctionalProvider<
          PurchaseVerifier,
          PurchaseVerifier,
          PurchaseVerifier
        >
    with $Provider<PurchaseVerifier> {
  /// The server check for a purchase.
  PurchaseVerifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'purchaseVerifierProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$purchaseVerifierHash();

  @$internal
  @override
  $ProviderElement<PurchaseVerifier> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PurchaseVerifier create(Ref ref) {
    return purchaseVerifier(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PurchaseVerifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PurchaseVerifier>(value),
    );
  }
}

String _$purchaseVerifierHash() => r'72c4d499d5547c947913fd2eb30dab38d7b79035';

/// The store behind the paywall: Google Play on Android, nothing elsewhere
/// (iOS is not a release target yet). Overridden in tests.

@ProviderFor(purchaseCatalog)
final purchaseCatalogProvider = PurchaseCatalogProvider._();

/// The store behind the paywall: Google Play on Android, nothing elsewhere
/// (iOS is not a release target yet). Overridden in tests.

final class PurchaseCatalogProvider
    extends
        $FunctionalProvider<PurchaseCatalog, PurchaseCatalog, PurchaseCatalog>
    with $Provider<PurchaseCatalog> {
  /// The store behind the paywall: Google Play on Android, nothing elsewhere
  /// (iOS is not a release target yet). Overridden in tests.
  PurchaseCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'purchaseCatalogProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$purchaseCatalogHash();

  @$internal
  @override
  $ProviderElement<PurchaseCatalog> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PurchaseCatalog create(Ref ref) {
    return purchaseCatalog(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PurchaseCatalog value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PurchaseCatalog>(value),
    );
  }
}

String _$purchaseCatalogHash() => r'ae459b522e0d16b90448ffafc554825a45dcd5c7';

/// The plans with store prices.

@ProviderFor(planOffers)
final planOffersProvider = PlanOffersProvider._();

/// The plans with store prices.

final class PlanOffersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PlanOffer>>,
          List<PlanOffer>,
          FutureOr<List<PlanOffer>>
        >
    with $FutureModifier<List<PlanOffer>>, $FutureProvider<List<PlanOffer>> {
  /// The plans with store prices.
  PlanOffersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'planOffersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$planOffersHash();

  @$internal
  @override
  $FutureProviderElement<List<PlanOffer>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PlanOffer>> create(Ref ref) {
    return planOffers(ref);
  }
}

String _$planOffersHash() => r'33e7d937a324afa17ea26961ad91899342c1c009';
