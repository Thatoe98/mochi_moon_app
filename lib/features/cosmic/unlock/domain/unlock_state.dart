import 'package:mochi_moon/features/profile/domain/birth_place.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';

/// The steps of "Unlock your cosmic side" (PRD §6.1), in order.
enum UnlockStep { birthDate, birthTime, birthPlace }

/// Everything entered so far, kept in one place so going back never loses an
/// answer.
class UnlockState {
  const UnlockState({
    this.step = UnlockStep.birthDate,
    this.birthDate,
    this.birthMinutes,
    this.birthPlace,
    this.saving = false,
  });

  final UnlockStep step;
  final DateTime? birthDate;

  /// Minutes since midnight; null is "I don't know".
  final int? birthMinutes;
  final BirthPlace? birthPlace;
  final bool saving;

  bool get isFirstStep => step == UnlockStep.values.first;
  bool get isLastStep => step == UnlockStep.values.last;

  /// The birth date is required; the time is optional; the birthplace is
  /// optional unless a time was given, because the time only means something
  /// in a known zone.
  bool canContinue(DateTime today) => switch (step) {
    UnlockStep.birthDate =>
      birthDate != null && isValidBirthDate(birthDate!, today),
    UnlockStep.birthTime => true,
    UnlockStep.birthPlace => birthMinutes == null || birthPlace != null,
  };

  UnlockState copyWith({
    UnlockStep? step,
    DateTime? birthDate,
    bool clearBirthMinutes = false,
    int? birthMinutes,
    bool clearBirthPlace = false,
    BirthPlace? birthPlace,
    bool? saving,
  }) => UnlockState(
    step: step ?? this.step,
    birthDate: birthDate ?? this.birthDate,
    birthMinutes: clearBirthMinutes ? null : birthMinutes ?? this.birthMinutes,
    birthPlace: clearBirthPlace ? null : birthPlace ?? this.birthPlace,
    saving: saving ?? this.saving,
  );
}
