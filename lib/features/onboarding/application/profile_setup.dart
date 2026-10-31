import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/onboarding/application/onboarding_providers.dart';
import 'package:mochi_moon/features/onboarding/domain/profile_setup_state.dart';
import 'package:mochi_moon/features/places/application/places_providers.dart';
import 'package:mochi_moon/features/places/domain/city.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/profile/domain/birth_place.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';
import 'package:mochi_moon/features/settings/domain/reminder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_setup.g.dart';

/// The profile steps after sign-in. Answers are kept here, not in the step
/// widgets, so going back never loses them.
@riverpod
class ProfileSetup extends _$ProfileSetup {
  @override
  ProfileSetupState build() {
    // Start from what is already known: a half-finished earlier run, or the
    // name on the Google account.
    final saved = ref.read(profileControllerProvider).value;
    final accountName = ref
        .read(authRepositoryProvider)
        .currentUser
        ?.displayName;
    return ProfileSetupState(
      name: saved?.displayName.isNotEmpty ?? false
          ? saved!.displayName
          : accountName ?? '',
      birthDate: saved?.birthDate,
      birthMinutes: saved?.birthMinutes,
      birthPlace: saved?.birthPlace,
      focusAreas: saved?.focusAreas ?? const [],
    );
  }

  void setName(String name) => state = state.copyWith(name: name);

  void setBirthDate(DateTime date) => state = state.copyWith(
    birthDate: DateTime(date.year, date.month, date.day),
  );

  /// Pass null for "I don't know".
  void setBirthMinutes(int? minutes) =>
      state = state.copyWith(birthMinutes: minutes);

  /// Picks [city] as the birthplace and looks up its time zone. Pass null to
  /// clear it.
  void setBirthCity(City? city) {
    if (city == null) {
      state = state.copyWith(birthPlace: null);
      return;
    }
    final tzId = ref
        .read(timeZoneResolverProvider)
        .resolve(lat: city.lat, lng: city.lng);
    state = state.copyWith(
      birthPlace: BirthPlace(
        name: city.name,
        region: city.region,
        countryCode: city.countryCode,
        lat: city.lat,
        lng: city.lng,
        tzId: tzId,
      ),
    );
  }

  void setReminderEnabled({required bool enabled}) =>
      state = state.copyWith(reminderEnabled: enabled);

  void setReminderTime(ReminderTime time) =>
      state = state.copyWith(reminderTime: time);

  void toggleFocus(FocusArea area) => state = state.copyWith(
    focusAreas: toggleFocusArea(state.focusAreas, area),
  );

  /// Moves to the next step; does nothing while the step is incomplete or on
  /// the last step (use [finish]).
  void next() {
    if (!state.canContinue || state.isLastStep) return;
    state = state.copyWith(step: ProfileStep.values[state.step.index + 1]);
  }

  void back() {
    if (state.isFirstStep) return;
    state = state.copyWith(step: ProfileStep.values[state.step.index - 1]);
  }

  /// Saves the profile and the reminder choice, then ends the first-run flow.
  /// Rethrows a failed save (after clearing `saving`) so the screen can say so.
  Future<void> finish() async {
    if (state.saving || !state.canContinue) return;
    final answers = state;
    state = state.copyWith(saving: true);
    try {
      final reminder = ref.read(reminderControllerProvider.notifier);
      if (answers.reminderEnabled) {
        await reminder.setTime(answers.reminderTime);
        // A refused permission just leaves the reminder off.
        await reminder.enable();
      }
      await ref
          .read(profileControllerProvider.notifier)
          .save(answers.toProfile());
      await ref.read(onboardingCompleteProvider.notifier).complete();
    } on Object {
      state = state.copyWith(saving: false);
      rethrow;
    }
  }
}
