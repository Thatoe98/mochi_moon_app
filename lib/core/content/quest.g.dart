// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Quest _$QuestFromJson(Map<String, dynamic> json) => _Quest(
  id: json['id'] as String,
  text: Map<String, String>.from(json['text'] as Map),
  focusAreas:
      (json['focusAreas'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  premium: json['premium'] as bool? ?? false,
);

Map<String, dynamic> _$QuestToJson(_Quest instance) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'focusAreas': instance.focusAreas,
  'premium': instance.premium,
};
