import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mochi_moon/features/letters/domain/weekly_letter_notifier.dart';
import 'package:mochi_moon/features/settings/data/local_notifications_reminder_scheduler.dart';
import 'package:timezone/timezone.dart' as tz;

const _channelId = 'weekly_letter';

/// Weekly-letter ids live in [weeklyLetterIdBase, weeklyLetterIdBase + 100),
/// clear of the daily reminders (1000–1099) and the future letters (2000+).
const weeklyLetterIdBase = 3000;
const _idRange = 100;

/// Schedules the Sunday notification with `flutter_local_notifications`. Like
/// the other reminders, each one is an absolute instant.
class LocalNotificationsWeeklyLetterNotifier implements WeeklyLetterNotifier {
  LocalNotificationsWeeklyLetterNotifier([
    FlutterLocalNotificationsPlugin? plugin,
  ]) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  Future<void>? _initialized;

  Future<void> _init() =>
      _initialized ??= _plugin.initialize(settings: notificationInitSettings);

  @override
  Future<void> schedule(List<DateTime> at, WeeklyLetterTexts texts) async {
    await _init();
    final pending = await _plugin.pendingNotificationRequests();
    for (final request in pending) {
      if (request.id >= weeklyLetterIdBase &&
          request.id < weeklyLetterIdBase + _idRange) {
        await _plugin.cancel(id: request.id);
      }
    }
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        texts.channelName,
        channelDescription: texts.channelDescription,
      ),
      iOS: const DarwinNotificationDetails(),
    );
    for (var i = 0; i < at.length && i < _idRange; i++) {
      await _plugin.zonedSchedule(
        id: weeklyLetterIdBase + i,
        title: texts.title,
        body: texts.body,
        scheduledDate: tz.TZDateTime.from(at[i].toUtc(), tz.UTC),
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }
}
