import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/gratitude/domain/gratitude.dart';

GratitudeNote _note(String id, DateTime day) =>
    GratitudeNote(id: id, day: day, body: 'Thanks $id', createdAt: day);

void main() {
  group('checkGratitude', () {
    test('accepts a short line', () {
      expect(checkGratitude('Warm tea', countToday: 0), isNull);
    });

    test('rejects an empty or blank line', () {
      expect(checkGratitude('', countToday: 0), GratitudeRejection.empty);
      expect(checkGratitude('   ', countToday: 0), GratitudeRejection.empty);
    });

    test('allows exactly 200 characters and rejects 201', () {
      expect(checkGratitude('a' * 200, countToday: 0), isNull);
      expect(
        checkGratitude('a' * 201, countToday: 0),
        GratitudeRejection.tooLong,
      );
    });

    test('allows three a day and rejects the fourth', () {
      expect(checkGratitude('x', countToday: 2), isNull);
      expect(checkGratitude('x', countToday: 3), GratitudeRejection.dayFull);
    });
  });

  test('counts only the entries of the given local day', () {
    final today = DateTime(2026, 10, 28, 20);
    final entries = [
      _note('a', DateTime(2026, 10, 28, 8)),
      _note('b', DateTime(2026, 10, 27)),
    ];
    expect(gratitudeCountOn(entries, today), 1);
  });

  group('shuffledPast', () {
    final today = DateTime(2026, 10, 28, 9);
    final entries = [
      _note('today', DateTime(2026, 10, 28)),
      _note('old1', DateTime(2026, 10, 27)),
      _note('old2', DateTime(2026, 10)),
      _note('old3', DateTime(2025, 12, 31)),
    ];

    test('never includes an entry from today', () {
      for (var seed = 0; seed < 20; seed++) {
        final shown = shuffledPast(entries, today, Random(seed));
        expect(shown.map((e) => e.id), isNot(contains('today')));
        expect(shown, hasLength(3));
      }
    });

    test('is empty when everything was written today', () {
      expect(shuffledPast([entries.first], today), isEmpty);
    });
  });

  test('date keys round trip and reject nonsense', () {
    final day = DateTime(2026, 3, 4);
    expect(gratitudeDateKey(day), '2026-03-04');
    expect(parseGratitudeDateKey('2026-03-04'), day);
    expect(parseGratitudeDateKey('2026-02-31'), isNull);
    expect(parseGratitudeDateKey('nope'), isNull);
  });

  test('new ids are 20 characters and differ', () {
    final a = newGratitudeId();
    expect(a, hasLength(20));
    expect(newGratitudeId(), isNot(a));
  });
}
