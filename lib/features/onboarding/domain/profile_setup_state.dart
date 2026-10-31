import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mochi_moon/features/profile/domain/birth_place.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';
import 'package:mochi_moon/features/settings/domain/reminder.dart';

part 'profile_setup_state.freezed.dart';

/// The steps after sign-in, in order (PRD §6.1). Birth data is not asked here;
/// it comes with the Cosmic unlock flow.
enum ProfileStep { name, focus, reminder }

/// Everything entered so far. It lives in one place, so going back and forward
/// never loses an answer.
@freezed
abstract class ProfileSetupState with _$ProfileSetupState {
  const factory ProfileSetupState({
    @Default(ProfileStep.name) ProfileStep step,
    @Default('') String name,
    DateTime? birthDate,

    /// Birth data is not asked in this flow; it is carried over from a saved
    /// profile so finishing never erases it. Minutes since midnight; null is
    /// "I don't know".
    int? birthMinutes,
    BirthPlace? birthPlace,
    @Default(true) bool reminderEnabled,
    @Default(ReminderTime.defaultTime) ReminderTime reminderTime,
    @Default(<FocusArea>[]) List<FocusArea> focusAreas,
    @Default(false) bool saving,
  }) = _ProfileSetupState;

  const ProfileSetupState._();

  bool get isFirstStep => step == ProfileStep.values.first;
  bool get isLastStep => step == ProfileStep.values.last;

  /// Whether the current step has what it needs. Only the name is required.
  bool get canContinue => switch (step) {
    ProfileStep.name => name.trim().isNotEmpty,
    ProfileStep.focus || ProfileStep.reminder => true,
  };

  UserProfile toProfile() => UserProfile(
    displayName: name.trim(),
    birthDate: birthDate,
    birthMinutes: birthMinutes,
    birthPlace: birthPlace,
    focusAreas: focusAreas,
  );
}
