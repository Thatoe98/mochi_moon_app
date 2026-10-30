import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/partners/domain/compatibility_band.dart';

void main() {
  test('the three bands split at 54/55 and 74/75', () {
    expect(CompatibilityBand.of(35), CompatibilityBand.low);
    expect(CompatibilityBand.of(54), CompatibilityBand.low);
    expect(CompatibilityBand.of(55), CompatibilityBand.mid);
    expect(CompatibilityBand.of(74), CompatibilityBand.mid);
    expect(CompatibilityBand.of(75), CompatibilityBand.high);
    expect(CompatibilityBand.of(98), CompatibilityBand.high);
  });
}
