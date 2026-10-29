import 'dart:ui';

import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/retrograde/application/retrograde_providers.dart';
import 'package:mochi_moon/features/cosmic/retrograde/data/local_notifications_retrograde_alert_scheduler.dart';
import 'package:mochi_moon/features/cosmic/retrograde/data/prefs_retrograde_alert_settings_repository.dart';
import 'package:mochi_moon/features/cosmic/retrograde/domain/retrograde_alerts.dart';
import 'package:mochi_moon/features/cosmic/retrograde/presentation/retrograde_labels.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'retrograde_alert_providers.g.dart';

@Riverpod(keepAlive: true)
RetrogradeAlertSettingsRepository retrogradeAlertSettingsRepository(Ref ref) =>
    PrefsRetrogradeAlertSettingsRepository(SharedPreferencesAsync());

@Riverpod(keepAlive: true)
RetrogradeAlertScheduler retrogradeAlertScheduler(Ref ref) =>
    LocalNotificationsRetrogradeAlertScheduler();

/// The planets the user wants a heads-up for, kept in sync with what is
/// scheduled. Notification permission comes from the reminder scheduler, the
/// one place the app asks for it.
@Riverpod(keepAlive: true)
class RetrogradeAlertController extends _$RetrogradeAlertController {
  @override
  Future<Set<Body>> build() =>
      ref.watch(retrogradeAlertSettingsRepositoryProvider).load();

  /// Turns [body]'s alerts on or off. Turning on asks the system for
  /// permission first; returns false, leaving it off, when that is refused.
  Future<bool> setEnabled(Body body, {required bool on}) async {
    if (on && !await ref.read(reminderSchedulerProvider).requestPermission()) {
      return false;
    }
    final planets = {...await future};
    if (on) {
      planets.add(body);
    } else {
      planets.remove(body);
    }
    await ref.read(retrogradeAlertSettingsRepositoryProvider).save(planets);
    state = AsyncData(planets);
    await _apply(planets);
    return true;
  }

  /// Re-plans the alerts from the saved choice. Called when the app opens so
  /// the next stations are always scheduled.
  Future<void> resync() async => await _apply(await future);

  Future<void> _apply(Set<Body> planets) async {
    final scheduler = ref.read(retrogradeAlertSchedulerProvider);
    if (planets.isEmpty ||
        !await ref.read(reminderSchedulerProvider).hasPermission()) {
      await scheduler.cancelAll();
      return;
    }
    final overview = await ref.read(retrogradeOverviewProvider.future);
    final l10n = lookupAppLocalizations(
      Locale(ref.read(reminderLanguageProvider)),
    );
    await scheduler.schedule(
      planRetrogradeAlerts(
        now: ref.read(clockProvider)(),
        planets: planets,
        periods: overview.periods,
      ),
      RetrogradeAlertTexts(
        title: l10n.retroAlertNotificationTitle,
        channelName: l10n.retroAlertChannelName,
        channelDescription: l10n.retroAlertChannelDescription,
        messages: (body, kind) {
          final planet = retrogradePlanetLabel(l10n, body);
          return switch (kind) {
            RetrogradeAlertKind.startsTomorrow => l10n.retroAlertStartsTomorrow(
              planet,
            ),
            RetrogradeAlertKind.startsToday => l10n.retroAlertStartsToday(
              planet,
            ),
            RetrogradeAlertKind.endsTomorrow => l10n.retroAlertEndsTomorrow(
              planet,
            ),
            RetrogradeAlertKind.endsToday => l10n.retroAlertEndsToday(planet),
          };
        },
      ),
    );
  }
}

/// Re-plans the alerts once per app run and again when the app language
/// changes, so the text follows it. A calendar that cannot be built leaves the
/// previous alerts in place rather than failing the app. Watched from the app
/// root.
@Riverpod(keepAlive: true)
Future<void> retrogradeAlertSync(Ref ref) async {
  ref.watch(reminderLanguageProvider);
  try {
    await ref.read(retrogradeAlertControllerProvider.notifier).resync();
  } on Object {
    // Scanning the year failed; the next app open tries again.
  }
}
