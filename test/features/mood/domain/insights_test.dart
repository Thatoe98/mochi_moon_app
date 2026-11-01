import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/mood/domain/insights.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';

DateTime _day(int i) => DateTime(2026, 10).add(Duration(days: i));

List<DayMood> _moods(List<Mood> moods) => [
  for (var i = 0; i < moods.length; i++) DayMood(day: _day(i), mood: moods[i]),
];

Iterable<MoodInsightKind> _kinds(List<Mood> moods, Set<DateTime> ritual) =>
    computeMoodInsights(_moods(moods), ritual).insights.map((e) => e.kind);

void main() {
  test('fewer than 14 logged days is not enough data', () {
    final result = computeMoodInsights(
      _moods(List.filled(13, Mood.calm)),
      const {},
    );
    expect(result.enoughData, isFalse);
    expect(result.daysToGo, 1);
    expect(result.insights, isEmpty);
  });

  test('14 days with one leading mood says it showed up most', () {
    final moods = [...List.filled(8, Mood.calm), ...List.filled(6, Mood.tired)];
    final result = computeMoodInsights(_moods(moods), const {});
    expect(result.enoughData, isTrue);
    final top = result.insights.single;
    expect(top.kind, MoodInsightKind.mostOften);
    expect(top.mood, Mood.calm);
    expect(top.count, 8);
    expect(top.total, 14);
  });

  test('a tie for first place names no mood', () {
    final moods = [...List.filled(7, Mood.calm), ...List.filled(7, Mood.happy)];
    expect(computeMoodInsights(_moods(moods), const {}).insights, isEmpty);
  });

  test('good moods on ritual days more than other days is noticed', () {
    final moods = [...List.filled(7, Mood.calm), ...List.filled(7, Mood.tired)];
    final ritual = {for (var i = 0; i < 7; i++) _day(i)};
    expect(_kinds(moods, ritual), contains(MoodInsightKind.ritualLift));
  });

  test('no ritual comparison when a side has too few days', () {
    final moods = [...List.filled(7, Mood.calm), ...List.filled(7, Mood.tired)];
    final ritual = {for (var i = 0; i < 3; i++) _day(i)};
    expect(_kinds(moods, ritual), isNot(contains(MoodInsightKind.ritualLift)));
  });

  test('insight wording has no diagnostic or medical terms', () {
    final arb = File('l10n/app_en.arb').readAsLinesSync();
    final lines = arb.where((l) => l.trimLeft().startsWith('"moodInsight'));
    expect(lines, isNotEmpty);
    const banned = [
      'depress',
      'disorder',
      'diagnos',
      'therap',
      'medic',
      'illness',
      'clinical',
      'symptom',
      'mental health',
      'condition',
      'treatment',
      'you should',
      'always',
      'never',
    ];
    for (final line in lines) {
      for (final word in banned) {
        expect(line.toLowerCase(), isNot(contains(word)), reason: line);
      }
    }
  });
}
