import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mochi_moon/core/content/content_repository.dart';
import 'package:mochi_moon/core/content/day_colors.dart';
import 'package:mochi_moon/core/content/fallback_reading.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/content/sign_info.dart';

class AssetContentRepository implements ContentRepository {
  AssetContentRepository({AssetBundle? bundle})
    : _bundle = bundle ?? rootBundle;

  static const quotesPath = 'assets/content/quotes/quotes.json';
  static const signsPath = 'assets/content/signs/signs.json';

  static const dayColorsPath = 'assets/content/signs/day_colors.json';
  static const fallbackReadingsDir = 'assets/content/fallback_readings';

  /// Languages with a file in [fallbackReadingsDir]. Burmese is machine
  /// translated (PRD §7.1a) and awaits review; Thai waits for a native reviewer.
  static const fallbackReadingLanguages = ['en', 'my'];

  final AssetBundle _bundle;

  Future<Map<String, dynamic>> _loadJson(String path) async {
    final raw = await _bundle.loadString(path);
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  @override
  Future<List<Quote>> loadQuotes() async {
    final json = await _loadJson(quotesPath);
    return (json['quotes'] as List<dynamic>)
        .map((e) => Quote.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  @override
  Future<List<SignInfo>> loadSigns() async {
    final json = await _loadJson(signsPath);
    return (json['signs'] as List<dynamic>)
        .map((e) => SignInfo.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  @override
  Future<DayColors> loadDayColors() async =>
      DayColors.fromJson(await _loadJson(dayColorsPath));

  @override
  Future<Map<String, List<FallbackReading>>?> loadFallbackReadings(
    String lang,
  ) async {
    if (!fallbackReadingLanguages.contains(lang)) return null;
    final json = await _loadJson('$fallbackReadingsDir/$lang.json');
    final readings = json['readings'] as Map<String, dynamic>;
    return {
      for (final entry in readings.entries)
        entry.key: [
          for (final reading in entry.value as List<dynamic>)
            FallbackReading.fromJson(reading as Map<String, dynamic>),
        ],
    };
  }
}
