import 'package:flutter/foundation.dart';
import 'package:mochi_moon/core/content/mascot_item.dart';

/// What Mochi owns and wears (PRD §6.23). Items are only ever added: a missed
/// day never takes anything away.
@immutable
class MascotState {
  const MascotState({this.owned = const [], this.equipped = const {}});

  /// Item ids, in the order they were earned.
  final List<String> owned;

  /// Item id by slot (`outfit` or a room slot). One item per slot.
  final Map<String, String> equipped;

  String? get outfit => equipped[outfitSlot];

  Map<String, String> get room => {
    for (final entry in equipped.entries)
      if (entry.key != outfitSlot) entry.key: entry.value,
  };

  bool owns(String itemId) => owned.contains(itemId);

  @override
  bool operator ==(Object other) =>
      other is MascotState &&
      listEquals(owned, other.owned) &&
      mapEquals(equipped, other.equipped);

  @override
  int get hashCode => Object.hash(
    Object.hashAll(owned),
    Object.hashAllUnordered(
      equipped.entries.map((e) => Object.hash(e.key, e.value)),
    ),
  );
}
