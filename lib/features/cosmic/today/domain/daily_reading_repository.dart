import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';
import 'package:mochi_moon/features/cosmic/today/domain/daily_reading.dart';

/// Where the daily text for a sign comes from. The Readings API version (PRD
/// M4) will try the cache and the server before the bundled texts.
abstract interface class DailyReadingRepository {
  /// The text for [sign] on the local calendar day [date], in [lang] when
  /// there is text for it, otherwise English.
  Future<DailyReading> readingFor({
    required ZodiacSign sign,
    required DateTime date,
    required String lang,
  });
}
