import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/features/hard_day/domain/comfort_cards.dart';

Quote _q(String id, String category, {bool premium = false}) => Quote(
  id: id,
  text: {'en': 'Words $id'},
  category: category,
  premium: premium,
);

void main() {
  final quotes = [
    for (var i = 0; i < 5; i++) _q('calm$i', 'calm'),
    for (var i = 0; i < 5; i++) _q('heal$i', 'healing'),
    _q('love', 'self_love'),
    _q('paidcalm', 'calm', premium: true),
  ];

  test('gives three calm or healing free cards', () {
    final cards = comfortCards(quotes, DateTime(2026, 10, 31));

    expect(cards, hasLength(3));
    expect(
      cards.map((q) => q.category).toSet().difference({'calm', 'healing'}),
      isEmpty,
    );
    expect(cards.map((q) => q.id), isNot(contains('paidcalm')));
  });

  test('the same day gives the same cards at any hour', () {
    final morning = comfortCards(quotes, DateTime(2026, 10, 31, 7));
    final night = comfortCards(quotes, DateTime(2026, 10, 31, 23));

    expect(morning.map((q) => q.id), night.map((q) => q.id));
  });

  test('the next day moves along', () {
    final today = comfortCards(quotes, DateTime(2026, 10, 31));
    final tomorrow = comfortCards(quotes, DateTime(2026, 11));

    expect(tomorrow.map((q) => q.id), isNot(today.map((q) => q.id)));
  });

  test('fewer cards when fewer exist, none when none', () {
    expect(
      comfortCards([_q('a', 'calm')], DateTime(2026, 10, 31)),
      hasLength(1),
    );
    expect(
      comfortCards([_q('a', 'self_love')], DateTime(2026, 10, 31)),
      isEmpty,
    );
  });
}
