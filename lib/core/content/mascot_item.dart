import 'package:freezed_annotation/freezed_annotation.dart';

part 'mascot_item.freezed.dart';
part 'mascot_item.g.dart';

const _fallbackLang = 'en';

/// The slot of outfits. Every other slot is a spot in Mochi's room.
const outfitSlot = 'outfit';

/// How an item is earned (PRD §6.23). [type] is `streak` (a day count in
/// [value]) or `journey` (a journey id in [value]).
@freezed
abstract class MascotUnlock with _$MascotUnlock {
  const factory MascotUnlock({required String type, required Object value}) =
      _MascotUnlock;

  factory MascotUnlock.fromJson(Map<String, dynamic> json) =>
      _$MascotUnlockFromJson(json);
}

/// An outfit or room item from `mascot_items.json` (PRD §6.23, §8.3).
@freezed
abstract class MascotItem with _$MascotItem {
  const factory MascotItem({
    required String id,

    /// `outfit`, or a room slot such as `shelf` or `floor`.
    required String slot,
    required Map<String, String> name,
    required MascotUnlock unlock,
    required String illustrationId,
    @Default(false) bool premium,
  }) = _MascotItem;

  const MascotItem._();

  factory MascotItem.fromJson(Map<String, dynamic> json) =>
      _$MascotItemFromJson(json);

  bool get isOutfit => slot == outfitSlot;

  String nameFor(String lang) => name[lang] ?? name[_fallbackLang] ?? '';
}
