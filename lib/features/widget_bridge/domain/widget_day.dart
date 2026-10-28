import 'package:mochi_moon/core/content/card_of_the_day.dart';
import 'package:mochi_moon/core/content/quote.dart';

/// How many days ahead the widget is stocked. The native side picks the entry
/// for the current date, so the widget changes at midnight without the app.
const widgetWindowDays = 14;

/// What the widget shows on one local [date]: the short form of the card.
class WidgetDay {
  const WidgetDay({
    required this.date,
    required this.quoteId,
    required this.category,
    required this.text,
  });

  /// Local midnight at the start of the day.
  final DateTime date;
  final String quoteId;
  final String category;
  final String text;
}

abstract interface class WidgetPublisher {
  /// Replaces what the widget shows with [days] and refreshes it. The widget
  /// is also refreshed at the start of every day after the first.
  Future<void> publish(List<WidgetDay> days);
}

/// The widget's days from today on, one per local date, in [lang].
List<WidgetDay> planWidgetDays({
  required DateTime now,
  required List<Quote> quotes,
  required String lang,
  int days = widgetWindowDays,
}) {
  final widgetDays = <WidgetDay>[];
  for (var i = 0; i < days; i++) {
    final date = DateTime(now.year, now.month, now.day + i);
    final quote = cardOfTheDay(quotes, date);
    if (quote == null) return const [];
    widgetDays.add(
      WidgetDay(
        date: date,
        quoteId: quote.id,
        category: quote.category,
        text: firstLine(quote.textFor(lang)),
      ),
    );
  }
  return widgetDays;
}
