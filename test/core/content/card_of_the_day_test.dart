import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/card_of_the_day.dart';
import 'package:mochi_moon/core/content/quote.dart';

Quote _quote(String id, {String text = 'Words.', bool premium = false}) =>
    Quote(id: id, text: {'en': text}, category: 'self_love', premium: premium);

void main() {
  final quotes = [_quote('b'), _quote('a'), _quote('c')];

  test('gives a date the same card whatever the time or the order', () {
    final morning = cardOfTheDay(quotes, DateTime(2026, 10, 28, 6));
    final night = cardOfTheDay(
      quotes.reversed.toList(),
      DateTime(2026, 10, 28, 23),
    );

    expect(morning, isNotNull);
    expect(night?.id, morning?.id);
  });

  test('walks through every free card on consecutive days', () {
    final ids = [
      for (var i = 0; i < 6; i++)
        cardOfTheDay(quotes, DateTime(2026, 10, 28 + i))!.id,
    ];

    expect(ids.sublist(0, 3).toSet(), {'a', 'b', 'c'});
    expect(ids.sublist(3), ids.sublist(0, 3));
  });

  test('skips premium cards and cards without text', () {
    final card = cardOfTheDay([
      _quote('vip', premium: true),
      _quote('blank', text: ' '),
      _quote('free'),
    ], DateTime(2026, 10, 28));

    expect(card?.id, 'free');
  });

  test('is null without a usable card', () {
    expect(cardOfTheDay(const [], DateTime(2026, 10, 28)), isNull);
    expect(
      cardOfTheDay([_quote('vip', premium: true)], DateTime(2026, 10, 28)),
      isNull,
    );
  });

  test('firstLine keeps only the first line', () {
    expect(firstLine(' One. \nTwo.'), 'One.');
  });
}
