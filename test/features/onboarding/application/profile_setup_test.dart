import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/auth/domain/auth_repository.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/onboarding/application/onboarding_providers.dart';
import 'package:mochi_moon/features/onboarding/application/profile_setup.dart';
import 'package:mochi_moon/features/onboarding/domain/profile_setup_state.dart';
import 'package:mochi_moon/features/places/domain/city.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/profile/domain/birth_place.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';
import 'package:mochi_moon/features/settings/domain/reminder.dart';

import '../../auth/support/fake_auth_repository.dart';
import '../../profile/support/fake_profile.dart';
import '../../settings/support/fake_reminder.dart';
import '../support/fake_onboarding_repository.dart';

const _bangkok = City(
  name: 'Bangkok',
  asciiName: 'Bangkok',
  region: 'Bangkok',
  countryCode: 'TH',
  countryName: 'Thailand',
  lat: 13.7540,
  lng: 100.5014,
  population: 5104476,
);

const _quote = Quote(id: 'q1', text: {'en': 'I am enough.'}, category: 'calm');

class _Setup {
  _Setup({UserProfile? saved, AuthUser? account, bool notifications = true})
    : profiles = FakeProfileRepository(saved),
      reminders = FakeReminderSettingsRepository(),
      scheduler = FakeReminderScheduler(allowed: notifications),
      onboarding = FakeOnboardingRepository() {
    container = ProviderContainer(
      overrides: [
        initialOnboardingCompleteProvider.overrideWithValue(false),
        onboardingRepositoryProvider.overrideWithValue(onboarding),
        profileRepositoryProvider.overrideWithValue(profiles),
        profileRemoteProvider.overrideWithValue(null),
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository(signedIn: account),
        ),
        reminderSettingsRepositoryProvider.overrideWithValue(reminders),
        reminderSchedulerProvider.overrideWithValue(scheduler),
        reminderLanguageProvider.overrideWithValue('en'),
        clockProvider.overrideWithValue(() => DateTime(2026, 10, 28, 12)),
        quotesProvider.overrideWith((ref) async => [_quote]),
      ],
    );
    addTearDown(container.dispose);
    // The notifier is auto-dispose; keep it for the whole test.
    container.listen(profileSetupProvider, (_, _) {});
  }

  final FakeProfileRepository profiles;
  final FakeReminderSettingsRepository reminders;
  final FakeReminderScheduler scheduler;
  final FakeOnboardingRepository onboarding;
  late final ProviderContainer container;

  ProfileSetup get notifier => container.read(profileSetupProvider.notifier);
  ProfileSetupState get state => container.read(profileSetupProvider);

  /// Answers every step and stops on the last one.
  void answerEverything() {
    notifier
      ..setName(' Mochi ')
      ..next()
      ..toggleFocus(FocusArea.calm)
      ..next();
  }
}

void main() {
  test('starts on the name, filled from the Google account', () async {
    final setup = _Setup(
      account: const AuthUser(uid: 'u', displayName: 'Mochi Moon'),
    );
    await setup.container.read(profileControllerProvider.future);
    setup.container.invalidate(profileSetupProvider);

    expect(setup.state.step, ProfileStep.name);
    expect(setup.state.name, 'Mochi Moon');
  });

  test('a saved profile wins over the account name', () async {
    final setup = _Setup(
      saved: const UserProfile(displayName: 'Mo'),
      account: const AuthUser(uid: 'u', displayName: 'Mochi Moon'),
    );
    await setup.container.read(profileControllerProvider.future);
    setup.container.invalidate(profileSetupProvider);

    expect(setup.state.name, 'Mo');
  });

  test('steps run name, focus areas, reminder', () {
    expect(ProfileStep.values, [
      ProfileStep.name,
      ProfileStep.focus,
      ProfileStep.reminder,
    ]);
  });

  test('will not leave the name step empty', () {
    final setup = _Setup();

    setup.notifier.next();
    expect(setup.state.step, ProfileStep.name);

    setup.notifier
      ..setName('   ')
      ..next();
    expect(setup.state.step, ProfileStep.name);

    setup.notifier
      ..setName('Mochi')
      ..next();
    expect(setup.state.step, ProfileStep.focus);
    expect(setup.state.canContinue, isTrue);
  });

  test('going back keeps every answer', () {
    final setup = _Setup();
    setup.notifier
      ..setName('Mochi')
      ..next()
      ..toggleFocus(FocusArea.calm)
      ..next()
      ..back()
      ..back();

    expect(setup.state.step, ProfileStep.name);
    expect(setup.state.name, 'Mochi');
    expect(setup.state.focusAreas, [FocusArea.calm]);

    setup.notifier.back();
    expect(setup.state.step, ProfileStep.name);
  });

  test('"I dont know" clears the birth time', () {
    final setup = _Setup();
    setup.notifier
      ..setBirthMinutes(450)
      ..setBirthMinutes(null);

    expect(setup.state.birthMinutes, isNull);
    expect(setup.state.toProfile().timeKnown, isFalse);
  });

  test('a picked city is stored with its time zone', () {
    final setup = _Setup();

    setup.notifier.setBirthCity(_bangkok);

    expect(
      setup.state.toProfile().birthPlace,
      const BirthPlace(
        name: 'Bangkok',
        region: 'Bangkok',
        countryCode: 'TH',
        lat: 13.7540,
        lng: 100.5014,
        tzId: 'Asia/Bangkok',
      ),
    );

    setup.notifier.setBirthCity(null);
    expect(setup.state.birthPlace, isNull);
  });

  test('finishing keeps birth data an existing profile already has', () async {
    final setup = _Setup(
      saved: UserProfile(displayName: 'Mo', birthDate: DateTime(1998, 2, 4)),
    );
    await setup.container.read(profileControllerProvider.future);
    setup.container.invalidate(profileSetupProvider);
    setup.notifier.setName('Mochi');

    await setup.notifier.finish();

    expect(setup.profiles.profile?.displayName, 'Mochi');
    expect(setup.profiles.profile?.birthDate, DateTime(1998, 2, 4));
  });

  test('a saved birthplace is kept when the flow starts again', () async {
    const place = BirthPlace(
      name: 'Yangon',
      region: 'Yangon',
      countryCode: 'MM',
      lat: 16.8053,
      lng: 96.1561,
      tzId: 'Asia/Yangon',
    );
    final setup = _Setup(
      saved: const UserProfile(displayName: 'Mo', birthPlace: place),
    );
    await setup.container.read(profileControllerProvider.future);
    setup.container.invalidate(profileSetupProvider);

    expect(setup.state.birthPlace, place);
  });

  test('picks at most three focus areas', () {
    final setup = _Setup();
    [
      FocusArea.selfLove,
      FocusArea.calm,
      FocusArea.healing,
      FocusArea.confidence,
    ].forEach(setup.notifier.toggleFocus);

    expect(setup.state.focusAreas, [
      FocusArea.selfLove,
      FocusArea.calm,
      FocusArea.healing,
    ]);
  });

  test('the reminder starts on at 08:00', () {
    final setup = _Setup();

    expect(setup.state.reminderEnabled, isTrue);
    expect(setup.state.reminderTime, ReminderTime.defaultTime);
  });

  test(
    'finish saves the profile, turns the reminder on and ends the flow',
    () async {
      final setup = _Setup()..answerEverything();
      setup.notifier.setReminderTime(const ReminderTime(9, 30));
      expect(setup.state.step, ProfileStep.reminder);

      await setup.notifier.finish();

      expect(
        setup.profiles.profile,
        const UserProfile(displayName: 'Mochi', focusAreas: [FocusArea.calm]),
      );
      expect(setup.reminders.settings.enabled, isTrue);
      expect(setup.reminders.settings.time, const ReminderTime(9, 30));
      expect(setup.onboarding.complete, isTrue);
      expect(setup.container.read(onboardingCompleteProvider), isTrue);
    },
  );

  test(
    'skipping the reminder leaves it off and asks for no permission',
    () async {
      final setup = _Setup()..answerEverything();
      setup.notifier.setReminderEnabled(enabled: false);

      await setup.notifier.finish();

      expect(setup.reminders.settings.enabled, isFalse);
      expect(setup.scheduler.permissionRequests, 0);
      expect(setup.onboarding.complete, isTrue);
    },
  );

  test('a refused notification permission still finishes', () async {
    final setup = _Setup(notifications: false)..answerEverything();

    await setup.notifier.finish();

    expect(setup.reminders.settings.enabled, isFalse);
    expect(setup.profiles.profile?.displayName, 'Mochi');
    expect(setup.onboarding.complete, isTrue);
  });

  test('a failed save keeps the user in the flow and can be retried', () async {
    final setup = _Setup()..answerEverything();
    setup.profiles.saveError = Exception('disk full');

    await expectLater(setup.notifier.finish(), throwsException);

    expect(setup.state.saving, isFalse);
    expect(setup.container.read(onboardingCompleteProvider), isFalse);

    setup.profiles.saveError = null;
    await setup.notifier.finish();
    expect(setup.container.read(onboardingCompleteProvider), isTrue);
  });
}
