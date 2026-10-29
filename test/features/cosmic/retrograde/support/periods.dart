import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/retrogrades.dart';

/// A made-up retrograde, so the tests do not run the engine.
RetrogradePeriod period(
  Body body, {
  required DateTime start,
  required DateTime end,
  Duration shadow = const Duration(days: 14),
}) => RetrogradePeriod(
  body: body,
  preShadowStart: start.subtract(shadow),
  retrogradeStart: start,
  retrogradeEnd: end,
  postShadowEnd: end.add(shadow),
  retrogradeStartLongitude: 10,
  retrogradeEndLongitude: 0,
);

/// Calendars for the years around late October 2026, with Mercury turned back
/// and Venus due later, so no test runs the real scan.
Future<RetrogradeCalendar> fakeCalendar(int year) async => RetrogradeCalendar(
  year: year,
  periods: [
    if (year == 2026) ...[
      period(
        Body.mercury,
        start: DateTime.utc(2026, 10, 9),
        end: DateTime.utc(2026, 11, 13),
      ),
      period(
        Body.venus,
        start: DateTime.utc(2026, 12, 20),
        end: DateTime.utc(2027, 1, 31),
      ),
    ],
    if (year == 2027)
      period(
        Body.mercury,
        start: DateTime.utc(2027, 2, 9),
        end: DateTime.utc(2027, 3, 3),
      ),
  ],
);
