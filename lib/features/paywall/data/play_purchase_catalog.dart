import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:mochi_moon/features/paywall/data/play_offer.dart';
import 'package:mochi_moon/features/paywall/domain/purchase_catalog.dart';

/// Google Play Billing behind the paywall (PRD §6.13).
///
/// It never decides on its own that someone is Premium. A purchase goes to
/// the server through [PurchaseVerifier]; only after the server accepts it is
/// the purchase acknowledged to Play. The app then sees Premium through the
/// Firestore entitlement.
class PlayPurchaseCatalog implements PurchaseCatalog {
  PlayPurchaseCatalog({
    required this._store,
    required this._verifier,
    this.restoreTimeout = const Duration(seconds: 8),
  });

  final InAppPurchase _store;
  final PurchaseVerifier _verifier;
  final Duration restoreTimeout;

  final _chosen = <PremiumPlan, ChosenOffer>{};
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  Completer<bool>? _restoreWaiting;
  bool _available = false;

  /// Starts listening for purchases. Call once at app start so a purchase
  /// that finished while the app was closed is still handled.
  void start() {
    try {
      _subscription ??= _store.purchaseStream.listen(
        (purchases) => unawaited(_handle(purchases)),
        onError: (Object _) {},
      );
    } on Object {
      // No billing on this device.
    }
  }

  void dispose() => unawaited(_subscription?.cancel());

  @override
  bool get canPurchase => _available && _chosen.isNotEmpty;

  @override
  Future<List<PlanOffer>> offers() async {
    try {
      _available = await _store.isAvailable();
      if (!_available) return _withoutPrices();
      final response = await _store.queryProductDetails({
        for (final plan in PremiumPlan.values) plan.productId,
      });
      _chosen.clear();
      for (final plan in PremiumPlan.values) {
        final entries = [
          for (final d in response.productDetails)
            if (d.id == plan.productId) d,
        ];
        final choice = chooseOffer(entries, trial: plan.hasTrial);
        if (choice != null) _chosen[plan] = choice;
      }
      return [
        for (final plan in PremiumPlan.values)
          PlanOffer(plan: plan, price: _chosen[plan]?.price),
      ];
    } on Object {
      _available = false;
      return _withoutPrices();
    }
  }

  List<PlanOffer> _withoutPrices() => [
    for (final plan in PremiumPlan.values) PlanOffer(plan: plan),
  ];

  @override
  Future<BuyResult> buy(PremiumPlan plan) async {
    final choice = _chosen[plan];
    if (!_available || choice == null) return BuyResult.unavailable;
    try {
      final param = GooglePlayPurchaseParam(
        productDetails: choice.details,
        offerToken: choice.token,
      );
      final started = await _store.buyNonConsumable(purchaseParam: param);
      return started ? BuyResult.started : BuyResult.failed;
    } on Object {
      return BuyResult.failed;
    }
  }

  @override
  Future<bool> restore() async {
    try {
      if (!await _store.isAvailable()) return false;
      final waiting = _restoreWaiting = Completer<bool>();
      await _store.restorePurchases();
      return await waiting.future.timeout(
        restoreTimeout,
        onTimeout: () => false,
      );
    } on Object {
      return false;
    } finally {
      _restoreWaiting = null;
    }
  }

  Future<void> _handle(List<PurchaseDetails> purchases) async {
    final ours = {for (final plan in PremiumPlan.values) plan.productId};
    for (final purchase in purchases) {
      if (!ours.contains(purchase.productID)) continue;
      try {
        switch (purchase.status) {
          case PurchaseStatus.purchased:
          case PurchaseStatus.restored:
            final accepted = await _verifier.verify(
              productId: purchase.productID,
              token: purchase.verificationData.serverVerificationData,
            );
            if (!accepted) continue;
            if (purchase.pendingCompletePurchase) {
              await _store.completePurchase(purchase);
            }
            if (purchase.status == PurchaseStatus.restored) {
              final waiting = _restoreWaiting;
              if (waiting != null && !waiting.isCompleted) {
                waiting.complete(true);
              }
            }
          case PurchaseStatus.error:
          case PurchaseStatus.canceled:
            if (purchase.pendingCompletePurchase) {
              await _store.completePurchase(purchase);
            }
          case PurchaseStatus.pending:
            break;
        }
      } on Object {
        // One bad purchase must not stop the rest.
      }
    }
  }
}
