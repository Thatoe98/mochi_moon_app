/// What the server says she owns (PRD §6.13, §8.1 `entitlement`).
///
/// Only the server writes it, after it checks a Play purchase. The app reads
/// it and never decides on its own that someone is Premium.
class Entitlement {
  const Entitlement({
    this.premium = false,
    this.productId,
    this.expiresAt,
    this.reportCredits = 0,
  });

  /// Reads the `entitlement` map of the user document. Anything missing or of
  /// the wrong type means no Premium.
  factory Entitlement.fromMap(Object? raw) {
    if (raw is! Map) return Entitlement.none;
    final premium = raw['premium'];
    final productId = raw['productId'];
    final credits = raw['reportCredits'];
    final expires = raw['expiresAt'];
    return Entitlement(
      premium: premium == true,
      productId: productId is String ? productId : null,
      expiresAt: switch (expires) {
        final DateTime date => date,
        // Firestore's Timestamp has toDate(); the data layer converts it
        // before calling, so only DateTime arrives here.
        _ => null,
      },
      reportCredits: credits is int && credits > 0 ? credits : 0,
    );
  }

  /// No Premium, no credits.
  static const none = Entitlement();

  final bool premium;
  final String? productId;

  /// When the current period ends; null when the server gave no date.
  final DateTime? expiresAt;

  /// Compatibility report credits she has bought and not used.
  final int reportCredits;

  /// Whether Premium is on at [now]. A period that has ended counts as off
  /// even if the server has not rewritten the flag yet.
  bool isPremiumAt(DateTime now) =>
      premium && (expiresAt == null || expiresAt!.isAfter(now));
}
