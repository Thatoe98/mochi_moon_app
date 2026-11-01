import 'dart:async';

import 'package:mochi_moon/core/analytics/analytics_event.dart';
import 'package:mochi_moon/core/analytics/analytics_providers.dart';
import 'package:mochi_moon/features/cosmic/unlock/domain/unlock_state.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/places/application/places_providers.dart';
import 'package:mochi_moon/features/places/domain/city.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/profile/domain/birth_place.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cosmic_unlock.g.dart';

/// The "Unlock your cosmic side" flow (PRD §6.1): birth date, birth time,
/// birthplace. Saving puts them on the profile; nothing is saved before that,
/// so leaving mid-flow keeps Cosmic locked.
@riverpod
class CosmicUnlock extends _$CosmicUnlock {
  @override
  UnlockState build() {
    final saved = ref.read(profileControllerProvider).value;
    return UnlockState(
      birthDate: saved?.birthDate,
      birthMinutes: saved?.birthMinutes,
      birthPlace: saved?.birthPlace,
    );
  }

  DateTime get _today => ref.read(clockProvider)();

  void setBirthDate(DateTime date) => state = state.copyWith(
    birthDate: DateTime(date.year, date.month, date.day),
  );

  /// Pass null for "I don't know".
  void setBirthMinutes(int? minutes) => state = minutes == null
      ? state.copyWith(clearBirthMinutes: true)
      : state.copyWith(birthMinutes: minutes);

  /// Picks [city] as the birthplace and looks up its time zone; null clears.
  void setBirthCity(City? city) {
    if (city == null) {
      state = state.copyWith(clearBirthPlace: true);
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

  void next() {
    if (!state.canContinue(_today) || state.isLastStep) return;
    state = state.copyWith(step: UnlockStep.values[state.step.index + 1]);
  }

  void back() {
    if (state.isFirstStep) return;
    state = state.copyWith(step: UnlockStep.values[state.step.index - 1]);
  }

  /// Saves the birth data on the profile. Rethrows a failed save (after
  /// clearing `saving`) so the screen can say so.
  Future<void> finish() async {
    if (state.saving || !state.canContinue(_today)) return;
    final answers = state;
    state = state.copyWith(saving: true);
    try {
      final profile =
          await ref.read(profileControllerProvider.future) ??
          const UserProfile();
      await ref
          .read(profileControllerProvider.notifier)
          .save(
            profile.copyWith(
              birthDate: answers.birthDate,
              birthMinutes: answers.birthMinutes,
              birthPlace: answers.birthPlace,
            ),
          );
      unawaited(
        ref.read(analyticsLoggerProvider).log(AnalyticsEvent.cosmicUnlocked),
      );
    } on Object {
      state = state.copyWith(saving: false);
      rethrow;
    }
  }
}
