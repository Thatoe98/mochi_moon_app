/// The Premium plans on offer (PRD §6.13).
enum PremiumPlan {
  yearly('mochi_premium_yearly', hasTrial: true),
  monthly('mochi_premium_monthly', hasTrial: false);

  PremiumPlan(this.productId, {required this.hasTrial});

  /// The Google Play product id.
  final String productId;

  /// Whether the plan starts with a free trial.
  final bool hasTrial;
}

/// One plan as the store shows it. The price text always comes from the
/// store, never from the app; it is null while the store cannot be reached.
class PlanOffer {
  const PlanOffer({required this.plan, this.price});

  final PremiumPlan plan;
  final String? price;
}

/// How starting a purchase went. The result of a purchase itself comes later:
/// the server checks it and writes the entitlement (PRD §6.13).
enum BuyResult {
  /// The store's purchase sheet was opened.
  started,

  /// The store cannot sell right now (offline, plan not found).
  unavailable,

  /// The store refused to start the purchase.
  failed,
}

/// Sends a purchase to the server, which asks Google Play whether it is real
/// and then writes `entitlement` to Firestore (PRD §8.2).
abstract interface class PurchaseVerifier {
  /// True when the server accepted the purchase. Only then is the purchase
  /// acknowledged to the store.
  Future<bool> verify({required String productId, required String token});
}

/// What the paywall needs from the store. The real Google Play Billing
/// implementation arrives with the server-side purchase check; until then the
/// app uses [UnavailablePurchaseCatalog].
abstract interface class PurchaseCatalog {
  /// The plans with their store prices.
  Future<List<PlanOffer>> offers();

  /// Whether buying is possible right now.
  bool get canPurchase;

  /// Opens the store's purchase sheet for [plan].
  Future<BuyResult> buy(PremiumPlan plan);

  /// Asks the store to re-deliver earlier purchases. Returns true when
  /// Premium was found.
  Future<bool> restore();
}

/// Stand-in until billing is connected: no prices, nothing to buy or restore.
class UnavailablePurchaseCatalog implements PurchaseCatalog {
  const UnavailablePurchaseCatalog();

  @override
  bool get canPurchase => false;

  @override
  Future<List<PlanOffer>> offers() async => [
    for (final plan in PremiumPlan.values) PlanOffer(plan: plan),
  ];

  @override
  Future<BuyResult> buy(PremiumPlan plan) async => BuyResult.unavailable;

  @override
  Future<bool> restore() async => false;
}
