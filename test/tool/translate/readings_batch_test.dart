import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../../../tool/translate/readings_batch.dart';

const _my = 'ကျေးဇူးတင်ပါတယ်';
const _zawgyi = 'ေက်းဇူးတင္ပါတယ္';

Map<String, Object?> _variant(String text) => {
  'headline': text,
  'body': text,
  'energy': text,
  'love': text,
  'avoid': [text, text, text],
};

final List<Object?> _source = [_variant('Be gentle with yourself today')];

class _FakeChat {
  _FakeChat(this.answers);

  final List<String> answers;
  int calls = 0;

  Future<String> call({required String system, required String user}) async =>
      answers[calls++];
}

String _answer(Object? variants) => jsonEncode({'variants': variants});

void main() {
  group('checkVariants', () {
    test('passes a complete Burmese variant', () {
      expect(checkVariants(_source, [_variant(_my)]), isEmpty);
    });

    test('needs the same number of variants', () {
      expect(checkVariants(_source, <Object?>[]), isNotEmpty);
      expect(checkVariants(_source, 'text'), isNotEmpty);
    });

    test('needs exactly three avoid items', () {
      final bad = _variant(_my)..['avoid'] = [_my, _my];
      expect(checkVariants(_source, [bad]), isNotEmpty);
    });

    test('flags a missing field and Zawgyi text', () {
      final missing = _variant(_my)..remove('love');
      expect(checkVariants(_source, [missing]).single, contains('love'));
      expect(checkVariants(_source, [_variant(_zawgyi)]), isNotEmpty);
    });
  });

  group('translateSign', () {
    test('returns a good answer on the first try', () async {
      final chat = _FakeChat([
        _answer([_variant(_my)]),
      ]);
      final result = await translateSign(
        chat: chat.call,
        signId: 'aries',
        source: _source,
      );
      expect(result.variants, [_variant(_my)]);
      expect(result.problems, isEmpty);
      expect(chat.calls, 1);
    });

    test('retries once after a bad answer', () async {
      final chat = _FakeChat([
        _answer([_variant(_zawgyi)]),
        _answer([_variant(_my)]),
      ]);
      final result = await translateSign(
        chat: chat.call,
        signId: 'aries',
        source: _source,
      );
      expect(result.variants, isNotNull);
      expect(chat.calls, 2);
    });

    test('gives up with the problems after two bad answers', () async {
      final chat = _FakeChat([
        'not json',
        _answer([_variant(_zawgyi)]),
      ]);
      final result = await translateSign(
        chat: chat.call,
        signId: 'aries',
        source: _source,
      );
      expect(result.variants, isNull);
      expect(result.problems, isNotEmpty);
    });
  });

  group('mergeReadings', () {
    final en = <String, Object?>{
      'version': 3,
      'lang': 'en',
      'readings': {
        'aries': [_variant('a')],
        'taurus': [_variant('t')],
      },
    };

    test('writes my.json in English sign order and keeps earlier signs', () {
      final merged = mergeReadings(
        en,
        {
          'readings': {
            'taurus': [_variant(_my)],
          },
        },
        {
          'aries': [_variant(_my)],
        },
      );
      expect(merged['lang'], 'my');
      expect(merged['version'], 3);
      expect((merged['readings']! as Map).keys, ['aries', 'taurus']);
    });

    test('leaves out signs not translated yet', () {
      final merged = mergeReadings(en, null, {
        'taurus': [_variant(_my)],
      });
      expect((merged['readings']! as Map).keys, ['taurus']);
      expect(encodeReadings(merged), endsWith('}\n'));
    });
  });
}
