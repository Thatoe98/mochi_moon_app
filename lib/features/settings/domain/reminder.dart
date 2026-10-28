import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mochi_moon/core/content/quote.dart';

part 'reminder.freezed.dart';

/// How many days ahead reminders are scheduled. Android cannot repeat one
/// notification with a different body each day, so the window is rebuilt every
/// time the app opens.
const reminderWindowDays = 14;

/// A wall-clock time of day, local to the device.
@freezed
abstract class ReminderTime with _$ReminderTime {
  const factory ReminderTime(int hour, int minute) = _ReminderTime;

  const ReminderTime._();

  factory ReminderTime.fromMinutes(int minutes) =>
      ReminderTime(minutes ~/ 60 % 24, minutes % 60);

  /// PRD §6.1: the reminder defaults to 08:00 local.
  static const defaultTime = ReminderTime(8, 0);

  int get minutesSinceMidnight => hour * 60 + minute;
}

@freezed
abstract class ReminderSettings with _$ReminderSettings {
  const factory ReminderSettings({
    @Default(false) bool enabled,
    @Default(ReminderTime.defaultTime) ReminderTime time,
  }) = _ReminderSettings;
}

/// One notification to schedule: [fireAt] is a local date and time.
class PlannedReminder {
  const PlannedReminder({
    required this.fireAt,
    required this.quoteId,
    required this.body,
  });

  final DateTime fireAt;
  final String quoteId;
  final String body;
}

/// Localized strings the notification needs; resolved by the caller so the
/// scheduler never touches `BuildContext`.
class ReminderTexts {
  const ReminderTexts({
    required this.title,
    required this.channelName,
    required this.channelDescription,
  });

  final String title;
  final String channelName;
  final String channelDescription;
}

abstract interface class ReminderSettingsRepository {
  Future<ReminderSettings> load();
  Future<void> save(ReminderSettings settings);
}

abstract interface class ReminderScheduler {
  /// Whether notifications are currently allowed, without asking.
  Future<bool> hasPermission();

  /// Asks the system for notification permission; true when granted.
  Future<bool> requestPermission();

  /// Replaces every scheduled reminder with [reminders].
  Future<void> schedule(List<PlannedReminder> reminders, ReminderTexts texts);

  Future<void> cancelAll();
}

/// Reminders for the next [days] days at [time], starting today when that time
/// is still ahead of [now] and tomorrow otherwise.
///
/// Each day carries a fixed "card of the day": the free quotes sorted by id,
/// indexed by the local date, so the same date always gets the same card.
List<PlannedReminder> planReminders({
  required DateTime now,
  required ReminderTime time,
  required List<Quote> quotes,
  required String lang,
  int days = reminderWindowDays,
}) {
  final cards = [
    for (final quote in quotes)
      if (!quote.premium && _firstLine(quote.textFor(lang)).isNotEmpty) quote,
  ]..sort((a, b) => a.id.compareTo(b.id));
  if (cards.isEmpty) return const [];

  final epoch = DateTime.utc(1970);
  var day = DateTime(now.year, now.month, now.day);
  if (!DateTime(
    day.year,
    day.month,
    day.day,
    time.hour,
    time.minute,
  ).isAfter(now)) {
    day = DateTime(day.year, day.month, day.day + 1);
  }

  final reminders = <PlannedReminder>[];
  for (var i = 0; i < days; i++) {
    final date = DateTime(day.year, day.month, day.day + i);
    final dayNumber = DateTime.utc(
      date.year,
      date.month,
      date.day,
    ).difference(epoch).inDays;
    final quote = cards[dayNumber % cards.length];
    reminders.add(
      PlannedReminder(
        fireAt: DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        ),
        quoteId: quote.id,
        body: _firstLine(quote.textFor(lang)),
      ),
    );
  }
  return reminders;
}

String _firstLine(String text) => text.split('\n').first.trim();
