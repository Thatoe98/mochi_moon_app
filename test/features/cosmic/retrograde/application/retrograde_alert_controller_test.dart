import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/retrograde/application/retrograde_alert_providers.dart';
import 'package:mochi_moon/features/cosmic/retrograde/application/retrograde_providers.dart';
import 'package:mochi_moon/features/cosmic/retrograde/domain/retrograde_alerts.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';

import '../../../settings/support/fake_reminder.dart';
import '../support/fake_alerts.dart';
import '../support/periods.dart';

ProviderContainer _container({
  required FakeRetrogradeAlertSettingsRepository repository,
  required FakeRetrogradeAlertScheduler alerts,
  required FakeReminderScheduler permission,
  String lang = 'en',
  RetrogradeCalendarSource source = fakeCalendar,
}) {
  final container = ProviderContainer(
    overrides: [
      retrogradeAlertSettingsRepositoryProvider.overrideWithValue(repository),
      retrogradeAlertSchedulerProvider.overrideWithValue(alerts),
      reminderSchedulerProvider.overrideWithValue(permission),
      reminderLanguageProvider.overrideWithValue(lang),
      clockProvider.overrideWithValue(() => DateTime(2026, 10, 29, 12)),
      retrogradeCalendarSourceProvider.overrideWithValue(source),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  late FakeRetrogradeAlertSettingsRepository repository;
  late FakeRetrogradeAlertScheduler alerts;
  late FakeReminderScheduler permission;

  setUp(() {
    repository = FakeRetrogradeAlertSettingsRepository();
    alerts = FakeRetrogradeAlertScheduler();
    permission = FakeReminderScheduler();
  });

  ProviderContainer container0({
    String lang = 'en',
    RetrogradeCalendarSource source = fakeCalendar,
  }) => _container(
    repository: repository,
    alerts: alerts,
    permission: permission,
    lang: lang,
    source: source,
  );

  test('Mercury is on by default', () async {
    final container = container0();

    expect(await container.read(retrogradeAlertControllerProvider.future), {
      Body.mercury,
    });
  });

  test('resync schedules Mercury once notifications are allowed', () async {
    permission.granted = true;
    final container = container0();

    await container.read(retrogradeAlertControllerProvider.notifier).resync();

    expect(alerts.scheduled, hasLength(2));
    expect(alerts.scheduled!.every((a) => a.body == Body.mercury), isTrue);
    expect(permission.permissionRequests, 0);
  });

  test('resync cancels when notifications are not allowed', () async {
    final container = container0();

    await container.read(retrogradeAlertControllerProvider.notifier).resync();

    expect(alerts.scheduled, isNull);
    expect(alerts.cancels, 1);
  });

  test('turning Venus on asks permission, saves and schedules', () async {
    final container = container0();
    final controller = container.read(
      retrogradeAlertControllerProvider.notifier,
    );
    await container.read(retrogradeAlertControllerProvider.future);

    final ok = await controller.setEnabled(Body.venus, on: true);

    expect(ok, isTrue);
    expect(permission.permissionRequests, 1);
    expect(repository.saved, {Body.mercury, Body.venus});
    expect(alerts.scheduled!.map((a) => a.body).toSet(), {
      Body.mercury,
      Body.venus,
    });
  });

  test('a refused permission leaves the choice unchanged', () async {
    permission.allowed = false;
    final container = container0();
    final controller = container.read(
      retrogradeAlertControllerProvider.notifier,
    );
    await container.read(retrogradeAlertControllerProvider.future);

    final ok = await controller.setEnabled(Body.venus, on: true);

    expect(ok, isFalse);
    expect(repository.saved, isNull);
    expect(alerts.scheduled, isNull);
  });

  test('turning the last planet off cancels every alert', () async {
    permission.granted = true;
    final container = container0();
    final controller = container.read(
      retrogradeAlertControllerProvider.notifier,
    );
    await container.read(retrogradeAlertControllerProvider.future);

    await controller.setEnabled(Body.mercury, on: false);

    expect(repository.saved, isEmpty);
    expect(alerts.scheduled, isNull);
    expect(alerts.cancels, 1);
    expect(permission.permissionRequests, 0);
  });

  test('writes the notification text in the app language', () async {
    permission.granted = true;
    final container = container0();

    await container.read(retrogradeAlertControllerProvider.notifier).resync();

    final texts = alerts.texts!;
    expect(texts.title, 'Cosmic heads-up 🌙');
    expect(
      texts.messages(Body.mercury, RetrogradeAlertKind.endsTomorrow),
      'Mercury turns direct tomorrow. Things start to flow forward again.',
    );
  });

  test('uses Burmese text when the app is in Burmese', () async {
    permission.granted = true;
    final container = container0(lang: 'my');

    await container.read(retrogradeAlertControllerProvider.notifier).resync();

    final message = alerts.texts!.messages(
      Body.mercury,
      RetrogradeAlertKind.startsToday,
    );
    expect(message, isNot(contains('{planet}')));
    expect(message, isNot(contains('Mercury')));
  });

  test('the sync provider survives a calendar failure', () async {
    permission.granted = true;
    final container = container0(
      source: (year) => Future.error(StateError('scan failed')),
    );

    await expectLater(
      container.read(retrogradeAlertSyncProvider.future),
      completes,
    );
    expect(alerts.scheduled, isNull);
  });
}
