import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';
import 'package:mochi_moon/features/settings/domain/reminder.dart';

import '../support/fake_reminder.dart';

const _quote = Quote(
  id: 'q1',
  text: {'en': 'I am enough.', 'my': 'ငါ လုံလောက်ပါတယ်'},
  category: 'self_love',
);

ProviderContainer _container({
  required FakeReminderSettingsRepository repository,
  required FakeReminderScheduler scheduler,
  String lang = 'en',
}) {
  final container = ProviderContainer(
    overrides: [
      reminderSettingsRepositoryProvider.overrideWithValue(repository),
      reminderSchedulerProvider.overrideWithValue(scheduler),
      reminderLanguageProvider.overrideWithValue(lang),
      clockProvider.overrideWithValue(() => DateTime(2026, 10, 28, 6)),
      quotesProvider.overrideWith((ref) => Future.value([_quote])),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  late FakeReminderSettingsRepository repository;
  late FakeReminderScheduler scheduler;

  setUp(() {
    repository = FakeReminderSettingsRepository();
    scheduler = FakeReminderScheduler();
  });

  test('starts off at 08:00 and schedules nothing', () async {
    final container = _container(repository: repository, scheduler: scheduler);

    final settings = await container.read(reminderControllerProvider.future);
    await container.read(reminderControllerProvider.notifier).resync();

    expect(settings, const ReminderSettings());
    expect(scheduler.scheduled, isEmpty);
    expect(scheduler.permissionRequests, 0);
  });

  test('enabling asks for permission, saves and schedules', () async {
    final container = _container(repository: repository, scheduler: scheduler);
    final controller = container.read(reminderControllerProvider.notifier);
    await container.read(reminderControllerProvider.future);

    final enabled = await controller.enable();

    expect(enabled, isTrue);
    expect(scheduler.permissionRequests, 1);
    expect(repository.settings.enabled, isTrue);
    expect(scheduler.scheduled, hasLength(reminderWindowDays));
    expect(scheduler.scheduled.first.fireAt, DateTime(2026, 10, 28, 8));
    expect(scheduler.scheduled.first.body, 'I am enough.');
    expect(scheduler.texts?.title, 'Your Mochi Moon card ✨');
    expect(container.read(reminderControllerProvider).value?.enabled, isTrue);
  });

  test('a refused permission leaves the reminder off', () async {
    scheduler = FakeReminderScheduler(allowed: false);
    final container = _container(repository: repository, scheduler: scheduler);
    final controller = container.read(reminderControllerProvider.notifier);
    await container.read(reminderControllerProvider.future);

    final enabled = await controller.enable();

    expect(enabled, isFalse);
    expect(repository.settings.enabled, isFalse);
    expect(scheduler.scheduled, isEmpty);
    expect(container.read(reminderControllerProvider).value?.enabled, isFalse);
  });

  test('changing the time reschedules at the new time', () async {
    final container = _container(repository: repository, scheduler: scheduler);
    final controller = container.read(reminderControllerProvider.notifier);
    await container.read(reminderControllerProvider.future);
    await controller.enable();

    await controller.setTime(const ReminderTime(21, 15));

    expect(repository.settings.time, const ReminderTime(21, 15));
    expect(scheduler.scheduled.first.fireAt, DateTime(2026, 10, 28, 21, 15));
  });

  test('disabling cancels what was scheduled', () async {
    final container = _container(repository: repository, scheduler: scheduler);
    final controller = container.read(reminderControllerProvider.notifier);
    await container.read(reminderControllerProvider.future);
    await controller.enable();

    await controller.disable();

    expect(repository.settings.enabled, isFalse);
    expect(scheduler.scheduled, isEmpty);
    expect(scheduler.cancels, 1);
  });

  test('resync refills the window from saved settings', () async {
    repository = FakeReminderSettingsRepository(
      const ReminderSettings(enabled: true, time: ReminderTime(7, 30)),
    );
    scheduler.granted = true;
    final container = _container(repository: repository, scheduler: scheduler);

    await container.read(reminderSyncProvider.future);

    expect(scheduler.scheduled, hasLength(reminderWindowDays));
    expect(scheduler.scheduled.first.fireAt, DateTime(2026, 10, 28, 7, 30));
    expect(scheduler.permissionRequests, 0);
  });

  test('resync schedules nothing if permission was revoked', () async {
    repository = FakeReminderSettingsRepository(
      const ReminderSettings(enabled: true),
    );
    scheduler.granted = false;
    final container = _container(repository: repository, scheduler: scheduler);

    await container.read(reminderSyncProvider.future);

    expect(scheduler.scheduled, isEmpty);
    expect(scheduler.permissionRequests, 0);
  });

  test('notifications follow the Burmese language', () async {
    final container = _container(
      repository: repository,
      scheduler: scheduler,
      lang: 'my',
    );
    final controller = container.read(reminderControllerProvider.notifier);
    await container.read(reminderControllerProvider.future);

    await controller.enable();

    expect(scheduler.scheduled.first.body, 'ငါ လုံလောက်ပါတယ်');
    expect(scheduler.texts?.title, 'Mochi Moon ကတ်လေး ✨');
  });
}
