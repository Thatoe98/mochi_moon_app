import 'package:freezed_annotation/freezed_annotation.dart';

part 'quote.freezed.dart';
part 'quote.g.dart';

const _fallbackLang = 'en';

@freezed
abstract class Quote with _$Quote {
  const factory Quote({
    required String id,
    required Map<String, String> text,
    required String category,
    @Default(<String>[]) List<String> moods,
    @Default(<String>['all']) List<String> signs,
    String? author,
    String? illustrationId,
    @Default(false) bool premium,
  }) = _Quote;

  const Quote._();

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);

  /// Text in [lang], falling back to English when that language is missing.
  String textFor(String lang) => text[lang] ?? text[_fallbackLang] ?? '';
}
