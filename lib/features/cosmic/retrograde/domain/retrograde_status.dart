import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/retrogrades.dart';

/// The planets with a retrograde calendar, nearest first (PRD §6.8).
const retrogradeBodies = <Body>[
  Body.mercury,
  Body.venus,
  Body.mars,
  Body.jupiter,
  Body.saturn,
];

/// The planets shown up front; the rest sit under "More".
const mainRetrogradeBodies = <Body>[Body.mercury, Body.venus, Body.mars];

/// The retrograde periods of every planet, ordered by time.
class RetrogradeOverview {
  const RetrogradeOverview({required this.now, required this.periods});

  /// The instant the overview was made for.
  final DateTime now;

  /// Periods of each planet in [retrogradeBodies], earliest first.
  final Map<Body, List<RetrogradePeriod>> periods;

  List<RetrogradePeriod> of(Body body) => periods[body] ?? const [];
}

/// Where one planet stands: turned back, or waiting for its next retrograde.
sealed class RetrogradeStatus {
  const RetrogradeStatus(this.period);

  final RetrogradePeriod period;
}

/// The planet is between its two stations.
class IsRetrograde extends RetrogradeStatus {
  const IsRetrograde(super.period);

  /// The day it turns direct.
  DateTime get until => period.retrogradeEnd;
}

/// The planet is moving forward; [period] is the next retrograde.
class NextRetrograde extends RetrogradeStatus {
  const NextRetrograde(super.period, {required this.daysAway});

  /// Whole local calendar days until the station, 0 for today.
  final int daysAway;

  DateTime get starts => period.retrogradeStart;
}

/// The status of [body] at [now], or null when [periods] has neither a current
/// nor a later retrograde for it.
RetrogradeStatus? retrogradeStatus(
  Body body,
  DateTime now,
  List<RetrogradePeriod> periods,
) {
  final nowUtc = now.toUtc();
  for (final period in periods) {
    if (period.body != body) continue;
    if (period.isRetrogradeAt(nowUtc)) return IsRetrograde(period);
  }
  RetrogradePeriod? next;
  for (final period in periods) {
    if (period.body != body || !period.retrogradeStart.isAfter(nowUtc)) {
      continue;
    }
    if (next == null || period.retrogradeStart.isBefore(next.retrogradeStart)) {
      next = period;
    }
  }
  if (next == null) return null;
  return NextRetrograde(
    next,
    daysAway: _daysBetween(now, next.retrogradeStart),
  );
}

/// Merges [periods] of several calendars: one entry per retrograde, earliest
/// first, so a period seen by two neighbouring years is not listed twice.
List<RetrogradePeriod> mergePeriods(Iterable<RetrogradePeriod> periods) {
  final seen = <(Body, DateTime)>{};
  final merged = <RetrogradePeriod>[];
  for (final period in periods) {
    if (seen.add((period.body, period.retrogradeStart))) merged.add(period);
  }
  return merged..sort((a, b) => a.preShadowStart.compareTo(b.preShadowStart));
}

int _daysBetween(DateTime now, DateTime utc) {
  final from = DateTime(
    now.toLocal().year,
    now.toLocal().month,
    now.toLocal().day,
  );
  final to = DateTime(
    utc.toLocal().year,
    utc.toLocal().month,
    utc.toLocal().day,
  );
  return to.difference(from).inDays;
}
