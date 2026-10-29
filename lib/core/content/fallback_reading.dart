import 'package:freezed_annotation/freezed_annotation.dart';

part 'fallback_reading.freezed.dart';
part 'fallback_reading.g.dart';

/// One bundled daily text for a sign, used when no reading from the server is
/// at hand (PRD §6.7). It has no date: the app rotates through a sign's texts.
@freezed
abstract class FallbackReading with _$FallbackReading {
  const factory FallbackReading({
    required String headline,
    required String body,
    required String energy,
    required String love,
    required List<String> avoid,
  }) = _FallbackReading;

  factory FallbackReading.fromJson(Map<String, dynamic> json) =>
      _$FallbackReadingFromJson(json);
}
