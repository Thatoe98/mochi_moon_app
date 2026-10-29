import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/retrograde/domain/retrograde_status.dart';

import '../support/periods.dart';

void main() {
  final now = DateTime.utc(2026, 10, 29, 12);
  final current = period(
    Body.mercury,
    start: DateTime.utc(2026, 10, 9),
    end: DateTime.utc(2026, 11, 13),
  );
  final later = period(
    Body.mercury,
    start: DateTime.utc(2027, 2, 9),
    end: DateTime.utc(2027, 3, 3),
  );
  final earlier = period(
    Body.mercury,
    start: DateTime.utc(2026, 6),
    end: DateTime.utc(2026, 6, 25),
  );

  test('between the stations the planet is retrograde until it turns', () {
    final status = retrogradeStatus(Body.mercury, now, [
      earlier,
      current,
      later,
    ]);

    expect(status, isA<IsRetrograde>());
    expect((status! as IsRetrograde).until, DateTime.utc(2026, 11, 13));
  });

  test('the retrograde ends on the direct station, not after it', () {
    final status = retrogradeStatus(Body.mercury, current.retrogradeEnd, [
      current,
      later,
    ]);

    expect(status, isA<NextRetrograde>());
    expect((status! as NextRetrograde).period, later);
  });

  test('in a shadow the planet is not retrograde yet', () {
    final inShadow = DateTime.utc(2026, 10);
    final status = retrogradeStatus(Body.mercury, inShadow, [current, later]);

    expect(status, isA<NextRetrograde>());
    expect((status! as NextRetrograde).period, current);
  });

  test('picks the soonest later retrograde, whatever the list order', () {
    final status = retrogradeStatus(Body.mercury, DateTime.utc(2026, 12), [
      later,
      earlier,
      current,
    ]);

    expect((status! as NextRetrograde).period, later);
  });

  test('counts whole local days to the station', () {
    final local = DateTime(2027, 2, 1, 20);
    final status = retrogradeStatus(Body.mercury, local, [later]);

    final days = DateTime(
      later.retrogradeStart.toLocal().year,
      later.retrogradeStart.toLocal().month,
      later.retrogradeStart.toLocal().day,
    ).difference(DateTime(2027, 2)).inDays;
    expect((status! as NextRetrograde).daysAway, days);
    expect(days, inInclusiveRange(7, 9));
  });

  test('is 0 days away on the day of the station', () {
    final status = retrogradeStatus(
      Body.mercury,
      later.retrogradeStart.subtract(const Duration(minutes: 1)),
      [later],
    );

    expect((status! as NextRetrograde).daysAway, 0);
  });

  test('ignores other planets and gives null when nothing is left', () {
    final venus = period(
      Body.venus,
      start: DateTime.utc(2026, 12),
      end: DateTime.utc(2027, 1, 12),
    );

    expect(retrogradeStatus(Body.mercury, now, [venus]), isNull);
    expect(retrogradeStatus(Body.mercury, DateTime.utc(2028), [later]), isNull);
    expect(retrogradeStatus(Body.mercury, now, const []), isNull);
  });

  test('mergePeriods drops repeats from neighbouring years and sorts', () {
    final merged = mergePeriods([later, current, earlier, current, later]);

    expect(merged, [earlier, current, later]);
  });

  group('RetrogradeOverview', () {
    final venus = period(
      Body.venus,
      start: DateTime.utc(2026, 10, 20),
      end: DateTime.utc(2026, 12),
    );
    RetrogradeOverview overview(DateTime at) => RetrogradeOverview(
      now: at,
      periods: {
        Body.mercury: [earlier, current, later],
        Body.venus: [venus],
      },
    );

    test('retrogradeNow lists every planet that has turned back', () {
      expect(overview(now).retrogradeNow, [Body.mercury, Body.venus]);
      expect(overview(DateTime.utc(2026, 11, 20)).retrogradeNow, [Body.venus]);
      expect(overview(DateTime.utc(2026, 12, 20)).retrogradeNow, isEmpty);
    });

    test('retrogradeOn names the planets retrograde on a local day', () {
      final data = overview(now);

      expect(data.retrogradeOn(DateTime(2026, 10, 8)), isEmpty);
      expect(data.retrogradeOn(DateTime(2026, 10, 25)), [
        Body.mercury,
        Body.venus,
      ]);
      expect(data.retrogradeOn(DateTime(2026, 11, 20)), [Body.venus]);
      expect(data.retrogradeOn(DateTime(2027, 2, 20)), [Body.mercury]);
    });
  });
}
