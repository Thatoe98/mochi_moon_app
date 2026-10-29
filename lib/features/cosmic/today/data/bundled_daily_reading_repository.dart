import 'package:mochi_moon/core/content/content_repository.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';
import 'package:mochi_moon/features/cosmic/today/domain/daily_reading.dart';
import 'package:mochi_moon/features/cosmic/today/domain/daily_reading_repository.dart';
import 'package:mochi_moon/features/cosmic/today/domain/lucky_picks.dart';

const _fallbackLang = 'en';

/// Daily text from the files bundled with the app. It works offline and
/// rotates through a sign's texts day by day.
class BundledDailyReadingRepository implements DailyReadingRepository {
  BundledDailyReadingRepository(this._content);

  final ContentRepository _content;

  @override
  Future<DailyReading> readingFor({
    required ZodiacSign sign,
    required DateTime date,
    required String lang,
  }) async {
    var resolved = lang;
    var texts = await _content.loadFallbackReadings(lang);
    if (texts == null && lang != _fallbackLang) {
      resolved = _fallbackLang;
      texts = await _content.loadFallbackReadings(_fallbackLang);
    }
    final forSign = texts?[sign.name];
    if (forSign == null || forSign.isEmpty) throw const UnavailableFailure();
    final text = forSign[dayOfYear(date) % forSign.length];
    return DailyReading(
      headline: text.headline,
      body: text.body,
      energy: text.energy,
      love: text.love,
      avoid: text.avoid,
      lang: resolved,
      isFallback: true,
    );
  }
}
