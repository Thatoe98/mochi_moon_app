import 'package:mochi_moon/core/content/day_colors.dart';
import 'package:mochi_moon/core/content/fallback_reading.dart';
import 'package:mochi_moon/core/content/journey.dart';
import 'package:mochi_moon/core/content/quest.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/content/sign_info.dart';

/// Source of bundled content. Widgets never load assets directly.
abstract interface class ContentRepository {
  Future<List<Quote>> loadQuotes();

  Future<List<Quest>> loadQuests();

  Future<List<Journey>> loadJourneys();

  Future<List<SignInfo>> loadSigns();

  Future<DayColors> loadDayColors();

  /// Bundled readings for [lang], by sign id, or null when none are bundled
  /// for that language.
  Future<Map<String, List<FallbackReading>>?> loadFallbackReadings(String lang);
}
