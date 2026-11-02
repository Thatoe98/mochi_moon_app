import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/auth/domain/auth_repository.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/letters/application/letter_providers.dart';
import 'package:mochi_moon/features/letters/domain/future_letter.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';

import '../../auth/support/fake_auth_repository.dart';
import '../../settings/support/fake_reminder.dart';
import '../support/fake_letter.dart';

final _now = DateTime(2026, 11, 2, 9);

ProviderContainer _container(
  FakeLetterRepository repo, {
  FakeLetterNotifier? notifier,
  FakeLetterRemote? remote,
  FakeReminderScheduler? scheduler,
  bool signedIn = false,
  bool premium = false,
}) {
  final container = ProviderContainer(
    overrides: [
      letterRepositoryProvider.overrideWithValue(repo),
      hasPremiumProvider.overrideWithValue(premium),
      letterRemoteProvider.overrideWithValue(remote),
      letterSchedulerProvider.overrideWithValue(
        notifier ?? FakeLetterNotifier(),
      ),
      reminderSchedulerProvider.overrideWithValue(
        scheduler ?? FakeReminderScheduler(),
      ),
      reminderLanguageProvider.overrideWithValue('en'),
      clockProvider.overrideWithValue(() => _now),
      authRepositoryProvider.overrideWithValue(
        FakeAuthRepository(
          signedIn: signedIn ? const AuthUser(uid: 'u1') : null,
        ),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('free: a second letter is refused while one is sealed', () async {
    final repo = FakeLetterRepository();
    final seal = _container(repo).read(sealLetterActionProvider);

    expect((await seal('one', 30)).rejection, isNull);
    expect((await seal('two', 30)).rejection, LetterRejection.limitReached);
    expect(repo.all, hasLength(1));
  });

  test('free: an opened letter no longer uses the slot', () async {
    final repo = FakeLetterRepository([
      sealLetter(id: 'old', text: 'x', unlockDays: 30, now: DateTime(2026, 9)),
    ]);
    final outcome = await _container(repo)
        .read(sealLetterActionProvider)('new', 30);

    expect(outcome.rejection, isNull);
    expect(repo.all, hasLength(2));
  });

  test('Premium seals as many as she likes', () async {
    final repo = FakeLetterRepository();
    final seal = _container(repo, premium: true).read(sealLetterActionProvider);

    for (var i = 0; i < 3; i++) {
      expect((await seal('letter $i', 30)).rejection, isNull);
    }
    expect(repo.all, hasLength(3));
  });

  test('after Premium ends her extra sealed letters stay', () async {
    final repo = FakeLetterRepository([
      for (var i = 0; i < 3; i++)
        sealLetter(id: 'l$i', text: 'x', unlockDays: 90, now: _now),
    ]);
    final container = _container(repo);
    await container.listen(futureLettersProvider.future, (_, _) {}).read();

    expect(container.read(sealedLettersLeftProvider), 0);
    expect(await repo.letters(), hasLength(3));
    expect(
      (await container.read(sealLetterActionProvider)('more', 30)).rejection,
      LetterRejection.limitReached,
    );
  });

  test(
    'sealing stores the letter and asks for notification permission',
    () async {
      final repo = FakeLetterRepository();
      final scheduler = FakeReminderScheduler();
      final outcome = await _container(
        repo,
        scheduler: scheduler,
      ).read(sealLetterActionProvider)('Dear me', 90);

      expect(outcome.rejection, isNull);
      expect(outcome.reminderOn, isTrue);
      expect(scheduler.permissionRequests, 1);
      expect(repo.all.single.body, 'Dear me');
      expect(repo.all.single.unlockAt, DateTime(2027, 1, 31, 9));
    },
  );

  test('a letter is still sealed when notifications are refused', () async {
    final repo = FakeLetterRepository();
    final outcome = await _container(
      repo,
      scheduler: FakeReminderScheduler(allowed: false),
    ).read(sealLetterActionProvider)('Dear me', 30);

    expect(outcome.reminderOn, isFalse);
    expect(repo.all, hasLength(1));
  });

  test('a bad letter is rejected and nothing is stored', () async {
    final repo = FakeLetterRepository();
    final container = _container(repo);
    final empty = await container.read(sealLetterActionProvider)(' ', 30);
    final delay = await container.read(sealLetterActionProvider)('hi', 5);

    expect(empty.rejection, LetterRejection.empty);
    expect(delay.rejection, LetterRejection.badDelay);
    expect(repo.all, isEmpty);
  });

  test('the notification says a letter is ready, never what it says', () async {
    final repo = FakeLetterRepository();
    final notifier = FakeLetterNotifier();
    final scheduler = FakeReminderScheduler()..granted = true;
    final container = _container(repo, notifier: notifier, scheduler: scheduler)
      ..listen(letterNotificationsSyncProvider, (_, _) {});
    await container.read(letterNotificationsSyncProvider.future);

    await container.read(sealLetterActionProvider)('My secret words', 30);
    await pumpEventQueue();

    expect(notifier.openings.values.single, DateTime(2026, 12, 2, 9));
    final texts = notifier.texts!;
    for (final text in [
      texts.title,
      texts.body,
      texts.channelName,
      texts.channelDescription,
    ]) {
      expect(text.contains('secret'), isFalse);
    }
  });

  test('an opened letter gets no notification', () async {
    final opened = sealLetter(
      id: 'old',
      text: 'Old words',
      unlockDays: 30,
      now: DateTime(2026, 9),
    );
    final repo = FakeLetterRepository([opened]);
    final notifier = FakeLetterNotifier();
    final container = _container(
      repo,
      notifier: notifier,
      scheduler: FakeReminderScheduler()..granted = true,
    )..listen(letterNotificationsSyncProvider, (_, _) {});
    await container.read(letterNotificationsSyncProvider.future);
    await pumpEventQueue();

    expect(notifier.openings, isEmpty);
  });

  test('deleting removes the letter, its notification and its copy', () async {
    final repo = FakeLetterRepository();
    final notifier = FakeLetterNotifier();
    final letter = sealLetter(id: 'a', text: 'x', unlockDays: 30, now: _now);
    final remote = FakeLetterRemote({
      'u1': [letter],
    });
    final container = _container(
      repo,
      notifier: notifier,
      remote: remote,
      signedIn: true,
    )..listen(authUserProvider, (_, _) {});
    await repo.add(letter);
    await container.read(authUserProvider.future);

    await container.read(deleteLetterProvider)('a');

    expect(repo.all, isEmpty);
    expect(notifier.cancelled, ['a']);
    expect(remote.stored['u1'], isEmpty);
  });

  test('uploads letters and restores them on another device', () async {
    final repo = FakeLetterRepository();
    final remote = FakeLetterRemote();
    final container = _container(repo, remote: remote, signedIn: true)
      ..listen(letterSyncProvider, (_, _) {});
    await container.read(letterSyncProvider.future);

    await container.read(sealLetterActionProvider)('Dear me', 30);
    await pumpEventQueue();
    expect(remote.stored['u1']?.single.body, 'Dear me');

    final fresh = FakeLetterRepository();
    final restored = _container(fresh, remote: remote, signedIn: true)
      ..listen(letterSyncProvider, (_, _) {});
    await restored.read(letterSyncProvider.future);

    expect(fresh.all.single.body, 'Dear me');
  });
}
