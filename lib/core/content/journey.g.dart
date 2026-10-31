// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Journey _$JourneyFromJson(Map<String, dynamic> json) => _Journey(
  id: json['id'] as String,
  days: (json['days'] as num).toInt(),
  title: Map<String, String>.from(json['title'] as Map),
  summary: Map<String, String>.from(json['summary'] as Map),
  illustrationId: json['illustrationId'] as String,
  daysPlan:
      (json['daysPlan'] as List<dynamic>?)
          ?.map((e) => JourneyDayPlan.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <JourneyDayPlan>[],
  premium: json['premium'] as bool? ?? false,
);

Map<String, dynamic> _$JourneyToJson(_Journey instance) => <String, dynamic>{
  'id': instance.id,
  'days': instance.days,
  'title': instance.title,
  'summary': instance.summary,
  'illustrationId': instance.illustrationId,
  'daysPlan': instance.daysPlan,
  'premium': instance.premium,
};

_JourneyDayPlan _$JourneyDayPlanFromJson(Map<String, dynamic> json) =>
    _JourneyDayPlan(
      day: (json['day'] as num).toInt(),
      quoteIds: (json['quoteIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      questId: json['questId'] as String,
      reflection: Map<String, String>.from(json['reflection'] as Map),
    );

Map<String, dynamic> _$JourneyDayPlanToJson(_JourneyDayPlan instance) =>
    <String, dynamic>{
      'day': instance.day,
      'quoteIds': instance.quoteIds,
      'questId': instance.questId,
      'reflection': instance.reflection,
    };
