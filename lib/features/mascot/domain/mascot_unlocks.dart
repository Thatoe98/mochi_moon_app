import 'package:mochi_moon/core/content/mascot_item.dart';
import 'package:mochi_moon/features/mascot/domain/mascot_state.dart';

/// The ids of items whose unlock rule is met and that are not owned yet.
///
/// A `streak` rule is met when [streak] reaches its day count; a `journey`
/// rule when its journey id is in [finishedJourneyIds]. Unknown rule types
/// and malformed values never unlock.
List<String> newlyEarned(
  List<MascotItem> items,
  MascotState state, {
  required int streak,
  required Set<String> finishedJourneyIds,
}) => [
  for (final item in items)
    if (!state.owns(item.id) &&
        _met(item.unlock, streak: streak, journeys: finishedJourneyIds))
      item.id,
];

bool _met(
  MascotUnlock unlock, {
  required int streak,
  required Set<String> journeys,
}) {
  final value = unlock.value;
  return switch (unlock.type) {
    'streak' => value is int && streak >= value,
    'journey' => value is String && journeys.contains(value),
    _ => false,
  };
}

/// Whether she may put [item] on now: she owns it, and a Premium item needs
/// Premium.
bool canEquip(MascotItem item, MascotState state, {required bool isPremium}) =>
    state.owns(item.id) && (!item.premium || isPremium);
