import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/cosmic/astro/birth_time.dart';
import 'package:timezone/timezone.dart' as tz;

DateTime _utc(
  String tzId,
  int y,
  int m,
  int d, {
  int? hour,
  int minute = 0,
}) => birthInstantUtc(
  birthDate: DateTime(y, m, d),
  tzId: tzId,
  birthMinutes: hour == null ? null : hour * 60 + minute,
);

void main() {
  group('birthInstantUtc', () {
    test('applies daylight saving in the northern summer', () {
      expect(
        _utc('America/New_York', 1990, 7, 4, hour: 12),
        DateTime.utc(1990, 7, 4, 16),
      );
    });

    test('uses standard time in the northern winter', () {
      expect(
        _utc('America/New_York', 1990, 1, 15, hour: 12),
        DateTime.utc(1990, 1, 15, 17),
      );
    });

    test('applies daylight saving in the southern summer', () {
      expect(
        _utc('Australia/Sydney', 2000, 1, 15, hour: 12),
        DateTime.utc(2000, 1, 15, 1),
      );
    });

    test('reads Bangkok as UTC+7', () {
      expect(
        _utc('Asia/Bangkok', 1985, 6, 1, hour: 12),
        DateTime.utc(1985, 6, 1, 5),
      );
    });

    test('reads Yangon as UTC+6:30', () {
      expect(
        _utc('Asia/Yangon', 1995, 3, 10, hour: 6, minute: 30),
        DateTime.utc(1995, 3, 10),
      );
    });

    test('uses historical offsets before 1970', () {
      // Britain kept summer time all year between 1968 and 1971.
      expect(
        _utc('Europe/London', 1970, 1, 15, hour: 12),
        DateTime.utc(1970, 1, 15, 11),
      );
    });

    test('unknown birth time means noon local time', () {
      expect(_utc('Asia/Bangkok', 1990, 3, 21), DateTime.utc(1990, 3, 21, 5));
      expect(
        _utc('Asia/Bangkok', 1990, 3, 21),
        _utc('Asia/Bangkok', 1990, 3, 21, hour: 12),
      );
    });

    test('ignores the time part of the birth date', () {
      expect(
        birthInstantUtc(
          birthDate: DateTime(1990, 3, 21, 23, 59),
          tzId: 'Asia/Bangkok',
        ),
        DateTime.utc(1990, 3, 21, 5),
      );
    });

    test('returns a UTC instant', () {
      expect(_utc('Asia/Bangkok', 1990, 3, 21).isUtc, isTrue);
    });

    test('resolves a clock time skipped by daylight saving', () {
      // 02:30 did not exist in New York on 2024-03-10.
      final instant = _utc('America/New_York', 2024, 3, 10, hour: 2, minute: 30);
      expect(
        instant,
        isIn([DateTime.utc(2024, 3, 10, 6, 30), DateTime.utc(2024, 3, 10, 7, 30)]),
      );
    });

    test('resolves a clock time repeated by daylight saving', () {
      // 01:30 happened twice in New York on 2024-11-03.
      final instant = _utc('America/New_York', 2024, 11, 3, hour: 1, minute: 30);
      expect(
        instant,
        isIn([DateTime.utc(2024, 11, 3, 5, 30), DateTime.utc(2024, 11, 3, 6, 30)]),
      );
    });

    test('rejects an unknown zone', () {
      expect(
        () => _utc('Mars/Olympus_Mons', 1990, 3, 21),
        throwsA(isA<tz.LocationNotFoundException>()),
      );
    });
  });
}
