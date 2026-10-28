import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/features/settings/domain/reminder.dart';

Quote _quote(String id, String en, {String? my, bool premium = false}) => Quote(
  id: id,
  text: {'en': en, 'my': ?my},
  category: 'self_love',
  premium: premium,
);

final List<Quote> _quotes = [
  _quote('b', 'Second.'),
  _quote('a', 'First.', my: 'ပထမ'),
  _quote('c', 'Third.\nA second line.'),
];

const ReminderTime _eight = ReminderTime.defaultTime;

void main() {
  group('planReminders', () {
    test('plans 14 days at the chosen time', () {
      final plan = planReminders(
        now: DateTime(2026, 10, 28, 7),
        time: _eight,
        quotes: _quotes,
        lang: 'en',
      );

      expect(plan, hasLength(reminderWindowDays));
      expect(plan.first.fireAt, DateTime(2026, 10, 28, 8));
      expect(plan.last.fireAt, DateTime(2026, 11, 10, 8));
    });

    test('starts tomorrow once the time has passed', () {
      final plan = planReminders(
        now: DateTime(2026, 10, 28, 8),
        time: _eight,
        quotes: _quotes,
        lang: 'en',
      );

      expect(plan.first.fireAt, DateTime(2026, 10, 29, 8));
    });

    test('gives a date the same card whenever it is planned', () {
      final morning = planReminders(
        now: DateTime(2026, 10, 28, 6),
        time: _eight,
        quotes: _quotes,
        lang: 'en',
      );
      final evening = planReminders(
        now: DateTime(2026, 10, 28, 21),
        time: const ReminderTime(20, 30),
        quotes: _quotes.reversed.toList(),
        lang: 'en',
      );

      // 29 October is in both plans, whatever the time or the quote order.
      String cardOn(List<PlannedReminder> plan) =>
          plan.firstWhere((r) => r.fireAt.day == 29).quoteId;
      expect(cardOn(morning), cardOn(evening));
    });

    test('walks through the cards day by day', () {
      final plan = planReminders(
        now: DateTime(2026, 10, 28, 6),
        time: _eight,
        quotes: _quotes,
        lang: 'en',
      );

      final ids = plan.take(6).map((r) => r.quoteId).toList();
      expect(ids.sublist(0, 3).toSet(), {'a', 'b', 'c'});
      expect(ids.sublist(3), ids.sublist(0, 3));
    });

    test('uses only the first line of the text', () {
      final plan = planReminders(
        now: DateTime(2026, 10, 28, 6),
        time: _eight,
        quotes: [_quote('c', 'Third.\nA second line.')],
        lang: 'en',
      );

      expect(plan.first.body, 'Third.');
    });

    test('uses the requested language and falls back to English', () {
      final plan = planReminders(
        now: DateTime(2026, 10, 28, 6),
        time: _eight,
        quotes: [
          _quote('a', 'First.', my: 'ပထမ'),
          _quote('b', 'Second.'),
        ],
        lang: 'my',
      );

      expect(plan.map((r) => r.body).toSet(), {'ပထမ', 'Second.'});
    });

    test('never picks a premium card', () {
      final plan = planReminders(
        now: DateTime(2026, 10, 28, 6),
        time: _eight,
        quotes: [_quote('free', 'Free.'), _quote('vip', 'Vip.', premium: true)],
        lang: 'en',
      );

      expect(plan.map((r) => r.quoteId).toSet(), {'free'});
    });

    test('plans nothing without usable cards', () {
      expect(
        planReminders(
          now: DateTime(2026, 10, 28),
          time: _eight,
          quotes: [_quote('vip', 'Vip.', premium: true)],
          lang: 'en',
        ),
        isEmpty,
      );
      expect(
        planReminders(
          now: DateTime(2026, 10, 28),
          time: _eight,
          quotes: const [],
          lang: 'en',
        ),
        isEmpty,
      );
    });

    test('crosses month and year ends', () {
      final plan = planReminders(
        now: DateTime(2026, 12, 30, 9),
        time: _eight,
        quotes: _quotes,
        lang: 'en',
      );

      expect(plan.first.fireAt, DateTime(2026, 12, 31, 8));
      expect(plan[1].fireAt, DateTime(2027, 1, 1, 8));
    });
  });

  test('ReminderTime round-trips through minutes', () {
    expect(ReminderTime.fromMinutes(8 * 60 + 5), const ReminderTime(8, 5));
    expect(const ReminderTime(23, 59).minutesSinceMidnight, 1439);
  });
}
