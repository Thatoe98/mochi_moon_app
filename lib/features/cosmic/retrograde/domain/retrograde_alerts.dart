import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/retrogrades.dart';
import 'package:mochi_moon/features/cosmic/retrograde/domain/retrograde_status.dart';

/// Planets that can send a heads-up (PRD §6.6).
const List<Body> retrogradeAlertBodies = mainRetrogradeBodies;

/// Alerts that need Premium (PRD 6.6, M4b): Mercury stays free.
const Set<Body> premiumRetrogradeAlertBodies = {Body.venus, Body.mars};

/// Mercury is on until the user says otherwise; Venus and Mars are off.
const Set<Body> defaultRetrogradeAlertPlanets = {Body.mercury};

/// How far ahead alerts are planned. Stations are weeks apart, so this keeps
/// the next one or two in the window without a long list of pending alarms.
const retrogradeAlertWindowDays = 90;

/// Alerts fire at this local hour: late enough not to wake anyone.
const retrogradeAlertHour = 9;

/// Which moment an alert is about.
enum RetrogradeAlertKind {
  startsTomorrow,
  startsToday,
  endsTomorrow,
  endsToday,
}

/// One notification to schedule: [fireAt] is a local date and time.
class PlannedRetrogradeAlert {
  const PlannedRetrogradeAlert({
    required this.fireAt,
    required this.body,
    required this.kind,
  });

  final DateTime fireAt;
  final Body body;
  final RetrogradeAlertKind kind;
}

/// Localized strings the alert notification needs, resolved by the caller.
class RetrogradeAlertTexts {
  const RetrogradeAlertTexts({
    required this.title,
    required this.channelName,
    required this.channelDescription,
    required this.messages,
  });

  final String title;
  final String channelName;
  final String channelDescription;

  /// The notification body for each kind, with the planet already filled in.
  final String Function(Body body, RetrogradeAlertKind kind) messages;
}

abstract interface class RetrogradeAlertSettingsRepository {
  /// The planets with alerts on; [defaultRetrogradeAlertPlanets] until the
  /// user changes it.
  Future<Set<Body>> load();
  Future<void> save(Set<Body> planets);
}

abstract interface class RetrogradeAlertScheduler {
  /// Replaces every scheduled retrograde alert with [alerts].
  Future<void> schedule(
    List<PlannedRetrogradeAlert> alerts,
    RetrogradeAlertTexts texts,
  );

  Future<void> cancelAll();
}

/// The alerts to schedule: for each chosen planet, the day before and the day
/// of each station (turning retrograde, turning direct), at
/// [retrogradeAlertHour] local time. Alerts already past, or beyond
/// [retrogradeAlertWindowDays], are dropped. Sorted by time.
List<PlannedRetrogradeAlert> planRetrogradeAlerts({
  required DateTime now,
  required Set<Body> planets,
  required Map<Body, List<RetrogradePeriod>> periods,
}) {
  final horizon = now.add(const Duration(days: retrogradeAlertWindowDays));
  final alerts = <PlannedRetrogradeAlert>[];

  void station(
    Body body,
    DateTime stationUtc,
    RetrogradeAlertKind eve,
    RetrogradeAlertKind day,
  ) {
    final local = stationUtc.toLocal();
    final dayOf = DateTime(local.year, local.month, local.day);
    for (final (date, kind) in [
      (DateTime(dayOf.year, dayOf.month, dayOf.day - 1), eve),
      (dayOf, day),
    ]) {
      final fireAt = DateTime(
        date.year,
        date.month,
        date.day,
        retrogradeAlertHour,
      );
      if (fireAt.isAfter(now) && !fireAt.isAfter(horizon)) {
        alerts.add(
          PlannedRetrogradeAlert(fireAt: fireAt, body: body, kind: kind),
        );
      }
    }
  }

  for (final body in planets) {
    for (final period in periods[body] ?? const <RetrogradePeriod>[]) {
      station(
        body,
        period.retrogradeStart,
        RetrogradeAlertKind.startsTomorrow,
        RetrogradeAlertKind.startsToday,
      );
      station(
        body,
        period.retrogradeEnd,
        RetrogradeAlertKind.endsTomorrow,
        RetrogradeAlertKind.endsToday,
      );
    }
  }
  return alerts..sort((a, b) => a.fireAt.compareTo(b.fireAt));
}
