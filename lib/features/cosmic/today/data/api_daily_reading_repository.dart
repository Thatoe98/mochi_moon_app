import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/network/readings_api.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';
import 'package:mochi_moon/features/cosmic/today/data/daily_reading_codec.dart';
import 'package:mochi_moon/features/cosmic/today/data/drift_daily_reading_cache.dart';
import 'package:mochi_moon/features/cosmic/today/domain/daily_reading.dart';
import 'package:mochi_moon/features/cosmic/today/domain/daily_reading_repository.dart';

const _fallbackLang = 'en';

/// How long a cached reading is trusted before it is fetched again in the
/// background. Readings are generated once a day, so this is a safety net for
/// a new `version`, not a freshness need.
const dailyReadingRefreshAfter = Duration(hours: 6);

/// What one request for a reading came to.
typedef _Fetch = ({DailyReading? reading, bool missing});

/// Daily text from the Readings API (PRD §6.7, §8.2), with the device cache in
/// front and the bundled texts behind:
///
/// 1. a cached reading for the day, sign and language is shown at once (and
///    fetched again in the background when it is old);
/// 2. otherwise the server is asked, then English when the language has no
///    text yet;
/// 3. when the server cannot be reached or says no, the bundled text.
///
/// Only the sign, the date and the language are sent: no birth data.
class ApiDailyReadingRepository implements DailyReadingRepository {
  ApiDailyReadingRepository({
    required this.api,
    required this.cache,
    required this.fallback,
    this.now = DateTime.now,
  });

  final ReadingsApi api;
  final DriftDailyReadingCache cache;

  /// The bundled texts, used when the server gives nothing.
  final DailyReadingRepository fallback;
  final DateTime Function() now;

  @override
  Future<DailyReading> readingFor({
    required ZodiacSign sign,
    required DateTime date,
    required String lang,
  }) async {
    final day = _isoDate(date);
    final cached = await cache.find(date: day, sign: sign.name, lang: lang);
    if (cached != null) {
      if (now().difference(cached.fetchedAt) > dailyReadingRefreshAfter) {
        unawaited(_fetch(day, sign, lang));
      }
      return cached.reading;
    }
    final fetched = await _fetch(day, sign, lang);
    if (fetched.reading != null) return fetched.reading!;
    // Only a missing translation is worth an English request; when the
    // server is out of reach, the bundled text in [lang] is the better page.
    if (fetched.missing && lang != _fallbackLang) {
      final english = await _englishFor(day, sign);
      if (english != null) return english;
    }
    return await fallback.readingFor(sign: sign, date: date, lang: lang);
  }

  Future<DailyReading?> _englishFor(String day, ZodiacSign sign) async {
    final cached = await cache.find(
      date: day,
      sign: sign.name,
      lang: _fallbackLang,
    );
    if (cached != null) return cached.reading;
    return (await _fetch(day, sign, _fallbackLang)).reading;
  }

  /// Asks the server and caches a good answer. A failure is only logged by
  /// its type: the caller falls back, and nothing here may carry user data.
  Future<_Fetch> _fetch(String day, ZodiacSign sign, String lang) async {
    try {
      final json = await api.getJson(
        'daily',
        query: {'sign': sign.name, 'date': day, 'lang': lang},
      );
      final versioned = dailyReadingFromJson(json);
      await cache.put(
        date: day,
        sign: sign.name,
        reading: versioned.reading,
        version: versioned.version,
      );
      return (reading: versioned.reading, missing: false);
    } on ReadingsApiException catch (error) {
      debugPrint('Daily reading not available: $error');
      return (reading: null, missing: error.isNotFound);
    } on AppFailure catch (error) {
      debugPrint('Daily reading not available: $error');
    } on FormatException catch (error) {
      debugPrint('Daily reading answer ignored: ${error.message}');
    }
    return (reading: null, missing: false);
  }

  static String _isoDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
