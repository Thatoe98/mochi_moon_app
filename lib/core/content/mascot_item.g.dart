// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mascot_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MascotUnlock _$MascotUnlockFromJson(Map<String, dynamic> json) =>
    _MascotUnlock(type: json['type'] as String, value: json['value'] as Object);

Map<String, dynamic> _$MascotUnlockToJson(_MascotUnlock instance) =>
    <String, dynamic>{'type': instance.type, 'value': instance.value};

_MascotItem _$MascotItemFromJson(Map<String, dynamic> json) => _MascotItem(
  id: json['id'] as String,
  slot: json['slot'] as String,
  name: Map<String, String>.from(json['name'] as Map),
  unlock: MascotUnlock.fromJson(json['unlock'] as Map<String, dynamic>),
  illustrationId: json['illustrationId'] as String,
  premium: json['premium'] as bool? ?? false,
);

Map<String, dynamic> _$MascotItemToJson(_MascotItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slot': instance.slot,
      'name': instance.name,
      'unlock': instance.unlock,
      'illustrationId': instance.illustrationId,
      'premium': instance.premium,
    };
