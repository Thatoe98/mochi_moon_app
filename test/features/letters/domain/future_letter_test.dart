import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/letters/domain/future_letter.dart';

void main() {
  final written = DateTime(2026, 11, 2, 22, 30);

  test('a letter opens N calendar days later at 9 in the morning', () {
    expect(letterUnlockAt(written, 30), DateTime(2026, 12, 2, 9));
    expect(letterUnlockAt(written, 365), DateTime(2027, 11, 2, 9));
  });

  test('it cannot be read before its time and can be at it', () {
    final letter = sealLetter(
      id: 'a',
      text: '  Hello  ',
      unlockDays: 30,
      now: written,
    );
    expect(letter.body, 'Hello');
    expect(letter.isOpen(DateTime(2026, 12, 2, 8, 59)), isFalse);
    expect(letter.isOpen(DateTime(2026, 12, 2, 9)), isTrue);
    expect(letter.isOpen(DateTime(2027)), isTrue);
  });

  test('checks the text and the waiting time', () {
    expect(checkLetter('  ', unlockDays: 30), LetterRejection.empty);
    expect(
      checkLetter('a' * (letterMaxLength + 1), unlockDays: 30),
      LetterRejection.tooLong,
    );
    expect(checkLetter('hi', unlockDays: 7), LetterRejection.badDelay);
    expect(checkLetter('a' * letterMaxLength, unlockDays: 365), isNull);
  });

  test('notification ids stay inside their block', () {
    for (final id in ['a', 'b', 'abcdefghijklmnopqrst', 'zzz']) {
      final value = letterNotificationId(id, base: 2000);
      expect(value, inInclusiveRange(2000, 2999));
      expect(value, letterNotificationId(id, base: 2000));
    }
  });
}
