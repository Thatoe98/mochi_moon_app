import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../../../tool/translate/quotes_batch.dart';

const _my = 'ကျေးဇူးတင်ပါတယ်';

List<Object?> _quotes() => [
  {
    'id': 'q_1',
    'text': {'en': 'I am enough.'},
    'category': 'self_love',
  },
  {
    'id': 'q_2',
    'text': {'en': 'I rest.', 'my': _my},
    'category': 'self_love',
  },
];

void main() {
  test('quoteSource keys the English texts by id', () {
    expect(quoteSource(_quotes()), {'q_1': 'I am enough.', 'q_2': 'I rest.'});
  });

  group('pendingQuotes', () {
    test('lists quotes without a Burmese text', () {
      expect(pendingQuotes(_quotes()), ['q_1']);
    });

    test('--force lists all, --only filters by id', () {
      expect(pendingQuotes(_quotes(), force: true), ['q_1', 'q_2']);
      expect(pendingQuotes(_quotes(), force: true, only: RegExp('2')), ['q_2']);
    });
  });

  test('mergeQuotes adds the text and leaves everything else alone', () {
    final merged = mergeQuotes(_quotes(), {'q_1': _my});
    final first = merged.first! as Map<String, Object?>;
    expect(first['text'], {'en': 'I am enough.', 'my': _my});
    expect(first['category'], 'self_love');
    expect(merged.last, _quotes().last);
  });

  test('encodeQuotes keeps the other fields and a trailing newline', () {
    final text = encodeQuotes({'version': 1}, mergeQuotes(_quotes(), {}));
    expect(text, endsWith('}\n'));
    final json = jsonDecode(text) as Map<String, Object?>;
    expect(json['version'], 1);
    expect(json['quotes'], hasLength(2));
  });
}
