import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/asset_content_repository.dart';
import 'package:mochi_moon/core/content/day_colors.dart';
import 'package:mochi_moon/core/content/sign_info.dart';
import 'package:mochi_moon/features/cosmic/today/domain/lucky_picks.dart';

import '../../../../support/disk_bundle.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late List<SignInfo> signs;
  late DayColors colors;

  setUpAll(() async {
    final repo = AssetContentRepository(bundle: DiskBundle());
    signs = await repo.loadSigns();
    colors = await repo.loadDayColors();
  });

  group('dayOfYear', () {
    test('counts 1 January as 1', () {
      expect(dayOfYear(DateTime(2026)), 1);
      expect(dayOfYear(DateTime(2026, 10, 29)), 302);
    });

    test('counts 31 December as 365, or 366 in a leap year', () {
      expect(dayOfYear(DateTime(2026, 12, 31)), 365);
      expect(dayOfYear(DateTime(2028, 12, 31)), 366);
    });

    test('ignores the time of day', () {
      expect(
        dayOfYear(DateTime(2026, 3, 1, 23, 59)),
        dayOfYear(DateTime(2026, 3)),
      );
    });
  });

  group('luckyColors', () {
    test('picks palette[(dayOfYear + signIndex) % length] for the sign', () {
      final scorpio = signs[7];
      final picked = luckyColors(
        sign: scorpio,
        moonElement: Element.water,
        colors: colors,
        date: DateTime(2026, 10, 29),
      );
      // (302 + 7) % 4 == 1
      expect(picked.sign, scorpio.palette[1]);
    });

    test('picks the second color from the Moon element', () {
      for (final element in Element.values) {
        final picked = luckyColors(
          sign: signs.first,
          moonElement: element,
          colors: colors,
          date: DateTime(2026, 10, 29),
        );
        expect(colors.elements[element], contains(picked.moon));
      }
    });

    test('changes from day to day and cycles through the palette', () {
      final names = {
        for (var day = 1; day <= 4; day++)
          luckyColors(
            sign: signs.first,
            moonElement: Element.fire,
            colors: colors,
            date: DateTime(2026, 1, day),
          ).sign.name,
      };
      expect(names, hasLength(signs.first.palette.length));
    });

    test('is the same all day', () {
      LuckyColors at(int hour) => luckyColors(
        sign: signs[3],
        moonElement: Element.earth,
        colors: colors,
        date: DateTime(2026, 5, 5, hour),
      );
      expect(at(0), at(23));
    });
  });

  group('luckyNumber', () {
    test('is between 1 and 9 for every sign on every day of a year', () {
      for (var day = 0; day < 366; day++) {
        for (var sign = 0; sign < 12; sign++) {
          final number = luckyNumber(
            signIndex: sign,
            date: DateTime(2028).add(Duration(days: day)),
          );
          expect(number, inInclusiveRange(1, 9));
        }
      }
    });

    test('is 8 for Scorpio on 29 October 2026', () {
      expect(luckyNumber(signIndex: 7, date: DateTime(2026, 10, 29)), 8);
    });

    test('differs between signs on the same day', () {
      final numbers = {
        for (var sign = 0; sign < 12; sign++)
          luckyNumber(signIndex: sign, date: DateTime(2026, 10, 29)),
      };
      expect(numbers.length, greaterThan(1));
    });
  });

  group('thaiColors', () {
    test('maps each weekday to its Thai color', () {
      const expected = {
        DateTime.sunday: 'Red',
        DateTime.monday: 'Yellow',
        DateTime.tuesday: 'Pink',
        DateTime.wednesday: 'Green',
        DateTime.thursday: 'Orange',
        DateTime.friday: 'Blue',
        DateTime.saturday: 'Purple',
      };
      for (var offset = 0; offset < 7; offset++) {
        final date = DateTime(2026, 10, 26 + offset);
        expect(
          thaiColors(colors: colors, date: date).today.name,
          expected[date.weekday],
        );
      }
    });

    test('gives the birthday color from the birth weekday', () {
      // 8 November 1998 was a Sunday; 29 October 2026 is a Thursday.
      final result = thaiColors(
        colors: colors,
        date: DateTime(2026, 10, 29),
        birthDate: DateTime(1998, 11, 8),
      );
      expect(result.birthday?.name, 'Red');
      expect(result.today.name, 'Orange');
    });

    test('has no birthday color without a birth date', () {
      final result = thaiColors(colors: colors, date: DateTime(2026, 10, 29));
      expect(result.birthday, isNull);
    });
  });
}
