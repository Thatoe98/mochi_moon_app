import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';
import 'package:mochi_moon/features/cosmic/today/domain/daily_reading.dart';
import 'package:mochi_moon/features/cosmic/today/domain/lucky_picks.dart';

/// Everything the Today screen shows for one user on one day (PRD §6.7).
class CosmicToday {
  const CosmicToday({
    required this.date,
    required this.sign,
    required this.moonSign,
    required this.reading,
    required this.luckyColors,
    required this.luckyNumber,
    required this.thaiColors,
  });

  /// The local calendar day, without a time.
  final DateTime date;
  final ZodiacSign sign;
  final ZodiacSign moonSign;
  final DailyReading reading;
  final LuckyColors luckyColors;
  final int luckyNumber;
  final ThaiColors thaiColors;
}
