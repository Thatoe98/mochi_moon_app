import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/features/widget_bridge/domain/widget_day.dart';

Quote _quote(String id, String en, {String? my}) =>
    Quote(id: id, text: {'en': en, 'my': ?my}, category: 'self_love');

void main() {
  final quotes = [
    _quote('a', 'First.\nMore.', my: 'ပထမ'),
    _quote('b', 'Second.'),
  ];

  test('plans one day per local date starting today', () {
    final days = planWidgetDays(
      now: DateTime(2026, 10, 28, 15, 30),
      quotes: quotes,
      lang: 'en',
    );

    expect(days, hasLength(widgetWindowDays));
    expect(days.first.date, DateTime(2026, 10, 28));
    expect(days.last.date, DateTime(2026, 11, 10));
  });

  test('crosses month and year ends', () {
    final days = planWidgetDays(
      now: DateTime(2026, 12, 31, 23, 59),
      quotes: quotes,
      lang: 'en',
      days: 2,
    );

    expect(days[1].date, DateTime(2027));
  });

  test('shows the short form in the requested language, else English', () {
    final english = planWidgetDays(
      now: DateTime(2026, 10, 28),
      quotes: quotes,
      lang: 'en',
    );
    final burmese = planWidgetDays(
      now: DateTime(2026, 10, 28),
      quotes: quotes,
      lang: 'my',
    );

    expect(english.map((d) => d.text).toSet(), {'First.', 'Second.'});
    expect(burmese.map((d) => d.text).toSet(), {'ပထမ', 'Second.'});
  });

  test('alternates between the free cards day by day', () {
    final days = planWidgetDays(
      now: DateTime(2026, 10, 28),
      quotes: quotes,
      lang: 'en',
      days: 4,
    );

    expect(days[0].quoteId, days[2].quoteId);
    expect(days[0].quoteId, isNot(days[1].quoteId));
  });

  test('plans nothing without usable cards', () {
    expect(
      planWidgetDays(now: DateTime(2026, 10, 28), quotes: const [], lang: 'en'),
      isEmpty,
    );
  });
}
