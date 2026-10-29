import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mochi_moon/features/cosmic/retrograde/domain/retrograde_alerts.dart';
import 'package:mochi_moon/features/settings/data/local_notifications_reminder_scheduler.dart';
import 'package:timezone/timezone.dart' as tz;

const _channelId = 'retrograde_alerts';

/// Alert ids live in [_idBase, _idBase + _idRange), clear of the daily
/// reminder's 1000-1099, so cancelling one set never touches the other.
const _idBase = 2000;
const _idRange = 100;

/// Schedules retrograde alerts the same way the daily reminder is scheduled:
/// each one an absolute UTC instant with an inexact alarm, so no exact-alarm
/// permission is needed. Notification permission is handled by the reminder
/// scheduler; this one only schedules and cancels.
class LocalNotificationsRetrogradeAlertScheduler
    implements RetrogradeAlertScheduler {
  LocalNotificationsRetrogradeAlertScheduler([
    FlutterLocalNotificationsPlugin? plugin,
  ]) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  Future<void>? _initialized;

  Future<void> _init() =>
      _initialized ??= _plugin.initialize(settings: notificationInitSettings);

  @override
  Future<void> schedule(
    List<PlannedRetrogradeAlert> alerts,
    RetrogradeAlertTexts texts,
  ) async {
    await _init();
    await cancelAll();
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        texts.channelName,
        channelDescription: texts.channelDescription,
      ),
      iOS: const DarwinNotificationDetails(),
    );
    for (var i = 0; i < alerts.length && i < _idRange; i++) {
      final alert = alerts[i];
      await _plugin.zonedSchedule(
        id: _idBase + i,
        title: texts.title,
        body: texts.messages(alert.body, alert.kind),
        scheduledDate: tz.TZDateTime.from(alert.fireAt.toUtc(), tz.UTC),
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  @override
  Future<void> cancelAll() async {
    await _init();
    final pending = await _plugin.pendingNotificationRequests();
    for (final request in pending) {
      if (request.id >= _idBase && request.id < _idBase + _idRange) {
        await _plugin.cancel(id: request.id);
      }
    }
  }
}
