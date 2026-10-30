import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/cosmic/astro/moon_phase.dart';
import 'package:mochi_moon/features/cosmic/moon/application/moon_providers.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';

ProviderContainer _containerAt(DateTime now) {
  final container = ProviderContainer(
    overrides: [clockProvider.overrideWithValue(() => now)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('reads the Moon at the clock time, in UTC', () {
    final now = DateTime(2026, 10, 29, 12);
    final moon = _containerAt(now).read(moonNowProvider);

    expect(moon.utc, now.toUtc());
    expect(moon.elongation, moonPhase(now.toUtc()).elongation);
  });

  test('follows the clock from a waning moon to a waxing one', () {
    // Three days after the full moon of 26 Oct 2026, and eight days after the
    // new moon of 9 Nov.
    final waning = _containerAt(DateTime.utc(2026, 10, 29, 12));
    final waxing = _containerAt(DateTime.utc(2026, 11, 17, 12));

    expect(waning.read(moonNowProvider).name, MoonPhaseName.waningGibbous);
    expect(waning.read(moonNowProvider).isWaxing, isFalse);
    expect(waxing.read(moonNowProvider).name, MoonPhaseName.firstQuarter);
    expect(waxing.read(moonNowProvider).isWaxing, isTrue);
  });
}
