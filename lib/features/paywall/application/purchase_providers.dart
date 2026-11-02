import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mochi_moon/core/network/network_providers.dart';
import 'package:mochi_moon/features/paywall/data/play_purchase_catalog.dart';
import 'package:mochi_moon/features/paywall/data/readings_api_purchase_verifier.dart';
import 'package:mochi_moon/features/paywall/domain/purchase_catalog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'purchase_providers.g.dart';

/// The server check for a purchase.
@Riverpod(keepAlive: true)
PurchaseVerifier purchaseVerifier(Ref ref) =>
    ReadingsApiPurchaseVerifier(ref.watch(readingsApiProvider));

/// The store behind the paywall: Google Play on Android, nothing elsewhere
/// (iOS is not a release target yet). Overridden in tests.
@Riverpod(keepAlive: true)
PurchaseCatalog purchaseCatalog(Ref ref) {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
    return const UnavailablePurchaseCatalog();
  }
  final catalog = PlayPurchaseCatalog(
    store: InAppPurchase.instance,
    verifier: ref.watch(purchaseVerifierProvider),
  )..start();
  ref.onDispose(catalog.dispose);
  return catalog;
}

/// The store's price for one compatibility report credit; null if unknown.
@riverpod
Future<String?> reportCreditPrice(Ref ref) =>
    ref.watch(purchaseCatalogProvider).reportCreditPrice();

/// The plans with store prices.
@riverpod
Future<List<PlanOffer>> planOffers(Ref ref) =>
    ref.watch(purchaseCatalogProvider).offers();
