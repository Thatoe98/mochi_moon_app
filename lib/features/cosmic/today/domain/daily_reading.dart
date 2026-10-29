import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_reading.freezed.dart';

/// The text shown for one sign on one day (PRD §6.7, §8.2).
@freezed
abstract class DailyReading with _$DailyReading {
  const factory DailyReading({
    required String headline,
    required String body,
    required String energy,
    required String love,
    required List<String> avoid,

    /// The language the text is actually in, which is English when the asked
    /// language has no text.
    required String lang,

    /// True for the texts bundled with the app, false for server readings.
    required bool isFallback,
  }) = _DailyReading;
}
