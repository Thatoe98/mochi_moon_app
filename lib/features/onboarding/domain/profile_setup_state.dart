import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';
import 'package:mochi_moon/features/settings/domain/reminder.dart';

part 'profile_setup_state.freezed.dart';

/// The steps after sign-in, in order (PRD §6.1). Birthplace joins between the
/// time and the reminder once the cities list exists.
enum ProfileStep { name, birthDate, birthTime, reminder, focus }

/// Everything entered so far. It lives in one place, so going back and forward
/// never loses an answer.
@freezed
abstract class ProfileSetupState with _$ProfileSetupState {
  const factory ProfileSetupState({
    @Default(ProfileStep.name) ProfileStep step,
    @Default('') String name,
    DateTime? birthDate,

    /// Minutes since midnight; null is "I don't know".
    int? birthMinutes,
    @Default(true) bool reminderEnabled,
    @Default(ReminderTime.defaultTime) ReminderTime reminderTime,
    @Default(<FocusArea>[]) List<FocusArea> focusAreas,
    @Default(false) bool saving,
  }) = _ProfileSetupState;

  const ProfileSetupState._();

  bool get isFirstStep => step == ProfileStep.values.first;
  bool get isLastStep => step == ProfileStep.values.last;

  /// Whether the current step has what it needs. The time, reminder and focus
  /// steps are optional.
  bool canContinue(DateTime today) => switch (step) {
    ProfileStep.name => name.trim().isNotEmpty,
    ProfileStep.birthDate =>
      birthDate != null && isValidBirthDate(birthDate!, today),
    ProfileStep.birthTime || ProfileStep.reminder || ProfileStep.focus => true,
  };

  UserProfile toProfile() => UserProfile(
    displayName: name.trim(),
    birthDate: birthDate,
    birthMinutes: birthMinutes,
    focusAreas: focusAreas,
  );
}
