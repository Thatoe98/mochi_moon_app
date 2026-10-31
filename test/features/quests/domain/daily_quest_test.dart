import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/quest.dart';
import 'package:mochi_moon/features/quests/domain/daily_quest.dart';

Quest _q(String id, List<String> areas, {bool premium = false}) =>
    Quest(id: id, text: {'en': 'Do $id'}, focusAreas: areas, premium: premium);

void main() {
  final quests = [
    _q('a', ['calm']),
    _q('b', ['calm', 'healing']),
    _q('c', ['confidence']),
    _q('d', ['healing']),
    _q('e', ['confidence']),
    _q('paid', ['calm'], premium: true),
  ];

  test('the same day gives the same quest at any hour', () {
    final morning = dailyQuest(quests, DateTime(2026, 11, 1, 6));
    final night = dailyQuest(quests, DateTime(2026, 11, 1, 23, 59));

    expect(morning?.id, night?.id);
  });

  test('the order of the file does not matter', () {
    final shuffled = quests.reversed.toList();

    expect(
      dailyQuest(quests, DateTime(2026, 11))?.id,
      dailyQuest(shuffled, DateTime(2026, 11))?.id,
    );
  });

  test('the next days move through the quests', () {
    final ids = {
      for (var day = 1; day <= 5; day++)
        dailyQuest(quests, DateTime(2026, 11, day))!.id,
    };

    expect(ids, hasLength(5));
  });

  test('picks only free quests that match her focus areas', () {
    for (var day = 1; day <= 30; day++) {
      final quest = dailyQuest(
        quests,
        DateTime(2026, 11, day),
        focusAreas: ['confidence'],
      )!;
      expect(quest.focusAreas, contains('confidence'));
      expect(quest.premium, isFalse);
    }
  });

  test('uses every free quest with no focus or no match', () {
    final none = {
      for (var day = 1; day <= 5; day++)
        dailyQuest(quests, DateTime(2026, 11, day))!.id,
    };
    final unmatched = dailyQuest(
      quests,
      DateTime(2026, 11),
      focusAreas: ['study_work'],
    );

    expect(none, isNot(contains('paid')));
    expect(unmatched, isNotNull);
  });

  test('the swap is a different quest, and the same all day', () {
    for (var day = 1; day <= 30; day++) {
      final date = DateTime(2026, 11, day);
      final first = dailyQuest(quests, date)!;
      final swapped = dailyQuest(quests, date, swapped: true)!;
      final later = dailyQuest(
        quests,
        DateTime(2026, 11, day, 22),
        swapped: true,
      )!;
      expect(swapped.id, isNot(first.id));
      expect(later.id, swapped.id);
    }
  });

  test('a single quest swaps to itself, and no quests gives null', () {
    final one = [
      _q('only', ['calm']),
    ];

    expect(dailyQuest(one, DateTime(2026, 11), swapped: true)?.id, 'only');
    expect(dailyQuest(const [], DateTime(2026, 11)), isNull);
    expect(
      dailyQuest([
        _q('p', ['calm'], premium: true),
      ], DateTime(2026, 11)),
      isNull,
    );
  });
}
