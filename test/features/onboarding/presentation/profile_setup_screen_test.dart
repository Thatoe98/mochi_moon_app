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
import 'package:mochi_moon/features/onboarding/presentation/profile_setup_screen.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';

import '../../auth/support/fake_auth_repository.dart';
import '../../profile/support/fake_profile.dart';
import '../../settings/support/fake_reminder.dart';
import '../support/fake_onboarding_repository.dart';

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

/// Taps the last step's button. The screen is left on a spinner afterwards
/// (the router would take over), so this does not wait for it to settle.
Future<void> _finish(WidgetTester tester) async {
  await tester.tap(find.text("Let's go"));
  await tester.pump();
  await tester.pump();
}

Future<void> _pickBirthday(WidgetTester tester) async {
  await _tap(tester, '1998');
  await _tap(tester, '15');
}

/// Moves from the name step to the birth time step.
Future<void> _toBirthTime(WidgetTester tester) async {
  await _tap(tester, 'Continue');
  await _pickBirthday(tester);
  await _tap(tester, 'Continue');
}

/// How far along the progress bar is, in steps.
int _progressSteps(WidgetTester tester) =>
    (tester
                .widget<LinearProgressIndicator>(
                  find.byType(LinearProgressIndicator),
                )
                .value! *
            5)
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

  testWidgets('Continue waits for a birth date', (tester) async {
    await tester.pumpWidget(_Harness().build());
    await tester.pumpAndSettle();
    await _tap(tester, 'Continue');

    expect(find.text('When is your birthday?'), findsOneWidget);
    expect(_mainButton(tester).onPressed, isNull);

    await _pickBirthday(tester);

    expect(_mainButton(tester).onPressed, isNotNull);
    expect(find.textContaining('Born '), findsOneWidget);
  });

  testWidgets('a birth time can be chosen and then dropped', (tester) async {
    await tester.pumpWidget(_Harness().build());
    await tester.pumpAndSettle();
    await _toBirthTime(tester);

    expect(find.text("No birth time. That's okay."), findsOneWidget);
    expect(
      tester
          .widget<TextButton>(find.widgetWithText(TextButton, "I don't know"))
          .onPressed,
      isNull,
    );

    await _tap(tester, 'Choose a time');
    await _tap(tester, 'OK');
    expect(find.textContaining('Born at'), findsOneWidget);

    await _tap(tester, "I don't know");
    expect(find.text("No birth time. That's okay."), findsOneWidget);
  });

  testWidgets('back keeps every answer', (tester) async {
    await tester.pumpWidget(_Harness().build());
    await tester.pumpAndSettle();
    await _toBirthTime(tester);
    expect(_progressSteps(tester), 3);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('When is your birthday?'), findsOneWidget);
    expect(find.textContaining('Born '), findsOneWidget);

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
    expect(find.text('When is your birthday?'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('What should we call you?'), findsOneWidget);
  });

  testWidgets('at most three focus areas can be picked', (tester) async {
    await tester.pumpWidget(_Harness().build());
    await tester.pumpAndSettle();
    await _toBirthTime(tester);
    await _tap(tester, 'Continue');
    await _tap(tester, 'Skip for now');
    expect(find.text('What would you like more of?'), findsOneWidget);

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

  testWidgets('finishing saves the profile and the reminder', (tester) async {
    final harness = _Harness();
    await tester.pumpWidget(harness.build());
    await tester.pumpAndSettle();
    await _toBirthTime(tester);
    await _tap(tester, 'Continue');

    expect(find.text('A daily nudge?'), findsOneWidget);
    expect(find.text('Remind me at 8:00 AM'), findsOneWidget);
    await _tap(tester, 'Remind me');
    await _tap(tester, 'Calm');
    await _finish(tester);

    expect(
      harness.profiles.profile,
      UserProfile(
        displayName: 'Mochi',
        birthDate: DateTime(1998, 1, 15),
        focusAreas: const [FocusArea.calm],
      ),
    );
    expect(harness.reminders.settings.enabled, isTrue);
    expect(harness.onboarding.complete, isTrue);
  });

  testWidgets('skipping the reminder asks for no permission', (tester) async {
    final harness = _Harness();
    await tester.pumpWidget(harness.build());
    await tester.pumpAndSettle();
    await _toBirthTime(tester);
    await _tap(tester, 'Continue');
    await _tap(tester, 'Skip for now');
    await _finish(tester);

    expect(harness.reminders.settings.enabled, isFalse);
    expect(harness.scheduler.permissionRequests, 0);
    expect(harness.onboarding.complete, isTrue);
  });

  testWidgets('a failed save says so and can be retried', (tester) async {
    final harness = _Harness();
    harness.profiles.saveError = Exception('disk full');
    await tester.pumpWidget(harness.build());
    await tester.pumpAndSettle();
    await _toBirthTime(tester);
    await _tap(tester, 'Continue');
    await _tap(tester, 'Skip for now');

    await _finish(tester);

    expect(find.text("Couldn't save that. Please try again."), findsOneWidget);
    expect(harness.onboarding.complete, isFalse);
    expect(_mainButton(tester).onPressed, isNotNull);

    // Let the snack bar go; it covers the button.
    ScaffoldMessenger.of(tester.element(find.byType(Scaffold)))
        .hideCurrentSnackBar();
    await tester.pumpAndSettle();
    harness.profiles.saveError = null;
    await _finish(tester);
    expect(harness.onboarding.complete, isTrue);
  });

  testWidgets('every step fits at 1.3x text scale', (tester) async {
    await tester.pumpWidget(_Harness().build(textScale: 1.3));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await _tap(tester, 'Continue');
    expect(tester.takeException(), isNull);
    await _pickBirthday(tester);
    await _tap(tester, 'Continue');
    expect(tester.takeException(), isNull);
    await _tap(tester, 'Continue');
    expect(tester.takeException(), isNull);
    await _tap(tester, 'Skip for now');
    expect(tester.takeException(), isNull);
    expect(find.text('What would you like more of?'), findsOneWidget);
  });
}
