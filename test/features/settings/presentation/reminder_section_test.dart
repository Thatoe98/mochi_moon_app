import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';
import 'package:mochi_moon/features/settings/domain/reminder.dart';
import 'package:mochi_moon/features/settings/presentation/reminder_section.dart';

import '../support/fake_reminder.dart';

const _quote = Quote(
  id: 'q1',
  text: {'en': 'I am enough.'},
  category: 'self_love',
);

Widget _host(
  FakeReminderSettingsRepository repository,
  FakeReminderScheduler scheduler,
) => ProviderScope(
  overrides: [
    reminderSettingsRepositoryProvider.overrideWithValue(repository),
    reminderSchedulerProvider.overrideWithValue(scheduler),
    reminderLanguageProvider.overrideWithValue('en'),
    quotesProvider.overrideWith((ref) => Future.value([_quote])),
  ],
  child: const MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: ReminderSection()),
  ),
);

Switch _switch(WidgetTester tester) =>
    tester.widget<Switch>(find.byType(Switch));

void main() {
  late FakeReminderSettingsRepository repository;
  late FakeReminderScheduler scheduler;

  setUp(() {
    repository = FakeReminderSettingsRepository();
    scheduler = FakeReminderScheduler();
  });

  testWidgets('is off by default and hides the time row', (tester) async {
    await tester.pumpWidget(_host(repository, scheduler));
    await tester.pumpAndSettle();

    expect(find.text('Daily reminder'), findsOneWidget);
    expect(_switch(tester).value, isFalse);
    expect(find.text('Reminder time'), findsNothing);
  });

  testWidgets('explains why before asking, then turns on', (tester) async {
    await tester.pumpWidget(_host(repository, scheduler));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    // The pre-prompt comes first; the system has not been asked yet.
    expect(find.text('A gentle daily nudge?'), findsOneWidget);
    expect(scheduler.permissionRequests, 0);

    await tester.tap(find.text('Sounds good'));
    await tester.pumpAndSettle();

    expect(scheduler.permissionRequests, 1);
    expect(_switch(tester).value, isTrue);
    expect(find.text('Reminder time'), findsOneWidget);
    expect(find.text('8:00 AM'), findsOneWidget);
    expect(scheduler.scheduled, isNotEmpty);
  });

  testWidgets('Not now never asks the system', (tester) async {
    await tester.pumpWidget(_host(repository, scheduler));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();

    expect(scheduler.permissionRequests, 0);
    expect(_switch(tester).value, isFalse);
  });

  testWidgets('shows a hint when permission is refused', (tester) async {
    scheduler = FakeReminderScheduler(allowed: false);
    await tester.pumpWidget(_host(repository, scheduler));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sounds good'));
    await tester.pumpAndSettle();

    expect(_switch(tester).value, isFalse);
    expect(find.textContaining('turn them on in your phone'), findsOneWidget);
  });

  testWidgets('turning it off cancels the reminders', (tester) async {
    repository = FakeReminderSettingsRepository(
      const ReminderSettings(enabled: true),
    );
    scheduler.granted = true;
    await tester.pumpWidget(_host(repository, scheduler));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(_switch(tester).value, isFalse);
    expect(repository.settings.enabled, isFalse);
    expect(find.text('Reminder time'), findsNothing);
  });

  testWidgets('picking a time saves it', (tester) async {
    repository = FakeReminderSettingsRepository(
      const ReminderSettings(enabled: true),
    );
    scheduler.granted = true;
    await tester.pumpWidget(_host(repository, scheduler));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Reminder time'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.keyboard_outlined));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), '9');
    await tester.enterText(find.byType(TextField).at(1), '45');
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(repository.settings.time, const ReminderTime(9, 45));
    expect(scheduler.scheduled.first.fireAt.hour, 9);
    expect(find.text('9:45 AM'), findsOneWidget);
  });
}
