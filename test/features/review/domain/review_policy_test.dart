import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';
import 'package:mochi_moon/features/review/domain/review_policy.dart';

void main() {
  final now = DateTime(2026, 11, 14, 20);
  const fresh = ReviewHistory();

  bool ask({
    int streak = 5,
    Mood? mood = Mood.happy,
    ReviewHistory history = fresh,
  }) => shouldAskForReview(
    streak: streak,
    todayMood: mood,
    history: history,
    now: now,
  );

  test('asks on a first good day with a streak', () {
    expect(ask(), isTrue);
  });

  test('asks when no mood was picked', () {
    expect(ask(mood: null), isTrue);
  });

  test('waits for a streak of three', () {
    expect(ask(streak: 2), isFalse);
    expect(ask(streak: 3), isTrue);
  });

  test('never asks on a low-mood day', () {
    for (final mood in [Mood.sad, Mood.anxious, Mood.tired]) {
      expect(ask(mood: mood), isFalse, reason: mood.name);
    }
  });

  test('asks on the good moods', () {
    for (final mood in [Mood.happy, Mood.calm, Mood.inLove]) {
      expect(ask(mood: mood), isTrue, reason: mood.name);
    }
  });

  test('leaves 120 days between asks', () {
    ReviewHistory askedDaysAgo(int days) => ReviewHistory(
      lastAsked: now.subtract(Duration(days: days)),
      timesAsked: 1,
    );
    expect(ask(history: askedDaysAgo(119)), isFalse);
    expect(ask(history: askedDaysAgo(120)), isTrue);
  });

  test('stops after three asks', () {
    final history = ReviewHistory(
      lastAsked: now.subtract(const Duration(days: 400)),
      timesAsked: 3,
    );
    expect(ask(history: history), isFalse);
  });
}
