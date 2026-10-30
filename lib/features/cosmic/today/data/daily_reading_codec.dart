import 'package:mochi_moon/features/cosmic/today/domain/daily_reading.dart';

/// A server reading with the `version` it was generated as (PRD §8.2).
typedef VersionedReading = ({DailyReading reading, int version});

/// Reads a `GET /daily` answer, or a cached copy of one. Throws a
/// [FormatException] when a field is missing or has the wrong type, so a bad
/// answer is never shown or cached.
VersionedReading dailyReadingFromJson(Map<String, Object?> json) {
  String text(String key) {
    final value = json[key];
    if (value is String && value.trim().isNotEmpty) return value;
    throw FormatException('Missing "$key" in the daily reading.');
  }

  final avoid = json['avoid'];
  if (avoid is! List || avoid.isEmpty || avoid.any((a) => a is! String)) {
    throw const FormatException('Missing "avoid" in the daily reading.');
  }
  final version = json['version'];
  if (version is! int) {
    throw const FormatException('Missing "version" in the daily reading.');
  }
  return (
    reading: DailyReading(
      headline: text('headline'),
      body: text('body'),
      energy: text('energy'),
      love: text('love'),
      avoid: avoid.cast<String>(),
      lang: text('lang'),
      isFallback: false,
    ),
    version: version,
  );
}

/// The shape [dailyReadingFromJson] reads, as stored in the cache.
Map<String, Object?> dailyReadingToJson(DailyReading reading, int version) => {
  'headline': reading.headline,
  'body': reading.body,
  'energy': reading.energy,
  'love': reading.love,
  'avoid': reading.avoid,
  'lang': reading.lang,
  'version': version,
};
