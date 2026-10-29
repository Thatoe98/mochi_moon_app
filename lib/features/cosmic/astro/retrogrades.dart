import 'package:mochi_moon/features/cosmic/astro/bisect.dart';
import 'package:mochi_moon/features/cosmic/astro/ephemeris.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';

/// How precisely stations and shadow edges are pinned down (PRD §9.5).
const _stationTolerance = Duration(hours: 1);

/// A shadow edge is searched for day by day; no shadow is longer than this.
const _maxShadowSearch = Duration(days: 500);

/// How one body is scanned for stations. `step` must be shorter than the
/// body's shortest retrograde or direct stretch, so none is skipped. `margin`
/// widens the scan past the year so every period whose shadows touch the year
/// has both its stations in range; the PRD's two months is too short for the
/// slow planets, whose shadows reach about three months from the station.
typedef _Scan = ({Duration step, Duration margin});

const _scans = <Body, _Scan>{
  Body.mercury: (step: Duration(days: 1), margin: Duration(days: 120)),
  Body.venus: (step: Duration(days: 2), margin: Duration(days: 200)),
  Body.mars: (step: Duration(days: 2), margin: Duration(days: 300)),
  Body.jupiter: (step: Duration(days: 4), margin: Duration(days: 400)),
  Body.saturn: (step: Duration(days: 4), margin: Duration(days: 400)),
};

/// One retrograde of one planet, with its shadows (PRD §9.5).
class RetrogradePeriod {
  const RetrogradePeriod({
    required this.body,
    required this.preShadowStart,
    required this.retrogradeStart,
    required this.retrogradeEnd,
    required this.postShadowEnd,
    required this.retrogradeStartLongitude,
    required this.retrogradeEndLongitude,
  });

  final Body body;

  /// The planet first reaches the degree where it will turn direct.
  final DateTime preShadowStart;

  /// Station retrograde: the planet starts to move backwards.
  final DateTime retrogradeStart;

  /// Station direct: the planet starts to move forwards again.
  final DateTime retrogradeEnd;

  /// The planet is back at the degree where it turned retrograde.
  final DateTime postShadowEnd;

  /// Longitude at [retrogradeStart], in degrees.
  final double retrogradeStartLongitude;

  /// Longitude at [retrogradeEnd], in degrees.
  final double retrogradeEndLongitude;

  /// True while [utc] is between the two stations.
  bool isRetrogradeAt(DateTime utc) =>
      !utc.isBefore(retrogradeStart) && utc.isBefore(retrogradeEnd);

  /// True while [utc] is inside the whole span, shadows included.
  bool isInShadowSpanAt(DateTime utc) =>
      !utc.isBefore(preShadowStart) && utc.isBefore(postShadowEnd);
}

/// Every retrograde of Mercury, Venus, Mars, Jupiter and Saturn whose shadows
/// touch one calendar year.
class RetrogradeCalendar {
  const RetrogradeCalendar({required this.year, required this.periods});

  final int year;

  /// Ordered by [RetrogradePeriod.preShadowStart], then by body.
  final List<RetrogradePeriod> periods;

  /// The periods of [body], in date order.
  List<RetrogradePeriod> forBody(Body body) => [
    for (final period in periods)
      if (period.body == body) period,
  ];
}

/// The retrograde calendar for [year] (PRD §9.5). Periods that begin before
/// or end after the year are included when their shadows touch it.
RetrogradeCalendar retrogrades(int year) {
  final yearStart = DateTime.utc(year);
  final yearEnd = DateTime.utc(year + 1);
  final periods = <RetrogradePeriod>[
    for (final entry in _scans.entries)
      ..._periodsOf(entry.key, entry.value, yearStart, yearEnd),
  ]..sort(_byStart);
  return RetrogradeCalendar(year: year, periods: periods);
}

int _byStart(RetrogradePeriod a, RetrogradePeriod b) {
  final byTime = a.preShadowStart.compareTo(b.preShadowStart);
  return byTime != 0 ? byTime : a.body.index.compareTo(b.body.index);
}

List<RetrogradePeriod> _periodsOf(
  Body body,
  _Scan scan,
  DateTime yearStart,
  DateTime yearEnd,
) {
  final end = yearEnd.add(scan.margin);
  final periods = <RetrogradePeriod>[];
  DateTime? retrogradeStation;

  var previous = yearStart.subtract(scan.margin);
  var previousRetrograde = speedAt(body, previous) < 0;
  while (previous.isBefore(end)) {
    final current = previous.add(scan.step);
    final currentRetrograde = speedAt(body, current) < 0;
    if (!previousRetrograde && currentRetrograde) {
      retrogradeStation = _station(body, previous, current, toRetrograde: true);
    } else if (previousRetrograde && !currentRetrograde) {
      final directStation = _station(
        body,
        previous,
        current,
        toRetrograde: false,
      );
      // A direct station with no retrograde station before it began before
      // the scan did, so its period cannot touch the year.
      if (retrogradeStation != null) {
        final period = _period(body, retrogradeStation, directStation);
        if (period.postShadowEnd.isAfter(yearStart) &&
            period.preShadowStart.isBefore(yearEnd)) {
          periods.add(period);
        }
      }
      retrogradeStation = null;
    }
    previous = current;
    previousRetrograde = currentRetrograde;
  }
  return periods;
}

DateTime _station(
  Body body,
  DateTime before,
  DateTime after, {
  required bool toRetrograde,
}) {
  return bisectInstant(
    before: before,
    after: after,
    reached: (utc) => (speedAt(body, utc) < 0) == toRetrograde,
    tolerance: _stationTolerance,
  );
}

RetrogradePeriod _period(Body body, DateTime retroStation, DateTime direct) {
  final retroLongitude = longitudeAt(body, retroStation);
  final directLongitude = longitudeAt(body, direct);
  return RetrogradePeriod(
    body: body,
    preShadowStart: _preShadowStart(body, retroStation, directLongitude),
    retrogradeStart: retroStation,
    retrogradeEnd: direct,
    postShadowEnd: _postShadowEnd(body, direct, retroLongitude),
    retrogradeStartLongitude: retroLongitude,
    retrogradeEndLongitude: directLongitude,
  );
}

/// The last time before [retroStation] when [body] was at or below
/// [directLongitude], the degree it will turn direct at.
DateTime _preShadowStart(
  Body body,
  DateTime retroStation,
  double directLongitude,
) {
  bool below(DateTime utc) =>
      signedAngleDifference(longitudeAt(body, utc), directLongitude) <= 0;

  var after = retroStation;
  final limit = retroStation.subtract(_maxShadowSearch);
  while (after.isAfter(limit)) {
    final before = after.subtract(const Duration(days: 1));
    if (below(before)) {
      return bisectInstant(
        before: before,
        after: after,
        reached: (utc) => !below(utc),
        tolerance: _stationTolerance,
      );
    }
    after = before;
  }
  throw StateError('No pre-shadow found for ${body.name} at $retroStation');
}

/// The first time after [direct] when [body] is back at or beyond
/// [retroLongitude], the degree it turned retrograde at.
DateTime _postShadowEnd(Body body, DateTime direct, double retroLongitude) {
  bool reached(DateTime utc) =>
      signedAngleDifference(longitudeAt(body, utc), retroLongitude) >= 0;

  var before = direct;
  final limit = direct.add(_maxShadowSearch);
  while (before.isBefore(limit)) {
    final after = before.add(const Duration(days: 1));
    if (reached(after)) {
      return bisectInstant(
        before: before,
        after: after,
        reached: reached,
        tolerance: _stationTolerance,
      );
    }
    before = after;
  }
  throw StateError('No post-shadow found for ${body.name} at $direct');
}
