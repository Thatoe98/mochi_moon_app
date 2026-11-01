import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mochi_moon/core/content/content_repository.dart';
import 'package:mochi_moon/core/content/day_colors.dart';
import 'package:mochi_moon/core/content/fallback_reading.dart';
import 'package:mochi_moon/core/content/journey.dart';
import 'package:mochi_moon/core/content/mascot_item.dart';
import 'package:mochi_moon/core/content/quest.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/content/sign_info.dart';

class AssetContentRepository implements ContentRepository {
  AssetContentRepository({AssetBundle? bundle})
    : _bundle = bundle ?? rootBundle;

  static const quotesPath = 'assets/content/quotes/quotes.json';
  static const mascotItemsPath = 'assets/content/mascot/mascot_items.json';
  static const questsPath = 'assets/content/quests/quests.json';
  static const journeysPath = 'assets/content/journeys/journeys.json';
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
  Future<List<Journey>> loadJourneys() async {
    final json = await _loadJson(journeysPath);
    return (json['journeys'] as List<dynamic>)
        .map((e) => Journey.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<MascotItem>> loadMascotItems() async {
    final json = await _loadJson(mascotItemsPath);
    return (json['items'] as List<dynamic>)
        .map((e) => MascotItem.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  @override
  Future<List<Quest>> loadQuests() async {
    final json = await _loadJson(questsPath);
    return (json['quests'] as List<dynamic>)
        .map((e) => Quest.fromJson(e as Map<String, dynamic>))
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
