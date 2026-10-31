import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';

void main() {
  test('every mood round-trips through its id', () {
    for (final mood in Mood.values) {
      expect(Mood.fromId(mood.id), mood);
    }
    expect(Mood.fromId('nope'), isNull);
    expect(Mood.inLove.id, 'in_love');
  });

  test('moodDateKey pads month and day', () {
    expect(moodDateKey(DateTime(2026, 3, 5, 23, 59)), '2026-03-05');
  });

  test('parseMoodDateKey reads a key and rejects junk', () {
    expect(parseMoodDateKey('2026-10-28'), DateTime(2026, 10, 28));
    expect(parseMoodDateKey('28-10-2026'), isNull);
    expect(parseMoodDateKey('hello'), isNull);
  });

  test('DayMood keeps only the date', () {
    final a = DayMood(day: DateTime(2026, 10, 28, 9, 30), mood: Mood.calm);
    expect(a.day, DateTime(2026, 10, 28));
    expect(a, DayMood(day: DateTime(2026, 10, 28, 22), mood: Mood.calm));
  });
}
