import 'dart:isolate';

import 'package:mochi_moon/features/cosmic/astro/retrogrades.dart';
import 'package:mochi_moon/features/cosmic/retrograde/domain/retrograde_status.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'retrograde_providers.g.dart';

/// Makes the retrograde calendar of a year.
typedef RetrogradeCalendarSource = Future<RetrogradeCalendar> Function(
  int year,
);

/// The scan takes a couple of seconds, so it runs off the main isolate. Tests
/// override this with a fake calendar.
@Riverpod(keepAlive: true)
RetrogradeCalendarSource retrogradeCalendarSource(Ref ref) =>
    (year) => Isolate.run(() => retrogrades(year));

/// Every planet's retrograde periods for this year and the next, as of now.
@riverpod
Future<RetrogradeOverview> retrogradeOverview(Ref ref) async {
  final now = ref.watch(clockProvider)();
  final source = ref.watch(retrogradeCalendarSourceProvider);
  final calendars = await Future.wait([source(now.year), source(now.year + 1)]);
  final merged = mergePeriods([
    for (final calendar in calendars) ...calendar.periods,
  ]);
  return RetrogradeOverview(
    now: now,
    periods: {
      for (final body in retrogradeBodies)
        body: [
          for (final period in merged)
            if (period.body == body) period,
        ],
    },
  );
}
