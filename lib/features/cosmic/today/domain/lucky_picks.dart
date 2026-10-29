import 'package:mochi_moon/core/content/day_colors.dart';
import 'package:mochi_moon/core/content/sign_info.dart';

/// Day of the year of [date], counting 1 January as 1.
int dayOfYear(DateTime date) =>
    DateTime.utc(
      date.year,
      date.month,
      date.day,
    ).difference(DateTime.utc(date.year)).inDays +
    1;

/// The two lucky colors of the day (PRD §6.7).
typedef LuckyColors = ({NamedColor sign, NamedColor moon});

/// Today's lucky colors: one from the sign's own palette, one from the
/// palette of the element the Moon is in.
LuckyColors luckyColors({
  required SignInfo sign,
  required Element moonElement,
  required DayColors colors,
  required DateTime date,
}) {
  final day = dayOfYear(date);
  final moonPalette = colors.elements[moonElement]!;
  return (
    sign: sign.palette[(day + sign.index) % sign.palette.length],
    moon: moonPalette[day % moonPalette.length],
  );
}

/// A lucky number from 1 to 9 that stays the same all day and changes from
/// one day and one sign to the next. Used when the server gives none.
int luckyNumber({required int signIndex, required DateTime date}) =>
    (dayOfYear(date) * 7 + signIndex * 5) % 9 + 1;

/// The Thai color of a weekday and of the user's birth weekday (PRD §6.7).
typedef ThaiColors = ({ThaiDayColor today, ThaiDayColor? birthday});

/// The Thai colors for [date], and for [birthDate] when it is known.
ThaiColors thaiColors({
  required DayColors colors,
  required DateTime date,
  DateTime? birthDate,
}) {
  ThaiDayColor forDate(DateTime d) =>
      colors.thaiDays.firstWhere((c) => c.weekday == d.weekday);
  return (
    today: forDate(date),
    birthday: birthDate == null ? null : forDate(birthDate),
  );
}
