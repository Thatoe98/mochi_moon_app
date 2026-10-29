// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fallback_reading.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FallbackReading _$FallbackReadingFromJson(Map<String, dynamic> json) =>
    _FallbackReading(
      headline: json['headline'] as String,
      body: json['body'] as String,
      energy: json['energy'] as String,
      love: json['love'] as String,
      avoid: (json['avoid'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$FallbackReadingToJson(_FallbackReading instance) =>
    <String, dynamic>{
      'headline': instance.headline,
      'body': instance.body,
      'energy': instance.energy,
      'love': instance.love,
      'avoid': instance.avoid,
    };
