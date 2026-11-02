// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Quote _$QuoteFromJson(Map<String, dynamic> json) => _Quote(
  id: json['id'] as String,
  text: Map<String, String>.from(json['text'] as Map),
  category: json['category'] as String,
  moods:
      (json['moods'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  signs:
      (json['signs'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>['all'],
  author: json['author'] as String?,
  illustrationId: json['illustrationId'] as String?,
  premium: json['premium'] as bool? ?? false,
  embedding: json['embedding'] as String?,
);

Map<String, dynamic> _$QuoteToJson(_Quote instance) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'category': instance.category,
  'moods': instance.moods,
  'signs': instance.signs,
  'author': instance.author,
  'illustrationId': instance.illustrationId,
  'premium': instance.premium,
  'embedding': instance.embedding,
};
