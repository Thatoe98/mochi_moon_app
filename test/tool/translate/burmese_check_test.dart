import 'package:flutter_test/flutter_test.dart';

import '../../../tool/translate/burmese_check.dart';

// "Thank you" in Unicode, and the same word in Zawgyi (the vowel sign comes
// before the consonant).
const _unicode = 'ကျေးဇူးတင်ပါတယ်';
const _zawgyi = 'ေက်းဇူးတင္ပါတယ္';

void main() {
  group('placeholderNames', () {
    test('finds simple and plural placeholders', () {
      expect(placeholderNames('Moon in {sign}'), {'sign'});
      expect(
        placeholderNames(
          '{count, plural, =1{1 day streak} other{{count} day streak}}',
        ),
        {'count'},
      );
      expect(placeholderNames('No placeholders {1 day}'), isEmpty);
    });
  });

  group('looksLikeZawgyi', () {
    test('accepts Unicode Burmese', () {
      expect(looksLikeZawgyi(_unicode), isFalse);
      expect(looksLikeZawgyi('ယနေ့ ကတ် {count} ကတ် ကျန်ပါသေးသည်'), isFalse);
      expect(looksLikeZawgyi('Mochi Moon'), isFalse);
    });

    test('flags a vowel sign before its consonant', () {
      expect(looksLikeZawgyi(_zawgyi), isTrue);
    });

    test('flags a medial with no consonant before it', () {
      expect(looksLikeZawgyi('ျမန္မာ'), isTrue);
    });

    test('flags the extended code points Zawgyi uses', () {
      expect(looksLikeZawgyi('ကၠ'), isTrue);
    });
  });

  group('checkBurmese', () {
    test('passes a good translation', () {
      expect(checkBurmese('Thank you', _unicode), isEmpty);
    });

    test('rejects empty text and text with no Burmese in it', () {
      expect(checkBurmese('Thank you', '  '), ['empty']);
      expect(
        checkBurmese('Thank you so much for today', 'Thank you so much'),
        contains('has no Burmese characters'),
      );
    });

    test('lets a short label stay in English', () {
      expect(checkBurmese('Aries', 'Aries'), isEmpty);
      expect(checkBurmese('Retrogrades', 'Retrogrades'), isEmpty);
    });

    test('rejects Burmese digits and accepts 0-9', () {
      expect(
        checkBurmese('Pick up to 3 cards today', 'ယနေ့ ကတ် ၃ ကတ်'),
        contains('uses Burmese digits; write 0-9'),
      );
      expect(checkBurmese('Pick up to 3 cards today', 'ယနေ့ ကတ် 3 ကတ်'), isEmpty);
    });

    test('rejects Zawgyi', () {
      expect(
        checkBurmese('Thank you', _zawgyi),
        contains('looks like Zawgyi, not Unicode'),
      );
    });

    test('requires the same placeholders', () {
      expect(checkBurmese('Moon in {sign}', 'လ $_unicode'), isNotEmpty);
      expect(checkBurmese('Moon in {sign}', 'လ {sign} တွင်'), isEmpty);
      expect(checkBurmese('Moon in {sign}', 'လ {star} တွင်'), isNotEmpty);
    });

    test('rejects unbalanced braces', () {
      expect(
        checkBurmese('Days: {count}', 'ရက် {count'),
        contains('unbalanced braces'),
      );
    });

    test('rejects an answer far longer than the English', () {
      final runaway = List.filled(60, _unicode).join(' ');
      expect(
        checkBurmese('A fairly short english sentence.', runaway),
        isNotEmpty,
      );
    });
  });
}
