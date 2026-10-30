import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mochi_moon/features/partners/domain/partner.dart';
import 'package:mochi_moon/features/profile/domain/birth_place.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';

part 'partner_draft.freezed.dart';

/// What the add / edit form holds before it is saved.
@freezed
abstract class PartnerDraft with _$PartnerDraft {
  const factory PartnerDraft({
    @Default('') String nickname,
    DateTime? birthDate,

    /// Minutes since midnight; null is "I don't know".
    int? birthMinutes,
    BirthPlace? birthPlace,
  }) = _PartnerDraft;

  const PartnerDraft._();

  /// A draft for editing [partner].
  factory PartnerDraft.of(Partner partner) => PartnerDraft(
    nickname: partner.nickname,
    birthDate: partner.birthDate,
    birthMinutes: partner.birthMinutes,
    birthPlace: partner.birthPlace,
  );

  /// The nickname as it is saved.
  String get trimmedNickname => nickname.trim();

  /// The birth date is required; the time and place are optional, but a time
  /// only means something in a known time zone, so it needs the place (as in
  /// the profile, PRD §6.1).
  bool isValid(DateTime today) =>
      trimmedNickname.isNotEmpty &&
      trimmedNickname.length <= maxPartnerNicknameLength &&
      birthDate != null &&
      isValidBirthDate(birthDate!, today) &&
      (birthMinutes == null || birthPlace != null);

  /// Whether a birth time was chosen without the place it needs.
  bool get missingPlace => birthMinutes != null && birthPlace == null;

  /// The partner this draft describes. Only call when [isValid].
  Partner toPartner({required String id, required DateTime createdAt}) =>
      Partner(
        id: id,
        nickname: trimmedNickname,
        birthDate: DateTime(birthDate!.year, birthDate!.month, birthDate!.day),
        birthMinutes: birthMinutes,
        birthPlace: birthPlace,
        createdAt: createdAt,
      );
}
