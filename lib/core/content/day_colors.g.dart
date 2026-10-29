// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_colors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ThaiDayColor _$ThaiDayColorFromJson(Map<String, dynamic> json) =>
    _ThaiDayColor(
      weekday: (json['weekday'] as num).toInt(),
      name: json['name'] as String,
      hex: json['hex'] as String,
    );

Map<String, dynamic> _$ThaiDayColorToJson(_ThaiDayColor instance) =>
    <String, dynamic>{
      'weekday': instance.weekday,
      'name': instance.name,
      'hex': instance.hex,
    };

_DayColors _$DayColorsFromJson(Map<String, dynamic> json) => _DayColors(
  elements: (json['elements'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      $enumDecode(_$ElementEnumMap, k),
      (e as List<dynamic>)
          .map((e) => NamedColor.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  ),
  thaiDays: (json['thaiDays'] as List<dynamic>)
      .map((e) => ThaiDayColor.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DayColorsToJson(_DayColors instance) =>
    <String, dynamic>{
      'elements': instance.elements.map(
        (k, e) => MapEntry(_$ElementEnumMap[k]!, e),
      ),
      'thaiDays': instance.thaiDays,
    };

const _$ElementEnumMap = {
  Element.fire: 'fire',
  Element.earth: 'earth',
  Element.air: 'air',
  Element.water: 'water',
};
