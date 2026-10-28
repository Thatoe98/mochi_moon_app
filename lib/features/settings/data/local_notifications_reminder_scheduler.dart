import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mochi_moon/features/settings/domain/reminder.dart';
import 'package:timezone/timezone.dart' as tz;

const _channelId = 'daily_reminder';

/// Reminder ids live in [_idBase, _idBase + _idRange) so cancelling them never
/// touches other notifications added later (retrograde alerts, §6.6).
const _idBase = 1000;
const _idRange = 100;

/// Schedules reminders with `flutter_local_notifications`.
///
/// Each reminder is an absolute instant: the local time is converted to UTC and
/// given to the plugin as a UTC `TZDateTime`, so no device time-zone database
/// lookup is needed. Inexact alarms are enough for a morning nudge and avoid
/// the exact-alarm permission.
class LocalNotificationsReminderScheduler implements ReminderScheduler {
  LocalNotificationsReminderScheduler([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  Future<void>? _initialized;

  Future<void> _init() => _initialized ??= _plugin.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestSoundPermission: false,
        requestBadgePermission: false,
      ),
    ),
  );

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  IOSFlutterLocalNotificationsPlugin? get _ios => _plugin
      .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin
      >();

  @override
  Future<bool> hasPermission() async {
    await _init();
    if (_android case final android?) {
      return await android.areNotificationsEnabled() ?? false;
    }
    if (_ios case final ios?) {
      final options = await ios.checkPermissions();
      return options?.isEnabled ?? false;
    }
    return false;
  }

  @override
  Future<bool> requestPermission() async {
    await _init();
    if (_android case final android?) {
      return await android.requestNotificationsPermission() ?? false;
    }
    if (_ios case final ios?) {
      return await ios.requestPermissions(alert: true, sound: true) ?? false;
    }
    return false;
  }

  @override
  Future<void> schedule(
    List<PlannedReminder> reminders,
    ReminderTexts texts,
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
    for (var i = 0; i < reminders.length && i < _idRange; i++) {
      final reminder = reminders[i];
      await _plugin.zonedSchedule(
        id: _idBase + i,
        title: texts.title,
        body: reminder.body,
        scheduledDate: tz.TZDateTime.from(reminder.fireAt.toUtc(), tz.UTC),
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: reminder.quoteId,
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
