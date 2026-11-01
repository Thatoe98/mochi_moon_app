import 'package:mochi_moon/features/paywall/domain/purchase_catalog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'purchase_providers.g.dart';

/// The store behind the paywall. Overridden in tests; swap the body for the
/// Google Play implementation when billing is connected.
@Riverpod(keepAlive: true)
PurchaseCatalog purchaseCatalog(Ref ref) => const UnavailablePurchaseCatalog();

/// The plans with store prices.
@riverpod
Future<List<PlanOffer>> planOffers(Ref ref) =>
    ref.watch(purchaseCatalogProvider).offers();
