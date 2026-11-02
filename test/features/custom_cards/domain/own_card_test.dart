import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/custom_cards/domain/own_card.dart';

OwnCardRejection? _check(
  String text, {
  int count = 0,
  bool premium = false,
  bool isNew = true,
  String art = 'moon_01',
}) => checkOwnCard(
  text,
  art,
  countBefore: count,
  isPremium: premium,
  isNew: isNew,
);

void main() {
  group('checkOwnCard', () {
    test('accepts a short card', () {
      expect(_check('I am enough'), isNull);
    });

    test('rejects an empty or blank card', () {
      expect(_check(''), OwnCardRejection.empty);
      expect(_check('   '), OwnCardRejection.empty);
    });

    test('allows exactly 140 characters and rejects 141', () {
      expect(_check('a' * 140), isNull);
      expect(_check('a' * 141), OwnCardRejection.tooLong);
    });

    test('needs an illustration', () {
      expect(_check('hi', art: ' '), OwnCardRejection.noIllustration);
    });

    test('free users get one card, the second is refused', () {
      expect(_check('x'), isNull);
      expect(_check('x', count: 1), OwnCardRejection.limitReached);
    });

    test('Premium has no limit', () {
      expect(_check('x', count: 50, premium: true), isNull);
    });

    test('editing is never refused for the limit', () {
      expect(_check('x', count: 1, isNew: false), isNull);
    });
  });

  test('toQuote gives a self_love deck card with an own_ id', () {
    final card = OwnCard(
      id: 'abc',
      body: 'I am enough',
      illustrationId: 'moon_01',
      createdAt: DateTime(2026, 10, 31),
    );
    final quote = card.toQuote();

    expect(quote.id, 'own_abc');
    expect(isOwnCardId(quote.id), isTrue);
    expect(quote.category, 'self_love');
    expect(quote.textFor('en'), 'I am enough');
    expect(quote.illustrationId, 'moon_01');
    expect(quote.premium, isFalse);
    expect(isOwnCardId('q_001'), isFalse);
  });

  test('new ids are 20 characters and differ', () {
    final a = newOwnCardId();
    expect(a, hasLength(20));
    expect(newOwnCardId(), isNot(a));
  });
}
