import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/deck/domain/read_aloud_gate.dart';

String words(int count) => List.filled(count, 'moon').join(' ');

void main() {
  group('readAloudLockDuration', () {
    test('short text gets the 3 s minimum', () {
      expect(readAloudLockDuration('You are enough'), minReadAloudLock);
    });

    test('empty text still gets the minimum', () {
      expect(readAloudLockDuration(''), minReadAloudLock);
    });

    test('scales at 2.5 words per second between the bounds', () {
      expect(readAloudLockDuration(words(15)), const Duration(seconds: 6));
    });

    test('long text is capped at 8 s', () {
      expect(readAloudLockDuration(words(60)), maxReadAloudLock);
    });

    test('extra whitespace is not counted as words', () {
      expect(
        readAloudLockDuration('  a \n b\t c  '),
        readAloudLockDuration('a b c'),
      );
    });

    test('Burmese without spaces counts as one word', () {
      expect(readAloudLockDuration('သင်ဟာလုံလောက်ပါတယ်'), minReadAloudLock);
    });
  });
}
