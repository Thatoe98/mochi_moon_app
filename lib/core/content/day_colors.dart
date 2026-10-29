import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mochi_moon/core/content/sign_info.dart';

part 'day_colors.freezed.dart';
part 'day_colors.g.dart';

/// The color of one weekday in the Thai tradition (PRD §6.7). [weekday] counts
/// like [DateTime.weekday]: Monday is 1, Sunday is 7.
@freezed
abstract class ThaiDayColor with _$ThaiDayColor {
  const factory ThaiDayColor({
    required int weekday,
    required String name,
    required String hex,
  }) = _ThaiDayColor;

  factory ThaiDayColor.fromJson(Map<String, dynamic> json) =>
      _$ThaiDayColorFromJson(json);
}

/// Colors that do not belong to one sign: a palette for each element, used
/// for the second lucky color, and the Thai weekday colors.
@freezed
abstract class DayColors with _$DayColors {
  const factory DayColors({
    required Map<Element, List<NamedColor>> elements,
    required List<ThaiDayColor> thaiDays,
  }) = _DayColors;

  factory DayColors.fromJson(Map<String, dynamic> json) =>
      _$DayColorsFromJson(json);
}
