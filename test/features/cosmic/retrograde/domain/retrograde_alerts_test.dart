import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/retrogrades.dart';
import 'package:mochi_moon/features/cosmic/retrograde/domain/retrograde_alerts.dart';

import '../support/periods.dart';

/// Noon local on the given day, as the UTC instant a station would carry, so
/// the tests do not depend on the machine's time zone.
DateTime _station(int year, int month, int day) =>
    DateTime(year, month, day, 12).toUtc();

final _now = DateTime(2026, 10, 29, 12);

final Map<Body, List<RetrogradePeriod>> _periods = {
  Body.mercury: [
    period(
      Body.mercury,
      start: _station(2026, 10, 9),
      end: _station(2026, 11, 13),
    ),
    period(
      Body.mercury,
      start: _station(2027, 2, 9),
      end: _station(2027, 3, 3),
    ),
  ],
  Body.venus: [
    period(
      Body.venus,
      start: _station(2026, 12, 20),
      end: _station(2027, 1, 31),
    ),
  ],
};

List<PlannedRetrogradeAlert> _plan(Set<Body> planets, {DateTime? now}) =>
    planRetrogradeAlerts(now: now ?? _now, planets: planets, periods: _periods);

void main() {
  group('planRetrogradeAlerts', () {
    test('plans the eve and the day of the next station, 9am local', () {
      final plan = _plan({Body.mercury});

      expect(plan.map((a) => a.fireAt), [
        DateTime(2026, 11, 12, 9),
        DateTime(2026, 11, 13, 9),
      ]);
      expect(plan.map((a) => a.kind), [
        RetrogradeAlertKind.endsTomorrow,
        RetrogradeAlertKind.endsToday,
      ]);
      expect(plan.every((a) => a.body == Body.mercury), isTrue);
    });

    test('drops stations already past and those beyond the window', () {
      // Oct 9 is past; Feb 9 2027 is more than 90 days after Oct 29 2026.
      expect(_plan({Body.mercury}), hasLength(2));
    });

    test('adds a planet when it is switched on, in time order', () {
      final plan = _plan({Body.mercury, Body.venus});

      expect(plan.map((a) => a.fireAt), [
        DateTime(2026, 11, 12, 9),
        DateTime(2026, 11, 13, 9),
        DateTime(2026, 12, 19, 9),
        DateTime(2026, 12, 20, 9),
      ]);
      expect(_plan({Body.venus}).map((a) => a.kind), [
        RetrogradeAlertKind.startsTomorrow,
        RetrogradeAlertKind.startsToday,
      ]);
    });

    test('skips an alert whose time has already passed today', () {
      // 10am on Nov 13: both Nov 12 and Nov 13 alerts are behind us, and the
      // next station (Feb 9) is the first one left in the window.
      final plan = _plan({Body.mercury}, now: DateTime(2026, 11, 13, 10));

      expect(plan.map((a) => a.fireAt), [
        DateTime(2027, 2, 8, 9),
        DateTime(2027, 2, 9, 9),
      ]);
    });

    test('plans nothing when no planet is on or none has periods', () {
      expect(_plan({}), isEmpty);
      expect(_plan({Body.mars}), isEmpty);
    });
  });
}
