import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mochi_moon/core/premium/free_limits.dart';
import 'package:mochi_moon/features/profile/domain/birth_place.dart';

part 'partner.freezed.dart';

/// Longest nickname the form accepts (also enforced by the Firestore rules).
const maxPartnerNicknameLength = 30;

/// Most partners a Free user can save (PRD §6.12).
const int freePartnerLimit = FreeLimits.partners;

/// Most partners a Premium user can save (PRD §6.12).
const premiumPartnerLimit = 5;

/// How many partners can be saved with or without Premium.
int partnerLimit({required bool hasPremium}) =>
    hasPremium ? premiumPartnerLimit : freePartnerLimit;

/// Someone the user compares themselves with (PRD §6.12). Only the nickname
/// and birth data are kept; they live on the device and in the user's own
/// Firestore subcollection.
@freezed
abstract class Partner with _$Partner {
  const factory Partner({
    required String id,
    required String nickname,

    /// Date only; the time part is ignored.
    required DateTime birthDate,
    required DateTime createdAt,

    /// Minutes since midnight, local to [birthPlace]. Null when unknown.
    int? birthMinutes,
    BirthPlace? birthPlace,
  }) = _Partner;

  const Partner._();

  bool get timeKnown => birthMinutes != null;
}

/// Thrown when saving a new partner would go over [partnerLimit].
class PartnerLimitReached implements Exception {
  const PartnerLimitReached(this.limit);

  final int limit;

  @override
  String toString() => 'PartnerLimitReached($limit)';
}
