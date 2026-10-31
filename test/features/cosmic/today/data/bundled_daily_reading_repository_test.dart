import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/asset_content_repository.dart';
import 'package:mochi_moon/core/content/content_repository.dart';
import 'package:mochi_moon/core/content/day_colors.dart';
import 'package:mochi_moon/core/content/fallback_reading.dart';
import 'package:mochi_moon/core/content/journey.dart';
import 'package:mochi_moon/core/content/quest.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/content/sign_info.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';
import 'package:mochi_moon/features/cosmic/today/data/bundled_daily_reading_repository.dart';

import '../../../../support/disk_bundle.dart';

FallbackReading _text(String headline) => FallbackReading(
  headline: headline,
  body: 'Body of $headline.',
  energy: 'Energy',
  love: 'Love',
  avoid: const ['a', 'b', 'c'],
);

class _FakeContent implements ContentRepository {
  _FakeContent(this.byLang);

  final Map<String, Map<String, List<FallbackReading>>> byLang;
  final asked = <String>[];

  @override
  Future<Map<String, List<FallbackReading>>?> loadFallbackReadings(
    String lang,
  ) async {
    asked.add(lang);
    return byLang[lang];
  }

  @override
  Future<DayColors> loadDayColors() => throw UnimplementedError();

  @override
  Future<List<Quote>> loadQuotes() => throw UnimplementedError();

  @override
  Future<List<Quest>> loadQuests() => throw UnimplementedError();

  @override
  Future<List<Journey>> loadJourneys() => throw UnimplementedError();

  @override
  Future<List<SignInfo>> loadSigns() => throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('with fake content', () {
    final english = {
      'aries': [_text('one'), _text('two')],
      'taurus': <FallbackReading>[],
    };

    Future<void> expectUnavailable(
      BundledDailyReadingRepository repo,
      ZodiacSign sign,
    ) => expectLater(
      repo.readingFor(sign: sign, date: DateTime(2026, 3), lang: 'en'),
      throwsA(isA<UnavailableFailure>()),
    );

    test('rotates through the texts of a sign day by day', () async {
      final repo = BundledDailyReadingRepository(_FakeContent({'en': english}));
      Future<String> headline(DateTime date) async => (await repo.readingFor(
        sign: ZodiacSign.aries,
        date: date,
        lang: 'en',
      )).headline;

      final first = await headline(DateTime(2026, 3));
      final second = await headline(DateTime(2026, 3, 2));
      final third = await headline(DateTime(2026, 3, 3));
      expect(first, isNot(second));
      expect(third, first);
    });

    test('gives the same text all day', () async {
      final repo = BundledDailyReadingRepository(_FakeContent({'en': english}));
      final morning = await repo.readingFor(
        sign: ZodiacSign.aries,
        date: DateTime(2026, 3, 1, 6),
        lang: 'en',
      );
      final night = await repo.readingFor(
        sign: ZodiacSign.aries,
        date: DateTime(2026, 3, 1, 23),
        lang: 'en',
      );
      expect(morning, night);
    });

    test('uses the asked language when it is bundled', () async {
      final repo = BundledDailyReadingRepository(
        _FakeContent({
          'en': english,
          'my': {
            'aries': [_text('burmese')],
          },
        }),
      );
      final reading = await repo.readingFor(
        sign: ZodiacSign.aries,
        date: DateTime(2026, 3),
        lang: 'my',
      );
      expect(reading.headline, 'burmese');
      expect(reading.lang, 'my');
    });

    test('falls back to English and says so', () async {
      final content = _FakeContent({'en': english});
      final reading = await BundledDailyReadingRepository(content).readingFor(
        sign: ZodiacSign.aries,
        date: DateTime(2026, 3),
        lang: 'my',
      );
      expect(content.asked, ['my', 'en']);
      expect(reading.lang, 'en');
      expect(reading.isFallback, isTrue);
    });

    test('fails when there is no text for the sign', () async {
      final repo = BundledDailyReadingRepository(_FakeContent({'en': english}));
      await expectUnavailable(repo, ZodiacSign.taurus);
      await expectUnavailable(repo, ZodiacSign.leo);
    });

    test('fails when nothing is bundled at all', () async {
      final repo = BundledDailyReadingRepository(_FakeContent({}));
      await expectUnavailable(repo, ZodiacSign.aries);
    });
  });

  test('every sign has a text on every day of a leap year', () async {
    final repo = BundledDailyReadingRepository(
      AssetContentRepository(bundle: DiskBundle()),
    );
    for (final sign in ZodiacSign.values) {
      for (var day = 0; day < 366; day++) {
        final reading = await repo.readingFor(
          sign: sign,
          date: DateTime(2028).add(Duration(days: day)),
          lang: 'en',
        );
        expect(reading.avoid, hasLength(3));
      }
    }
  });
}
