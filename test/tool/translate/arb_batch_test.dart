import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../../../tool/translate/arb_batch.dart';

const _thanks = 'ကျေးဇူးတင်ပါတယ်';
const _zawgyi = 'ေက်းဇူးတင္ပါတယ္';
const _moon = 'လ {sign} တွင်';

final ArbMap _en = {
  '@@locale': 'en',
  'thanks': 'Thank you',
  '@thanks': {'description': 'A warm thank-you on the card.'},
  'moonIn': 'Moon in {sign}',
  'hello': 'Hello',
  '@hello': {'description': 'Greeting'},
};

/// A scripted model: one answer per call; records the prompts it was sent.
class _FakeChat {
  _FakeChat(this.answers);

  final List<String> answers;
  final users = <String>[];

  Future<String> call({required String system, required String user}) async {
    users.add(user);
    return answers[users.length - 1];
  }
}

void main() {
  group('pendingKeys', () {
    test('skips metadata and keys that are already translated', () {
      expect(pendingKeys(_en, {'thanks': _thanks}), ['moonIn', 'hello']);
    });

    test('filters with only, and --force retranslates everything', () {
      expect(pendingKeys(_en, const {}, only: RegExp('^moon')), ['moonIn']);
      expect(pendingKeys(_en, {'thanks': _thanks}, force: true), [
        'thanks',
        'moonIn',
        'hello',
      ]);
    });
  });

  group('arbUserPrompt', () {
    test('carries notes, retry problems and a glossary of other strings', () {
      final prompt = jsonDecode(
        arbUserPrompt(
          en: _en,
          my: {'hello': 'မင်္ဂလာပါ'},
          keys: ['thanks'],
          problems: {
            'thanks': ['empty'],
          },
        ),
      ) as Map<String, Object?>;
      final strings = prompt['strings']! as Map<String, Object?>;
      expect(strings['thanks'], {
        'en': 'Thank you',
        'note': 'A warm thank-you on the card.',
        'fix': ['empty'],
      });
      expect(prompt['glossary_of_existing_translations'], {
        'Hello': 'မင်္ဂလာပါ',
      });
    });

    test('never includes the key being translated in the glossary', () {
      final prompt = jsonDecode(
        arbUserPrompt(en: _en, my: {'thanks': _thanks}, keys: ['thanks']),
      ) as Map<String, Object?>;
      expect(prompt['glossary_of_existing_translations'], isEmpty);
    });
  });

  group('parseAnswer', () {
    test('reads plain and fenced JSON', () {
      expect(parseAnswer('{"a":"b"}'), {'a': 'b'});
      expect(parseAnswer('```json\n{"a":"b"}\n```'), {'a': 'b'});
    });

    test('rejects anything but an object', () {
      expect(() => parseAnswer('[1]'), throwsFormatException);
      expect(() => parseAnswer('nope'), throwsFormatException);
    });
  });

  group('translateArb', () {
    test('keeps good answers and retries only the failed keys', () async {
      final chat = _FakeChat([
        jsonEncode({'thanks': _zawgyi, 'moonIn': _moon}),
        jsonEncode({'thanks': _thanks}),
      ]);
      final result = await translateArb(
        chat: chat.call,
        en: _en,
        my: const {},
        keys: ['thanks', 'moonIn'],
      );

      expect(result.done, {'thanks': _thanks, 'moonIn': _moon});
      expect(result.failed, isEmpty);
      expect(chat.users, hasLength(2));
      final retry = jsonDecode(chat.users[1]) as Map<String, Object?>;
      final strings = retry['strings']! as Map<String, Object?>;
      expect(strings.keys, ['thanks']);
      expect((strings['thanks']! as Map<String, Object?>)['fix'], isNotEmpty);
    });

    test('reports keys that still fail after the retry', () async {
      final chat = _FakeChat([
        'not json',
        jsonEncode({'moonIn': 'Moon in {sign}'}),
      ]);
      final result = await translateArb(
        chat: chat.call,
        en: _en,
        my: const {},
        keys: ['moonIn'],
      );

      expect(result.done, isEmpty);
      expect(result.failed.keys, ['moonIn']);
      expect(chat.users, hasLength(2));
    });
  });

  group('mergeArb', () {
    test('follows the English order, keeps old text and adds new', () {
      final merged = mergeArb(
        _en,
        {'@@locale': 'my', 'hello': 'မင်္ဂလာပါ', 'removedInEnglish': 'x'},
        {'thanks': _thanks},
      );
      expect(merged.keys, ['@@locale', 'thanks', 'hello']);
      expect(merged['thanks'], _thanks);
      expect(merged['hello'], 'မင်္ဂလာပါ');
    });

    test('encodes with a trailing newline and keeps Burmese readable', () {
      final text = encodeArb({'@@locale': 'my', 'thanks': _thanks});
      expect(text, endsWith('}\n'));
      expect(text, contains(_thanks));
    });
  });
}
