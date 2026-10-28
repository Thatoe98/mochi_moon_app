import 'package:mochi_moon/core/content/quote.dart';

/// First line of [text], trimmed. Notifications and the home-screen widget
/// show only this short form of a card.
String firstLine(String text) => text.split('\n').first.trim();

/// The cards free users can be shown: not premium and with English text (the
/// source of truth), sorted by id so the order never depends on the content
/// file.
List<Quote> freeCards(List<Quote> quotes) => [
  for (final quote in quotes)
    if (!quote.premium && firstLine(quote.textFor('en')).isNotEmpty) quote,
]..sort((a, b) => a.id.compareTo(b.id));

/// The card of [date], indexed by the local date over [freeCards], so a date
/// always gets the same card whatever the time, the language or the order of
/// [quotes].
///
/// Returns null when there is no free card. Reminders, the home-screen widget
/// and the deck all use this, so they agree on today's card.
Quote? cardOfTheDay(List<Quote> quotes, DateTime date) {
  final cards = freeCards(quotes);
  if (cards.isEmpty) return null;

  final dayNumber = DateTime.utc(
    date.year,
    date.month,
    date.day,
  ).difference(DateTime.utc(1970)).inDays;
  return cards[dayNumber % cards.length];
}
