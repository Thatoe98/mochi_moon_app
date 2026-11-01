import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/mascot_item.dart';
import 'package:mochi_moon/features/mascot/domain/mascot_state.dart';
import 'package:mochi_moon/features/mascot/domain/mascot_unlocks.dart';

MascotItem _item(
  String id,
  MascotUnlock unlock, {
  String slot = 'outfit',
  bool premium = false,
}) => MascotItem(
  id: id,
  slot: slot,
  name: {'en': id},
  unlock: unlock,
  illustrationId: 'ill_$id',
  premium: premium,
);

final List<MascotItem> _items = [
  _item('a', const MascotUnlock(type: 'streak', value: 3)),
  _item('b', const MascotUnlock(type: 'streak', value: 7), slot: 'floor'),
  _item('c', const MascotUnlock(type: 'journey', value: 'confidence')),
  _item('d', const MascotUnlock(type: 'mystery', value: 1)),
  _item('p', const MascotUnlock(type: 'streak', value: 3), premium: true),
];

List<String> _earned(
  MascotState state, {
  int streak = 0,
  Set<String> journeys = const {},
}) => newlyEarned(_items, state, streak: streak, finishedJourneyIds: journeys);

void main() {
  test('streak rules unlock at the day count and not before', () {
    expect(_earned(const MascotState(), streak: 2), isEmpty);
    expect(_earned(const MascotState(), streak: 3), ['a', 'p']);
    expect(_earned(const MascotState(), streak: 9), ['a', 'b', 'p']);
  });

  test('a journey rule needs that journey finished', () {
    expect(_earned(const MascotState(), journeys: {'confidence'}), ['c']);
  });

  test('owned items are not earned again, and a broken streak is harmless', () {
    expect(_earned(const MascotState(owned: ['a', 'p'])), isEmpty);
  });

  test('unknown rule types never unlock', () {
    expect(_earned(const MascotState(), streak: 999), isNot(contains('d')));
  });

  test('equipping needs ownership, and Premium items need Premium', () {
    const state = MascotState(owned: ['a', 'p']);
    expect(canEquip(_items[0], state, isPremium: false), isTrue);
    expect(canEquip(_items[1], state, isPremium: true), isFalse);
    expect(canEquip(_items[4], state, isPremium: false), isFalse);
    expect(canEquip(_items[4], state, isPremium: true), isTrue);
  });
}
