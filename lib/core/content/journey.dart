import 'package:freezed_annotation/freezed_annotation.dart';

part 'journey.freezed.dart';
part 'journey.g.dart';

const _fallbackLang = 'en';

/// A self-love journey from `journeys.json` (PRD §6.21, §8.3).
@freezed
abstract class Journey with _$Journey {
  const factory Journey({
    required String id,
    required int days,
    required Map<String, String> title,
    required Map<String, String> summary,
    required String illustrationId,
    @Default(<JourneyDayPlan>[]) List<JourneyDayPlan> daysPlan,
    @Default(false) bool premium,
  }) = _Journey;

  const Journey._();

  factory Journey.fromJson(Map<String, dynamic> json) =>
      _$JourneyFromJson(json);

  String titleFor(String lang) => title[lang] ?? title[_fallbackLang] ?? '';

  String summaryFor(String lang) =>
      summary[lang] ?? summary[_fallbackLang] ?? '';

  /// The plan of day [day] (1-based), or null.
  JourneyDayPlan? planFor(int day) {
    for (final plan in daysPlan) {
      if (plan.day == day) return plan;
    }
    return null;
  }
}

/// One day of a journey: three cards by id, one quest by id, one reflection.
@freezed
abstract class JourneyDayPlan with _$JourneyDayPlan {
  const factory JourneyDayPlan({
    required int day,
    required List<String> quoteIds,
    required String questId,
    required Map<String, String> reflection,
  }) = _JourneyDayPlan;

  const JourneyDayPlan._();

  factory JourneyDayPlan.fromJson(Map<String, dynamic> json) =>
      _$JourneyDayPlanFromJson(json);

  String reflectionFor(String lang) =>
      reflection[lang] ?? reflection[_fallbackLang] ?? '';
}
