import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/auth/domain/auth_repository.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';
import 'package:mochi_moon/features/settings/domain/reminder.dart';

import '../../auth/support/fake_auth_repository.dart';
import '../../settings/support/fake_reminder.dart';
import '../support/fake_profile.dart';

const _uid = 'uid_1';
const _signedIn = AuthUser(uid: _uid);

final _complete = UserProfile(
  displayName: 'Mochi',
  birthDate: DateTime(1998, 2, 4),
  focusAreas: const [FocusArea.calm],
);

ProviderContainer _container({
  required FakeProfileRepository local,
  FakeProfileRemote? remote,
  AuthUser? signedIn,
  ReminderSettings reminder = const ReminderSettings(),
}) {
  final container = ProviderContainer(
    overrides: [
      profileRepositoryProvider.overrideWithValue(local),
      profileRemoteProvider.overrideWithValue(remote),
      authRepositoryProvider.overrideWithValue(
        FakeAuthRepository(signedIn: signedIn),
      ),
      reminderSettingsRepositoryProvider.overrideWithValue(
        FakeReminderSettingsRepository(reminder),
      ),
      reminderSchedulerProvider.overrideWithValue(FakeReminderScheduler()),
      reminderLanguageProvider.overrideWithValue('my'),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('save', () {
    test('keeps the profile on the device when signed out', () async {
      final local = FakeProfileRepository();
      final remote = FakeProfileRemote();
      final container = _container(local: local, remote: remote);
      await container.read(profileControllerProvider.future);

      await container.read(profileControllerProvider.notifier).save(_complete);

      expect(local.profile, _complete);
      expect(container.read(profileControllerProvider).value, _complete);
      expect(remote.upserts, isEmpty);
    });

    test(
      'also uploads it with the language and reminder when signed in',
      () async {
        final remote = FakeProfileRemote();
        final container = _container(
          local: FakeProfileRepository(),
          remote: remote,
          signedIn: _signedIn,
          reminder: const ReminderSettings(
            enabled: true,
            time: ReminderTime(8, 5),
          ),
        );
        await container.read(reminderControllerProvider.future);
        await container.read(profileControllerProvider.future);

        await container
            .read(profileControllerProvider.notifier)
            .save(_complete);

        final upsert = remote.upserts.single;
        expect(upsert.uid, _uid);
        expect(upsert.profile, _complete);
        expect(upsert.locale, 'my');
        expect(upsert.reminderTime, '08:05');
      },
    );

    test('sends no reminder time while the reminder is off', () async {
      final remote = FakeProfileRemote();
      final container = _container(
        local: FakeProfileRepository(),
        remote: remote,
        signedIn: _signedIn,
      );
      await container.read(reminderControllerProvider.future);
      await container.read(profileControllerProvider.future);

      await container.read(profileControllerProvider.notifier).save(_complete);

      expect(remote.upserts.single.reminderTime, isNull);
    });

    test('a failed upload does not fail the save', () async {
      final local = FakeProfileRepository();
      final remote = FakeProfileRemote()..error = const NetworkFailure();
      final container = _container(
        local: local,
        remote: remote,
        signedIn: _signedIn,
      );
      await container.read(profileControllerProvider.future);

      await container.read(profileControllerProvider.notifier).save(_complete);

      expect(local.profile, _complete);
    });

    test('works without Firebase', () async {
      final local = FakeProfileRepository();
      final container = _container(local: local, signedIn: _signedIn);
      await container.read(profileControllerProvider.future);

      await container.read(profileControllerProvider.notifier).save(_complete);

      expect(local.profile, _complete);
    });
  });

  group('reconcile', () {
    test('uploads a complete local profile', () async {
      final remote = FakeProfileRemote();
      final container = _container(
        local: FakeProfileRepository(_complete),
        remote: remote,
      );

      final result = await container
          .read(profileControllerProvider.notifier)
          .reconcile(_uid);

      expect(result, _complete);
      expect(remote.stored[_uid], _complete);
    });

    test(
      'takes a complete profile from Firestore when there is none here',
      () async {
        final local = FakeProfileRepository();
        final remote = FakeProfileRemote({_uid: _complete});
        final container = _container(local: local, remote: remote);

        final result = await container
            .read(profileControllerProvider.notifier)
            .reconcile(_uid);

        expect(result, _complete);
        expect(local.profile, _complete);
        expect(container.read(profileControllerProvider).value, _complete);
        expect(remote.upserts, isEmpty);
      },
    );

    test(
      'a name-only local profile takes the birth data the account holds',
      () async {
        final local = FakeProfileRepository(
          const UserProfile(displayName: 'Mo'),
        );
        final remote = FakeProfileRemote({_uid: _complete});
        final container = _container(local: local, remote: remote);

        final result = await container
            .read(profileControllerProvider.notifier)
            .reconcile(_uid);

        final expected = _complete.copyWith(
          displayName: 'Mo',
          focusAreas: const [],
        );
        expect(result, expected);
        expect(local.profile, expected);
        expect(remote.stored[_uid], expected);
      },
    );

    test('a name-only profile is uploaded when the account has none', () async {
      const nameOnly = UserProfile(displayName: 'Mo');
      final remote = FakeProfileRemote();
      final container = _container(
        local: FakeProfileRepository(nameOnly),
        remote: remote,
      );

      final result = await container
          .read(profileControllerProvider.notifier)
          .reconcile(_uid);

      expect(result, nameOnly);
      expect(remote.stored[_uid], nameOnly);
    });

    test(
      'a nameless local profile does not overwrite the remote one',
      () async {
        final local = FakeProfileRepository(const UserProfile());
        final remote = FakeProfileRemote({_uid: _complete});
        final container = _container(local: local, remote: remote);

        await container
            .read(profileControllerProvider.notifier)
            .reconcile(_uid);

        expect(local.profile, _complete);
        expect(remote.upserts, isEmpty);
      },
    );

    test('with nothing anywhere it returns null', () async {
      final container = _container(
        local: FakeProfileRepository(),
        remote: FakeProfileRemote(),
      );

      final result = await container
          .read(profileControllerProvider.notifier)
          .reconcile(_uid);

      expect(result, isNull);
    });

    test('keeps what it has when Firestore cannot be reached', () async {
      const unfinished = UserProfile(displayName: 'Mo');
      final remote = FakeProfileRemote()..error = const NetworkFailure();
      final container = _container(
        local: FakeProfileRepository(unfinished),
        remote: remote,
      );

      final result = await container
          .read(profileControllerProvider.notifier)
          .reconcile(_uid);

      expect(result, unfinished);
    });
  });

  group('profileSync', () {
    test('uploads the local profile once an account is signed in', () async {
      final remote = FakeProfileRemote();
      final container = _container(
        local: FakeProfileRepository(_complete),
        remote: remote,
        signedIn: _signedIn,
      )..listen(profileSyncProvider, (_, _) {}); // else Riverpod pauses it

      await container.read(profileSyncProvider.future);

      expect(remote.stored[_uid], _complete);
    });

    test('does nothing while signed out', () async {
      final local = FakeProfileRepository();
      final container = _container(
        local: local,
        remote: FakeProfileRemote({_uid: _complete}),
      )..listen(profileSyncProvider, (_, _) {});

      await container.read(profileSyncProvider.future);

      expect(local.profile, isNull);
    });
  });
}
