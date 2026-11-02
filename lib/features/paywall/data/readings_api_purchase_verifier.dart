import 'package:mochi_moon/core/network/readings_api.dart';
import 'package:mochi_moon/features/paywall/domain/purchase_catalog.dart';

/// `POST /purchases/verify` on the Readings API (PRD §8.2). The server asks
/// Google Play about the token and writes the entitlement to Firestore.
class ReadingsApiPurchaseVerifier implements PurchaseVerifier {
  const ReadingsApiPurchaseVerifier(this._api);

  /// Null while the build has no Readings API address.
  final ReadingsApi? _api;

  @override
  Future<bool> verify({
    required String productId,
    required String token,
  }) async {
    final api = _api;
    if (api == null) return false;
    try {
      await api.postJson('purchases/verify', {
        'productId': productId,
        'purchaseToken': token,
      });
      return true;
    } on Object {
      // Offline or refused: the purchase stays unacknowledged and the store
      // delivers it again on the next start.
      return false;
    }
  }
}
