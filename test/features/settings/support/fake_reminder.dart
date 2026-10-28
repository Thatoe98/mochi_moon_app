import 'package:mochi_moon/features/settings/domain/reminder.dart';

class FakeReminderSettingsRepository implements ReminderSettingsRepository {
  FakeReminderSettingsRepository([this.settings = const ReminderSettings()]);

  ReminderSettings settings;

  @override
  Future<ReminderSettings> load() async => settings;

  @override
  Future<void> save(ReminderSettings settings) async =>
      this.settings = settings;
}

/// Records what would have been scheduled.
class FakeReminderScheduler implements ReminderScheduler {
  FakeReminderScheduler({this.allowed = true});

  /// What the system would answer to a permission request.
  bool allowed;

  /// Whether permission was granted before the request.
  bool granted = false;

  int permissionRequests = 0;
  int cancels = 0;
  List<PlannedReminder> scheduled = const [];
  ReminderTexts? texts;

  @override
  Future<bool> hasPermission() async => granted;

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    granted = allowed;
    return allowed;
  }

  @override
  Future<void> schedule(
    List<PlannedReminder> reminders,
    ReminderTexts texts,
  ) async {
    scheduled = reminders;
    this.texts = texts;
  }

  @override
  Future<void> cancelAll() async {
    cancels++;
    scheduled = const [];
  }
}
