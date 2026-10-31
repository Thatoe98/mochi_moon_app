import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mochi_moon/features/letters/domain/future_letter.dart';
import 'package:mochi_moon/features/letters/domain/letter_repository.dart';
import 'package:mochi_moon/features/settings/data/local_notifications_reminder_scheduler.dart';
import 'package:timezone/timezone.dart' as tz;

const _channelId = 'future_letters';

/// Letter ids live in [letterIdBase, letterIdBase + 1000), next to the daily
/// reminders (1000–1099) and never overlapping them.
const letterIdBase = 2000;

/// Schedules the "a letter is ready" notification with
/// `flutter_local_notifications`. Like the daily reminders, each one is an
/// absolute instant, so no time-zone database lookup is needed.
class LocalNotificationsLetterNotifier implements LetterNotifier {
  LocalNotificationsLetterNotifier([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  Future<void>? _initialized;

  Future<void> _init() =>
      _initialized ??= _plugin.initialize(settings: notificationInitSettings);

  @override
  Future<void> schedule(
    Map<String, DateTime> openings,
    LetterNotificationTexts texts,
  ) async {
    await _init();
    final pending = await _plugin.pendingNotificationRequests();
    for (final request in pending) {
      if (request.id >= letterIdBase && request.id < letterIdBase + 1000) {
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
    final now = DateTime.now();
    for (final entry in openings.entries) {
      if (!entry.value.isAfter(now)) continue;
      await _plugin.zonedSchedule(
        id: letterNotificationId(entry.key, base: letterIdBase),
        title: texts.title,
        body: texts.body,
        scheduledDate: tz.TZDateTime.from(entry.value.toUtc(), tz.UTC),
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  @override
  Future<void> cancel(String letterId) async {
    await _init();
    await _plugin.cancel(
      id: letterNotificationId(letterId, base: letterIdBase),
    );
  }
}
