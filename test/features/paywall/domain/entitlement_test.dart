import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/paywall/domain/entitlement.dart';

void main() {
  final now = DateTime.utc(2026, 11, 2);

  test('missing or malformed data means no Premium', () {
    expect(Entitlement.fromMap(null).isPremiumAt(now), isFalse);
    expect(Entitlement.fromMap('yes').isPremiumAt(now), isFalse);
    expect(Entitlement.fromMap({'premium': 'true'}).isPremiumAt(now), isFalse);
  });

  test('premium without an end date stays on', () {
    final value = Entitlement.fromMap({'premium': true});
    expect(value.isPremiumAt(now), isTrue);
  });

  test('a period that has ended counts as off', () {
    final value = Entitlement.fromMap({
      'premium': true,
      'productId': 'mochi_premium_monthly',
      'expiresAt': DateTime.utc(2026, 10, 31),
    });
    expect(value.isPremiumAt(now), isFalse);
    expect(value.productId, 'mochi_premium_monthly');
  });

  test('a future end date keeps it on', () {
    final value = Entitlement.fromMap({
      'premium': true,
      'expiresAt': DateTime.utc(2026, 12, 2),
    });
    expect(value.isPremiumAt(now), isTrue);
  });

  test('report credits are never negative or fractional', () {
    expect(Entitlement.fromMap({'reportCredits': -2}).reportCredits, 0);
    expect(Entitlement.fromMap({'reportCredits': 1.5}).reportCredits, 0);
    expect(Entitlement.fromMap({'reportCredits': 3}).reportCredits, 3);
  });
}
