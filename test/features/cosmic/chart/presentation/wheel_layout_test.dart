import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/cosmic/chart/presentation/wheel_layout.dart';

/// Distance between two longitudes around the circle.
double _gap(double a, double b) {
  final raw = (a - b).abs() % 360;
  return raw > 180 ? 360 - raw : raw;
}

void main() {
  group('wheelAngle', () {
    test("puts the rotation longitude at 9 o'clock", () {
      expect(wheelAngle(0, rotation: 0), closeTo(math.pi, 1e-9));
      expect(wheelAngle(255.4, rotation: 255.4), closeTo(math.pi, 1e-9));
    });

    test("runs counterclockwise: +90° is at 6 o'clock, +180° at 3", () {
      // Canvas y points down, so 6 o'clock is +π/2 and 3 o'clock is 0.
      expect(wheelAngle(90, rotation: 0), closeTo(math.pi / 2, 1e-9));
      expect(wheelAngle(180, rotation: 0), closeTo(0, 1e-9));
      expect(wheelAngle(270, rotation: 0), closeTo(-math.pi / 2, 1e-9));
    });

    test('wraps around 0°', () {
      expect(
        wheelAngle(10, rotation: 350),
        closeTo(wheelAngle(20, rotation: 0), 1e-9),
      );
    });
  });

  group('spreadLongitudes', () {
    test('leaves well-spaced longitudes alone', () {
      final input = [0.0, 40.0, 100.0, 200.0];
      expect(spreadLongitudes(input, minGap: 10), input);
    });

    test('pulls a tight cluster apart around its middle', () {
      final out = spreadLongitudes([100, 101, 102], minGap: 10);
      expect(out[0], closeTo(91, 1e-6));
      expect(out[1], closeTo(101, 1e-6));
      expect(out[2], closeTo(111, 1e-6));
    });

    test('keeps the order of the input, not the sorted order', () {
      final out = spreadLongitudes([102, 100, 101], minGap: 10);
      expect(out[1], lessThan(out[2]));
      expect(out[2], lessThan(out[0]));
    });

    test('works across 0° / 360°', () {
      final out = spreadLongitudes([359, 0, 1], minGap: 10);
      for (var i = 0; i < 3; i++) {
        for (var j = i + 1; j < 3; j++) {
          expect(_gap(out[i], out[j]), greaterThanOrEqualTo(10 - 1e-6));
        }
      }
      for (final value in out) {
        expect(value, inInclusiveRange(0, 360));
      }
    });

    test('handles ten bodies in one place', () {
      final out = spreadLongitudes(List.filled(10, 200), minGap: 12);
      final sorted = [...out]..sort();
      for (var i = 1; i < sorted.length; i++) {
        expect(sorted[i] - sorted[i - 1], greaterThanOrEqualTo(12 - 1e-6));
      }
    });

    test('keeps every neighbour apart for random charts', () {
      final random = math.Random(7);
      for (var run = 0; run < 200; run++) {
        final input = [for (var i = 0; i < 10; i++) random.nextDouble() * 360];
        final out = spreadLongitudes(input, minGap: 12);
        final sorted = [...out]..sort();
        for (var i = 0; i < sorted.length; i++) {
          final next = sorted[(i + 1) % sorted.length];
          final distance = (next - sorted[i]) % 360;
          expect(distance, greaterThanOrEqualTo(12 - 1e-6), reason: '$input');
        }
        // A glyph never moves further than a full pass of the crowd.
        for (var i = 0; i < input.length; i++) {
          expect(_gap(input[i], out[i]), lessThan(120));
        }
      }
    });

    test('copes with zero or one longitude', () {
      expect(spreadLongitudes([], minGap: 10), isEmpty);
      expect(spreadLongitudes([42], minGap: 10), [42]);
    });
  });
}
