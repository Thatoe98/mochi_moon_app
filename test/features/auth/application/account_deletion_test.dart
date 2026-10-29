import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/auth/application/account_deletion_providers.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/auth/domain/auth_repository.dart';
import 'package:mochi_moon/features/cosmic/retrograde/application/retrograde_alert_providers.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';

import '../../cosmic/retrograde/support/fake_alerts.dart';
import '../../settings/support/fake_reminder.dart';
import '../support/fake_account.dart';
import '../support/fake_auth_repository.dart';

void main() {
  late FakeAuthRepository auth;
  late FakeAccountRemote remote;
  late FakeLocalDataEraser eraser;
  late FakeReminderScheduler reminders;
  late FakeRetrogradeAlertScheduler alerts;

  setUp(() {
    auth = FakeAuthRepository(
      signedIn: const AuthUser(uid: 'uid_1', displayName: 'Mochi'),
    );
    remote = FakeAccountRemote();
    eraser = FakeLocalDataEraser();
    reminders = FakeReminderScheduler();
    alerts = FakeRetrogradeAlertScheduler();
  });

  ProviderContainer container() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        accountRemoteProvider.overrideWithValue(remote),
        localDataEraserProvider.overrideWithValue(eraser),
        reminderSchedulerProvider.overrideWithValue(reminders),
        retrogradeAlertSchedulerProvider.overrideWithValue(alerts),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Future<AccountDeletionOutcome> delete(ProviderContainer c) =>
      c.read(accountDeletionProvider.notifier).delete();

  test('signed in: erases the cloud data, the user, then the phone', () async {
    final outcome = await delete(container());

    expect(outcome, AccountDeletionOutcome.deleted);
    expect(remote.deleted, ['uid_1']);
    expect(auth.deleteCalls, 1);
    expect(auth.currentUser, isNull);
    expect(eraser.erased, 1);
    expect(reminders.cancels, 1);
    expect(alerts.cancels, 1);
  });

  test('signed out: only wipes the phone', () async {
    auth = FakeAuthRepository();

    final outcome = await delete(container());

    expect(outcome, AccountDeletionOutcome.deleted);
    expect(remote.deleted, isEmpty);
    expect(auth.deleteCalls, 0);
    expect(eraser.erased, 1);
  });

  test('offline: keeps everything and says so', () async {
    remote.error = const NetworkFailure();

    final outcome = await delete(container());

    expect(outcome, AccountDeletionOutcome.offline);
    expect(auth.deleteCalls, 0);
    expect(eraser.erased, 0);
    expect(reminders.cancels, 0);
  });

  test('backing out of the Google confirmation keeps the local data', () async {
    auth.deleteError = const CancelledFailure();

    final outcome = await delete(container());

    expect(outcome, AccountDeletionOutcome.cancelled);
    expect(eraser.erased, 0);
  });

  test('any other failure is reported and the phone is left alone', () async {
    auth.deleteError = const UnknownFailure('boom');

    final outcome = await delete(container());

    expect(outcome, AccountDeletionOutcome.failed);
    expect(eraser.erased, 0);
  });

  test('a notification error does not stop the deletion', () async {
    final c = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        accountRemoteProvider.overrideWithValue(remote),
        localDataEraserProvider.overrideWithValue(eraser),
        reminderSchedulerProvider.overrideWithValue(_ThrowingScheduler()),
        retrogradeAlertSchedulerProvider.overrideWithValue(alerts),
      ],
    );
    addTearDown(c.dispose);

    expect(await delete(c), AccountDeletionOutcome.deleted);
    expect(eraser.erased, 1);
  });

  test('can be tried again after a failure', () async {
    final c = container();
    remote.error = const NetworkFailure();
    expect(await delete(c), AccountDeletionOutcome.offline);

    remote.error = null;
    expect(await delete(c), AccountDeletionOutcome.deleted);
    expect(c.read(accountDeletionProvider), isFalse);
  });
}

class _ThrowingScheduler extends FakeReminderScheduler {
  @override
  Future<void> cancelAll() => Future.error(StateError('no notifications'));
}
