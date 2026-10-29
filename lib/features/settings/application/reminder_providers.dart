import 'dart:ui';

import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/settings/application/language_providers.dart';
import 'package:mochi_moon/features/settings/data/local_notifications_reminder_scheduler.dart';
import 'package:mochi_moon/features/settings/data/prefs_reminder_settings_repository.dart';
import 'package:mochi_moon/features/settings/domain/reminder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'reminder_providers.g.dart';

@Riverpod(keepAlive: true)
ReminderSettingsRepository reminderSettingsRepository(Ref ref) =>
    PrefsReminderSettingsRepository(SharedPreferencesAsync());

@Riverpod(keepAlive: true)
ReminderScheduler reminderScheduler(Ref ref) =>
    LocalNotificationsReminderScheduler();

/// Language of the notification text: the app language. Overridden in tests.
@Riverpod(keepAlive: true)
String reminderLanguage(Ref ref) => ref.watch(effectiveLanguageProvider);

/// The user's reminder choice, kept in sync with what is scheduled.
@Riverpod(keepAlive: true)
class ReminderController extends _$ReminderController {
  @override
  Future<ReminderSettings> build() =>
      ref.watch(reminderSettingsRepositoryProvider).load();

  /// Turns the reminder on after asking the system for permission. Returns
  /// false, leaving the reminder off, when permission is refused.
  Future<bool> enable() async {
    final scheduler = ref.read(reminderSchedulerProvider);
    if (!await scheduler.requestPermission()) return false;
    await _save((await future).copyWith(enabled: true));
    return true;
  }

  Future<void> disable() async =>
      await _save((await future).copyWith(enabled: false));

  Future<void> setTime(ReminderTime time) async =>
      await _save((await future).copyWith(time: time));

  /// Rebuilds the scheduled window from the saved settings. Called when the
  /// app opens so the 14 days ahead never run dry.
  Future<void> resync() async => await _apply(await future);

  Future<void> _save(ReminderSettings settings) async {
    await ref.read(reminderSettingsRepositoryProvider).save(settings);
    state = AsyncData(settings);
    await _apply(settings);
  }

  Future<void> _apply(ReminderSettings settings) async {
    final scheduler = ref.read(reminderSchedulerProvider);
    if (!settings.enabled || !await scheduler.hasPermission()) {
      await scheduler.cancelAll();
      return;
    }
    final lang = ref.read(reminderLanguageProvider);
    final quotes = await ref.read(quotesProvider.future);
    final l10n = lookupAppLocalizations(Locale(lang));
    await scheduler.schedule(
      planReminders(
        now: ref.read(clockProvider)(),
        time: settings.time,
        quotes: quotes,
        lang: lang,
      ),
      ReminderTexts(
        title: l10n.reminderNotificationTitle,
        channelName: l10n.reminderChannelName,
        channelDescription: l10n.reminderChannelDescription,
      ),
    );
  }
}

/// Re-plans the reminder window once per app run and again when the app
/// language changes, so the notification text follows it. Watched from the
/// app root.
@Riverpod(keepAlive: true)
Future<void> reminderSync(Ref ref) {
  ref.watch(reminderLanguageProvider);
  return ref.read(reminderControllerProvider.notifier).resync();
}
