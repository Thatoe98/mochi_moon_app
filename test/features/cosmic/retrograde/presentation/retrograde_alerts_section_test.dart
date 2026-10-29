import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/retrograde/application/retrograde_alert_providers.dart';
import 'package:mochi_moon/features/cosmic/retrograde/application/retrograde_providers.dart';
import 'package:mochi_moon/features/cosmic/retrograde/presentation/retrograde_alerts_section.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';

import '../../../settings/support/fake_reminder.dart';
import '../support/fake_alerts.dart';
import '../support/periods.dart';

Widget _host(
  FakeRetrogradeAlertSettingsRepository repository,
  FakeRetrogradeAlertScheduler alerts,
  FakeReminderScheduler permission, {
  double textScale = 1,
}) => ProviderScope(
  overrides: [
    retrogradeAlertSettingsRepositoryProvider.overrideWithValue(repository),
    retrogradeAlertSchedulerProvider.overrideWithValue(alerts),
    reminderSchedulerProvider.overrideWithValue(permission),
    reminderLanguageProvider.overrideWithValue('en'),
    clockProvider.overrideWithValue(() => DateTime(2026, 10, 29, 12)),
    retrogradeCalendarSourceProvider.overrideWithValue(fakeCalendar),
  ],
  child: MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(textScale)),
      child: child!,
    ),
    home: const Scaffold(
      body: SingleChildScrollView(child: RetrogradeAlertsSection()),
    ),
  ),
);

Finder _switchFor(String planet) => find.widgetWithText(SwitchListTile, planet);

bool _on(WidgetTester tester, String planet) =>
    tester.widget<SwitchListTile>(_switchFor(planet)).value;

void main() {
  late FakeRetrogradeAlertSettingsRepository repository;
  late FakeRetrogradeAlertScheduler alerts;
  late FakeReminderScheduler permission;

  setUp(() {
    repository = FakeRetrogradeAlertSettingsRepository();
    alerts = FakeRetrogradeAlertScheduler();
    permission = FakeReminderScheduler();
  });

  testWidgets('shows Mercury on and Venus and Mars off', (tester) async {
    await tester.pumpWidget(_host(repository, alerts, permission));
    await tester.pumpAndSettle();

    expect(find.text('Retrograde heads-ups'), findsOneWidget);
    expect(_on(tester, 'Mercury'), isTrue);
    expect(_on(tester, 'Venus'), isFalse);
    expect(_on(tester, 'Mars'), isFalse);
  });

  testWidgets('explains before asking, then turns Venus on', (tester) async {
    await tester.pumpWidget(_host(repository, alerts, permission));
    await tester.pumpAndSettle();

    await tester.tap(_switchFor('Venus'));
    await tester.pumpAndSettle();
    expect(find.text('A soft cosmic heads-up?'), findsOneWidget);
    expect(permission.permissionRequests, 0);

    await tester.tap(find.text('Sounds good'));
    await tester.pumpAndSettle();

    expect(permission.permissionRequests, 1);
    expect(_on(tester, 'Venus'), isTrue);
    expect(repository.saved, contains(Body.venus));
  });

  testWidgets('skips the explanation when notifications are already allowed', (
    tester,
  ) async {
    permission.granted = true;
    await tester.pumpWidget(_host(repository, alerts, permission));
    await tester.pumpAndSettle();

    await tester.tap(_switchFor('Mars'));
    await tester.pumpAndSettle();

    expect(find.text('A soft cosmic heads-up?'), findsNothing);
    expect(_on(tester, 'Mars'), isTrue);
  });

  testWidgets('Not now leaves it off and asks nothing', (tester) async {
    await tester.pumpWidget(_host(repository, alerts, permission));
    await tester.pumpAndSettle();

    await tester.tap(_switchFor('Venus'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();

    expect(permission.permissionRequests, 0);
    expect(_on(tester, 'Venus'), isFalse);
  });

  testWidgets('a refused permission shows the settings hint', (tester) async {
    permission.allowed = false;
    await tester.pumpWidget(_host(repository, alerts, permission));
    await tester.pumpAndSettle();

    await tester.tap(_switchFor('Venus'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sounds good'));
    await tester.pumpAndSettle();

    expect(_on(tester, 'Venus'), isFalse);
    expect(find.textContaining('Notifications are off'), findsOneWidget);
  });

  testWidgets('turning Mercury off saves and keeps it off', (tester) async {
    await tester.pumpWidget(_host(repository, alerts, permission));
    await tester.pumpAndSettle();

    await tester.tap(_switchFor('Mercury'));
    await tester.pumpAndSettle();

    expect(_on(tester, 'Mercury'), isFalse);
    expect(repository.saved, isEmpty);
  });

  testWidgets('survives 1.3x text without overflow', (tester) async {
    await tester.pumpWidget(
      _host(repository, alerts, permission, textScale: 1.3),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
