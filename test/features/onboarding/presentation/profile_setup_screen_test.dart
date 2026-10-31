import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/auth/domain/auth_repository.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/onboarding/application/onboarding_providers.dart';
import 'package:mochi_moon/features/onboarding/domain/profile_setup_state.dart';
import 'package:mochi_moon/features/onboarding/presentation/profile_setup_screen.dart';
import 'package:mochi_moon/features/places/application/places_providers.dart';
import 'package:mochi_moon/features/places/domain/city.dart';
import 'package:mochi_moon/features/places/domain/city_index.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';

import '../../auth/support/fake_auth_repository.dart';
import '../../profile/support/fake_profile.dart';
import '../../settings/support/fake_reminder.dart';
import '../support/fake_onboarding_repository.dart';

const _cities = [
  City(
    name: 'Bangkok',
    asciiName: 'Bangkok',
    region: 'Bangkok',
    countryCode: 'TH',
    countryName: 'Thailand',
    lat: 13.7540,
    lng: 100.5014,
    population: 5104476,
  ),
  City(
    name: 'Yangon',
    asciiName: 'Yangon',
    region: 'Yangon',
    countryCode: 'MM',
    countryName: 'Myanmar',
    lat: 16.8053,
    lng: 96.1561,
    population: 4477638,
  ),
];

const _account = AuthUser(uid: 'uid_1', displayName: 'Mochi');

class _Harness {
  _Harness({AuthUser? account = _account})
    : profiles = FakeProfileRepository(),
      onboarding = FakeOnboardingRepository(),
      scheduler = FakeReminderScheduler(),
      reminders = FakeReminderSettingsRepository(),
      auth = FakeAuthRepository(signedIn: account);

  final FakeProfileRepository profiles;
  final FakeOnboardingRepository onboarding;
  final FakeReminderScheduler scheduler;
  final FakeReminderSettingsRepository reminders;
  final FakeAuthRepository auth;

  Widget build({double textScale = 1}) => ProviderScope(
    overrides: [
      initialOnboardingCompleteProvider.overrideWithValue(false),
      onboardingRepositoryProvider.overrideWithValue(onboarding),
      authRepositoryProvider.overrideWithValue(auth),
      profileRepositoryProvider.overrideWithValue(profiles),
      profileRemoteProvider.overrideWithValue(null),
      reminderSettingsRepositoryProvider.overrideWithValue(reminders),
      reminderSchedulerProvider.overrideWithValue(scheduler),
      reminderLanguageProvider.overrideWithValue('en'),
      clockProvider.overrideWithValue(() => DateTime(2026, 10, 28, 12)),
      cityIndexProvider.overrideWith((ref) async => CityIndex(_cities)),
      quotesProvider.overrideWith(
        (ref) async => [
          const Quote(id: 'q', text: {'en': 'Soft moon'}, category: 'calm'),
        ],
      ),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: const ProfileSetupScreen(),
    ),
  );
}

Future<void> _tap(WidgetTester tester, String text) async {
  await tester.tap(find.text(text));
  await tester.pumpAndSettle();
}

/// Taps a final reminder choice. The screen is left on a spinner afterwards
/// (the router would take over), so this does not wait for it to settle.
Future<void> _finishWith(WidgetTester tester, String text) async {
  await tester.tap(find.text(text));
  await tester.pump();
  await tester.pump();
}

/// How far along the progress bar is, in steps.
int _progressSteps(WidgetTester tester) =>
    (tester
                .widget<LinearProgressIndicator>(
                  find.byType(LinearProgressIndicator),
                )
                .value! *
            ProfileStep.values.length)
        .round();

FilledButton _mainButton(WidgetTester tester) =>
    tester.widget<FilledButton>(find.byType(FilledButton));

void main() {
  setUp(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first
      ..physicalSize = const Size(1170, 2532)
      ..devicePixelRatio = 3;
  });

  tearDown(() {
    TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
      ..resetPhysicalSize()
      ..resetDevicePixelRatio();
  });

  testWidgets('starts on the name, filled in from the Google account', (
    tester,
  ) async {
    await tester.pumpWidget(_Harness().build());
    await tester.pumpAndSettle();

    expect(find.text('What should we call you?'), findsOneWidget);
    expect(_progressSteps(tester), 1);
    expect(find.widgetWithText(TextField, 'Mochi'), findsOneWidget);
    expect(find.byTooltip('Back'), findsNothing);
  });

  testWidgets('Continue waits for a name', (tester) async {
    await tester.pumpWidget(_Harness(account: null).build());
    await tester.pumpAndSettle();
    expect(_mainButton(tester).onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'Mochi');
    await tester.pump();

    expect(_mainButton(tester).onPressed, isNotNull);
  });

  testWidgets('no birth data is asked: name, focus areas, then reminder', (
    tester,
  ) async {
    await tester.pumpWidget(_Harness().build());
    await tester.pumpAndSettle();
    expect(ProfileStep.values.length, 3);

    await _tap(tester, 'Continue');
    expect(find.text('What would you like more of?'), findsOneWidget);
    expect(_progressSteps(tester), 2);

    await _tap(tester, 'Continue');
    expect(find.text('A daily nudge?'), findsOneWidget);
    expect(_progressSteps(tester), 3);
    expect(find.text('When is your birthday?'), findsNothing);
  });

  testWidgets('back keeps every answer', (tester) async {
    await tester.pumpWidget(_Harness().build());
    await tester.pumpAndSettle();
    await _tap(tester, 'Continue');
    await _tap(tester, 'Calm');
    await _tap(tester, 'Continue');
    expect(_progressSteps(tester), 3);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('What would you like more of?'), findsOneWidget);
    expect(
      tester
          .widget<FilterChip>(find.widgetWithText(FilterChip, 'Calm'))
          .selected,
      isTrue,
    );

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('What should we call you?'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Mochi'), findsOneWidget);
    expect(find.byTooltip('Back'), findsNothing);
  });

  testWidgets('the system back button steps back too', (tester) async {
    await tester.pumpWidget(_Harness().build());
    await tester.pumpAndSettle();
    await _tap(tester, 'Continue');
    expect(find.text('What would you like more of?'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('What should we call you?'), findsOneWidget);
  });

  testWidgets('at most three focus areas can be picked', (tester) async {
    await tester.pumpWidget(_Harness().build());
    await tester.pumpAndSettle();
    await _tap(tester, 'Continue');

    for (final label in ['Self-love', 'Calm', 'Healing']) {
      await _tap(tester, label);
    }

    FilterChip chip(String label) =>
        tester.widget<FilterChip>(find.widgetWithText(FilterChip, label));
    expect(chip('Confidence').onSelected, isNull);
    expect(chip('Healing').onSelected, isNotNull, reason: 'can be un-picked');

    await _tap(tester, 'Healing');
    expect(chip('Confidence').onSelected, isNotNull);
  });

  testWidgets('the reminder choice finishes and saves the profile', (
    tester,
  ) async {
    final harness = _Harness();
    await tester.pumpWidget(harness.build());
    await tester.pumpAndSettle();
    await _tap(tester, 'Continue');
    await _tap(tester, 'Calm');
    await _tap(tester, 'Continue');

    expect(find.text('Remind me at 8:00 AM'), findsOneWidget);
    await _finishWith(tester, 'Remind me');

    expect(
      harness.profiles.profile,
      const UserProfile(displayName: 'Mochi', focusAreas: [FocusArea.calm]),
    );
    expect(harness.profiles.profile?.birthDate, isNull);
    expect(harness.reminders.settings.enabled, isTrue);
    expect(harness.onboarding.complete, isTrue);
  });

  testWidgets('skipping the reminder asks for no permission', (tester) async {
    final harness = _Harness();
    await tester.pumpWidget(harness.build());
    await tester.pumpAndSettle();
    await _tap(tester, 'Continue');
    await _tap(tester, 'Continue');
    await _finishWith(tester, 'Skip for now');

    expect(harness.reminders.settings.enabled, isFalse);
    expect(harness.scheduler.permissionRequests, 0);
    expect(harness.onboarding.complete, isTrue);
  });

  testWidgets('a failed save says so and can be retried', (tester) async {
    final harness = _Harness();
    harness.profiles.saveError = Exception('disk full');
    await tester.pumpWidget(harness.build());
    await tester.pumpAndSettle();
    await _tap(tester, 'Continue');
    await _tap(tester, 'Continue');

    await _finishWith(tester, 'Skip for now');

    expect(find.text("Couldn't save that. Please try again."), findsOneWidget);
    expect(harness.onboarding.complete, isFalse);

    // Let the snack bar go; it covers the buttons.
    ScaffoldMessenger.of(tester.element(find.byType(Scaffold)))
        .hideCurrentSnackBar();
    await tester.pumpAndSettle();
    harness.profiles.saveError = null;
    await _finishWith(tester, 'Skip for now');
    expect(harness.onboarding.complete, isTrue);
  });

  testWidgets('every step fits at 1.3x text scale', (tester) async {
    await tester.pumpWidget(_Harness().build(textScale: 1.3));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await _tap(tester, 'Continue');
    expect(tester.takeException(), isNull);
    await _tap(tester, 'Continue');
    expect(tester.takeException(), isNull);
    expect(find.text('A daily nudge?'), findsOneWidget);
  });
}
