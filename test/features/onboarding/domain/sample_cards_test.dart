import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/onboarding/domain/sample_cards.dart';

Quote quote(
  String id,
  String category, {
  bool premium = false,
  String en = 'Soft moon',
}) => Quote(id: id, text: {'en': en}, category: category, premium: premium);

DeckEvent event(String quoteId) => DeckEvent(
  id: 1,
  quoteId: quoteId,
  action: DeckAction.skipped,
  at: DateTime(2026, 10, 28),
);

List<String> ids(List<Quote> quotes) => [for (final q in quotes) q.id];

void main() {
  group('pickSampleCards', () {
    test('takes cards from different categories', () {
      final picked = pickSampleCards([
        quote('a1', 'calm'),
        quote('a2', 'calm'),
        quote('b1', 'healing'),
        quote('c1', 'confidence'),
        quote('c2', 'confidence'),
      ]);

      expect(ids(picked), ['a1', 'b1', 'c1']);
    });

    test('does not depend on the order of the content', () {
      final quotes = [
        quote('b1', 'healing'),
        quote('a1', 'calm'),
        quote('c1', 'confidence'),
      ];

      expect(
        ids(pickSampleCards(quotes)),
        ids(pickSampleCards(quotes.reversed.toList())),
      );
    });

    test('leaves out premium cards and cards without English text', () {
      final picked = pickSampleCards([
        quote('a1', 'calm', premium: true),
        quote('a2', 'healing', en: ''),
        quote('a3', 'confidence'),
      ]);

      expect(ids(picked), ['a3']);
    });

    test('fills up from repeated categories when there are too few', () {
      final picked = pickSampleCards([
        quote('a1', 'calm'),
        quote('a2', 'calm'),
        quote('a3', 'calm'),
        quote('a4', 'calm'),
      ]);

      expect(ids(picked), ['a1', 'a2', 'a3']);
    });

    test('returns what there is when the content is short or empty', () {
      expect(ids(pickSampleCards([quote('a1', 'calm')])), ['a1']);
      expect(pickSampleCards(const []), isEmpty);
    });
  });

  group('sampleProgress', () {
    final samples = [
      quote('a', 'calm'),
      quote('b', 'healing'),
      quote('c', 'confidence'),
    ];

    test('starts at the first card with no history', () {
      expect(sampleProgress(samples, const []), 0);
    });

    test('resumes after the cards already done', () {
      expect(sampleProgress(samples, [event('a'), event('b')]), 2);
    });

    test('ignores other cards and gaps', () {
      expect(sampleProgress(samples, [event('zzz'), event('b')]), 0);
    });

    test('is done when every card has an event', () {
      expect(sampleProgress(samples, [event('a'), event('b'), event('c')]), 3);
    });
  });
}
