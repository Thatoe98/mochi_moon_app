import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

/// The store entry to buy and the price to show for one plan.
class ChosenOffer {
  const ChosenOffer({required this.details, required this.price, this.token});

  final ProductDetails details;

  /// The text from the store; never made up by the app.
  final String price;

  /// Google Play's offer token for a subscription; null elsewhere.
  final String? token;
}

List<PricingPhaseWrapper>? _phasesOf(ProductDetails entry) {
  if (entry is! GooglePlayProductDetails) return null;
  final index = entry.subscriptionIndex;
  final offers = entry.productDetails.subscriptionOfferDetails;
  if (index == null || offers == null || index >= offers.length) return null;
  return offers[index].pricingPhases;
}

/// Google Play lists one entry per base plan or offer of a subscription. This
/// picks the right one: for a plan with a trial, the offer that starts free;
/// otherwise the simplest offer. The price shown is what she pays each period
/// (the last pricing phase), not the free first phase.
ChosenOffer? chooseOffer(List<ProductDetails> entries, {required bool trial}) {
  if (entries.isEmpty) return null;

  ChosenOffer build(ProductDetails entry) {
    final phases = _phasesOf(entry);
    final token = entry is GooglePlayProductDetails ? entry.offerToken : null;
    return ChosenOffer(
      details: entry,
      price: phases == null || phases.isEmpty
          ? entry.price
          : phases.last.formattedPrice,
      token: token,
    );
  }

  if (trial) {
    for (final entry in entries) {
      final phases = _phasesOf(entry);
      if (phases != null &&
          phases.length > 1 &&
          phases.first.priceAmountMicros == 0) {
        return build(entry);
      }
    }
    return build(entries.first);
  }
  final sorted = [...entries]
    ..sort(
      (a, b) => (_phasesOf(a)?.length ?? 1).compareTo(_phasesOf(b)?.length ?? 1),
    );
  return build(sorted.first);
}
