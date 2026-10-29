import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/asset_content_repository.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/content/sign_info.dart';

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

  test('loads the 20 sample quotes with unique ids', () async {
    final quotes = await repo.loadQuotes();
    expect(quotes, hasLength(20));
    expect(quotes.map((q) => q.id).toSet(), hasLength(20));
    expect(quotes.every((q) => q.textFor('en').isNotEmpty), isTrue);
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

  test('loads an element palette for each element and seven Thai days', () async {
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
  });

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

    test('are null for a language with no file', () async {
      expect(await repo.loadFallbackReadings('my'), isNull);
      expect(await repo.loadFallbackReadings('th'), isNull);
    });

    test('every listed language has a file', () {
      for (final lang in AssetContentRepository.fallbackReadingLanguages) {
        expect(
          File(
            '${AssetContentRepository.fallbackReadingsDir}/$lang.json',
          ).existsSync(),
          isTrue,
          reason: lang,
        );
      }
    });
  });
}
