import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/asset_content_repository.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/content/sign_info.dart';
import 'package:mochi_moon/features/for_you/domain/for_you_ranker.dart';

/// Serves the real asset files from disk so the shipped JSON is validated.
class _DiskBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    final bytes = await File(key).readAsBytes();
    return ByteData.sublistView(bytes);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final repo = AssetContentRepository(bundle: _DiskBundle());

  test('loads the launch quotes with unique ids', () async {
    final quotes = await repo.loadQuotes();
    expect(quotes, hasLength(500));
    expect(quotes.map((q) => q.id).toSet(), hasLength(500));
    expect(quotes.every((q) => q.textFor('en').isNotEmpty), isTrue);
  });

  test(
    'every quote has a 128-dim embedding and each mood a centroid',
    () async {
      final quotes = await repo.loadQuotes();
      for (final q in quotes) {
        expect(decodeEmbedding(q.embedding), hasLength(128), reason: q.id);
      }
      final centroids = await repo.loadMoodCentroids();
      expect(centroids.keys.toSet(), {
        'happy',
        'calm',
        'tired',
        'sad',
        'anxious',
        'in_love',
      });
      for (final c in centroids.values) {
        expect(decodeEmbedding(c), hasLength(128));
      }
    },
  );

  test(
    'loads the quests with unique ids, English text and known areas',
    () async {
      final quests = await repo.loadQuests();
      const areas = {
        'self_love',
        'confidence',
        'healing',
        'study_work',
        'body_kindness',
        'calm',
      };
      expect(quests, isNotEmpty);
      expect(quests.map((q) => q.id).toSet(), hasLength(quests.length));
      for (final quest in quests) {
        expect(quest.text['en'], isNotEmpty);
        expect(quest.focusAreas, isNotEmpty);
        expect(areas.containsAll(quest.focusAreas), isTrue);
      }
      for (final area in areas) {
        expect(
          quests.where((q) => q.focusAreas.contains(area)).length,
          greaterThanOrEqualTo(3),
        );
      }
    },
  );

  test('every journey day points at real quotes and quests', () async {
    final journeys = await repo.loadJourneys();
    final quoteIds = (await repo.loadQuotes()).map((q) => q.id).toSet();
    final questIds = (await repo.loadQuests()).map((q) => q.id).toSet();

    expect(journeys, isNotEmpty);
    expect(journeys.map((j) => j.id).toSet(), hasLength(journeys.length));
    for (final journey in journeys) {
      expect(journey.days, anyOf(7, 14));
      expect(journey.titleFor('en'), isNotEmpty);
      expect(journey.summaryFor('en'), isNotEmpty);
      expect(journey.daysPlan.map((d) => d.day), [
        for (var day = 1; day <= journey.days; day++) day,
      ]);
      for (final plan in journey.daysPlan) {
        expect(plan.quoteIds, hasLength(3));
        expect(quoteIds.containsAll(plan.quoteIds), isTrue);
        expect(questIds, contains(plan.questId));
        expect(plan.reflectionFor('en'), isNotEmpty);
      }
    }
  });

  test('loads all 12 signs with palettes of 4-6 colors', () async {
    final signs = await repo.loadSigns();
    expect(signs, hasLength(12));
    expect(
      signs.map((s) => s.index),
      orderedEquals(List.generate(12, (i) => i)),
    );
    for (final sign in signs) {
      expect(sign.palette.length, inInclusiveRange(4, 6));
    }
    expect(signs.first.element, Element.fire);
  });

  test('textFor falls back to English for a missing language', () {
    const quote = Quote(id: 'q', text: {'en': 'Hello'}, category: 'self_love');
    expect(quote.textFor('my'), 'Hello');
    expect(quote.textFor('en'), 'Hello');
  });

  test(
    'loads an element palette for each element and seven Thai days',
    () async {
      final colors = await repo.loadDayColors();
      expect(colors.elements.keys, unorderedEquals(Element.values));
      for (final palette in colors.elements.values) {
        expect(palette.length, inInclusiveRange(4, 6));
      }
      expect(
        colors.thaiDays.map((c) => c.weekday),
        unorderedEquals([1, 2, 3, 4, 5, 6, 7]),
      );
      expect(
        colors.thaiDays.singleWhere((c) => c.weekday == DateTime.sunday).name,
        'Red',
      );
    },
  );

  group('fallback readings', () {
    test('cover every sign with three things to avoid in each text', () async {
      final readings = await repo.loadFallbackReadings('en');
      final signs = await repo.loadSigns();
      expect(readings!.keys, unorderedEquals(signs.map((s) => s.id)));
      for (final texts in readings.values) {
        expect(texts.length, greaterThanOrEqualTo(2));
        for (final text in texts) {
          expect(text.headline, isNotEmpty);
          expect(text.body.split(' ').length, inInclusiveRange(30, 120));
          expect(text.energy, isNotEmpty);
          expect(text.love, isNotEmpty);
          expect(text.avoid, hasLength(3));
        }
      }
    });

    test(
      'Burmese covers every sign and variant with three things to avoid',
      () async {
        final en = await repo.loadFallbackReadings('en');
        final my = await repo.loadFallbackReadings('my');
        expect(my!.keys, unorderedEquals(en!.keys));
        for (final id in en.keys) {
          expect(my[id]!.length, en[id]!.length, reason: id);
          for (final text in my[id]!) {
            expect(text.headline, isNotEmpty);
            expect(text.body, isNotEmpty);
            expect(text.energy, isNotEmpty);
            expect(text.love, isNotEmpty);
            expect(text.avoid, hasLength(3));
          }
        }
      },
    );

    test('are null for a language with no file', () async {
      expect(await repo.loadFallbackReadings('th'), isNull);
    });

    test('every listed language has a file', () {
      for (final lang in AssetContentRepository.fallbackReadingLanguages) {
        expect(
          File('${AssetContentRepository.fallbackReadingsDir}/$lang.json')
              .existsSync(),
          isTrue,
          reason: lang,
        );
      }
    });
  });
}
