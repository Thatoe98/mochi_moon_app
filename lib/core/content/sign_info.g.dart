// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NamedColor _$NamedColorFromJson(Map<String, dynamic> json) =>
    _NamedColor(name: json['name'] as String, hex: json['hex'] as String);

Map<String, dynamic> _$NamedColorToJson(_NamedColor instance) =>
    <String, dynamic>{'name': instance.name, 'hex': instance.hex};

_SignInfo _$SignInfoFromJson(Map<String, dynamic> json) => _SignInfo(
  id: json['id'] as String,
  index: (json['index'] as num).toInt(),
  element: $enumDecode(_$ElementEnumMap, json['element']),
  palette: (json['palette'] as List<dynamic>)
      .map((e) => NamedColor.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SignInfoToJson(_SignInfo instance) => <String, dynamic>{
  'id': instance.id,
  'index': instance.index,
  'element': _$ElementEnumMap[instance.element]!,
  'palette': instance.palette,
};

const _$ElementEnumMap = {
  Element.fire: 'fire',
  Element.earth: 'earth',
  Element.air: 'air',
  Element.water: 'water',
};
