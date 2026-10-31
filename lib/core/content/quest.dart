import 'package:freezed_annotation/freezed_annotation.dart';

part 'quest.freezed.dart';
part 'quest.g.dart';

const _fallbackLang = 'en';

/// A tiny kindness quest from `quests.json` (PRD §6.20, §8.3).
@freezed
abstract class Quest with _$Quest {
  const factory Quest({
    required String id,
    required Map<String, String> text,

    /// Focus area ids (`FocusArea.id`) this quest suits.
    @Default(<String>[]) List<String> focusAreas,
    @Default(false) bool premium,
  }) = _Quest;

  const Quest._();

  factory Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);

  /// Text in [lang], falling back to English when that language is missing.
  String textFor(String lang) => text[lang] ?? text[_fallbackLang] ?? '';
}
