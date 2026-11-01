// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The store behind the paywall. Overridden in tests; swap the body for the
/// Google Play implementation when billing is connected.

@ProviderFor(purchaseCatalog)
final purchaseCatalogProvider = PurchaseCatalogProvider._();

/// The store behind the paywall. Overridden in tests; swap the body for the
/// Google Play implementation when billing is connected.

final class PurchaseCatalogProvider
    extends
        $FunctionalProvider<PurchaseCatalog, PurchaseCatalog, PurchaseCatalog>
    with $Provider<PurchaseCatalog> {
  /// The store behind the paywall. Overridden in tests; swap the body for the
  /// Google Play implementation when billing is connected.
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

String _$purchaseCatalogHash() => r'67883f42d4961b781fef47c061d5825b3d1387de';

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
