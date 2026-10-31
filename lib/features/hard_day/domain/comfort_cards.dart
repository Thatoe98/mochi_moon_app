import 'package:mochi_moon/core/content/card_of_the_day.dart';
import 'package:mochi_moon/core/content/quote.dart';

/// Categories of the cards the hard-day kit offers (PRD §6.26).
const comfortCategories = {'calm', 'healing'};

/// How many comforting cards the kit shows.
const comfortCardCount = 3;

/// [comfortCardCount] free `calm`/`healing` cards for [date]. The same day
/// always gives the same cards, so the kit does not shuffle under her; a new
/// day starts one card further along. Fewer come back when fewer exist.
List<Quote> comfortCards(List<Quote> quotes, DateTime date) {
  final pool = [
    for (final quote in freeCards(quotes))
      if (comfortCategories.contains(quote.category)) quote,
  ];
  if (pool.isEmpty) return const [];
  final dayNumber = DateTime.utc(
    date.year,
    date.month,
    date.day,
  ).difference(DateTime.utc(1970)).inDays;
  final count = pool.length < comfortCardCount ? pool.length : comfortCardCount;
  return [for (var i = 0; i < count; i++) pool[(dayNumber + i) % pool.length]];
}
