import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/premium/free_limits.dart';
import 'package:mochi_moon/features/partners/domain/partner.dart';

void main() {
  test('free limits match PRD §6.13', () {
    expect(FreeLimits.deckCardsPerDay, 5);
    expect(FreeLimits.ownCards, 1);
    expect(FreeLimits.sealedLetters, 1);
    expect(FreeLimits.partners, 1);
    expect(FreeLimits.moodMonths, 2);
  });

  test('the partner limit follows the central one', () {
    expect(partnerLimit(hasPremium: false), FreeLimits.partners);
  });
}
