import 'package:mochi_moon/core/content/card_of_the_day.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';

/// Cards a new user tries before signing in (PRD §6.1).
const sampleCardCount = 3;

/// The sample cards: free cards from different categories, so the first taste
/// of the app is varied. Deterministic, and bundled, so it works offline.
/// Fewer than [sampleCardCount] come back when the content has fewer cards.
List<Quote> pickSampleCards(List<Quote> quotes) {
  final free = freeCards(quotes);
  final picked = <Quote>[];
  final categories = <String>{};
  for (final quote in free) {
    if (picked.length == sampleCardCount) break;
    if (categories.add(quote.category)) picked.add(quote);
  }
  for (final quote in free) {
    if (picked.length == sampleCardCount) break;
    if (!picked.contains(quote)) picked.add(quote);
  }
  return picked..sort((a, b) => a.id.compareTo(b.id));
}

/// How many of [samples], from the first, already have an event in [history].
/// A flow that was interrupted resumes here, so no card is recorded twice.
int sampleProgress(List<Quote> samples, List<DeckEvent> history) {
  final seen = {for (final event in history) event.quoteId};
  var done = 0;
  while (done < samples.length && seen.contains(samples[done].id)) {
    done++;
  }
  return done;
}
