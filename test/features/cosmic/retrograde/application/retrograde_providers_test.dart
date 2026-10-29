import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/retrograde/application/retrograde_providers.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';

import '../support/periods.dart';

void main() {
  test(
    'asks for this year and the next and groups periods by planet',
    () async {
      final years = <int>[];
      final container = ProviderContainer(
        overrides: [
          clockProvider.overrideWithValue(() => DateTime(2026, 10, 29, 12)),
          retrogradeCalendarSourceProvider.overrideWithValue((year) {
            years.add(year);
            return fakeCalendar(year);
          }),
        ],
      );
      addTearDown(container.dispose);

      final overview = await container.read(retrogradeOverviewProvider.future);

      expect(years, [2026, 2027]);
      expect(overview.now, DateTime(2026, 10, 29, 12));
      expect(overview.of(Body.mercury), hasLength(2));
      expect(overview.of(Body.venus), hasLength(1));
      expect(overview.of(Body.mars), isEmpty);
      expect(
        overview.of(Body.mercury).first.retrogradeStart,
        DateTime.utc(2026, 10, 9),
      );
    },
  );

  test('a calendar failure becomes the provider error', () async {
    final container = ProviderContainer(
      overrides: [
        clockProvider.overrideWithValue(() => DateTime(2026, 10, 29, 12)),
        retrogradeCalendarSourceProvider.overrideWithValue(
          (year) => Future.error(StateError('scan failed')),
        ),
      ],
    );
    addTearDown(container.dispose);

    await expectLater(
      container.read(retrogradeOverviewProvider.future),
      throwsStateError,
    );
  });
}
