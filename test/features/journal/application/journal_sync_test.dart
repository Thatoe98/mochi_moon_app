import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/auth/domain/auth_repository.dart';
import 'package:mochi_moon/features/journal/application/journal_providers.dart';
import 'package:mochi_moon/features/journal/domain/journal_repository.dart';

import '../../auth/support/fake_auth_repository.dart';
import '../support/fake_journal_repository.dart';

const _uid = 'uid_1';

JournalEntry _entry(String id, int day) =>
    JournalEntry(quoteId: id, savedAt: DateTime(2026, 10, day));

/// Starts the sync and waits until it has done its first pass.
Future<ProviderContainer> _start({
  required FakeJournalRepository local,
  FakeJournalRemote? remote,
  bool signedIn = true,
}) async {
  final container = ProviderContainer(
    overrides: [
      journalRepositoryProvider.overrideWithValue(local),
      journalRemoteProvider.overrideWithValue(remote),
      authRepositoryProvider.overrideWithValue(
        FakeAuthRepository(signedIn: signedIn ? const AuthUser(uid: _uid) : null),
      ),
    ],
  );
  addTearDown(container.dispose);
  container.listen(journalSyncProvider, (_, _) {});
  await container.read(journalSyncProvider.future);
  await pumpEventQueue();
  return container;
}

void main() {
  test('uploads the cards saved on this device', () async {
    final remote = FakeJournalRemote();
    await _start(
      local: FakeJournalRepository([_entry('q1', 1), _entry('q2', 2)]),
      remote: remote,
    );

    expect(remote.idsOf(_uid), unorderedEquals(['q1', 'q2']));
  });

  test('brings back cards that only Firestore has', () async {
    final local = FakeJournalRepository([_entry('q1', 1)]);
    final remote = FakeJournalRemote({
      _uid: [_entry('q1', 5), _entry('q9', 3)],
    });
    await _start(local: local, remote: remote);

    expect(local.saved.map((e) => e.quoteId), unorderedEquals(['q1', 'q9']));
    // A card both sides have keeps the date from this device.
    expect(local.saved.firstWhere((e) => e.quoteId == 'q1').savedAt.day, 1);
    expect(remote.idsOf(_uid), unorderedEquals(['q1', 'q9']));
  });

  test('mirrors a card saved later', () async {
    final local = FakeJournalRepository();
    final remote = FakeJournalRemote();
    await _start(local: local, remote: remote);

    local.save(_entry('q3', 4));
    await pumpEventQueue();

    expect(remote.idsOf(_uid), ['q3']);
    expect(remote.stored[_uid]!.single.savedAt, DateTime(2026, 10, 4));
  });

  test('mirrors a removed card', () async {
    final local = FakeJournalRepository([_entry('q1', 1), _entry('q2', 2)]);
    final remote = FakeJournalRemote();
    await _start(local: local, remote: remote);

    await local.remove('q1');
    await pumpEventQueue();

    expect(remote.idsOf(_uid), ['q2']);
  });

  test('retries a failed upload with the next change', () async {
    final local = FakeJournalRepository();
    final remote = FakeJournalRemote();
    await _start(local: local, remote: remote);

    remote.error = const NetworkFailure();
    local.save(_entry('q1', 1));
    await pumpEventQueue();
    expect(remote.idsOf(_uid), isEmpty);

    remote.error = null;
    local.save(_entry('q2', 2));
    await pumpEventQueue();
    expect(remote.idsOf(_uid), unorderedEquals(['q1', 'q2']));
  });

  test('still mirrors changes when the first read fails', () async {
    final local = FakeJournalRepository([_entry('q1', 1)]);
    final remote = FakeJournalRemote()..error = const NetworkFailure();
    await _start(local: local, remote: remote);

    remote.error = null;
    local.save(_entry('q2', 2));
    await pumpEventQueue();

    expect(remote.idsOf(_uid), unorderedEquals(['q1', 'q2']));
  });

  test('does nothing while signed out', () async {
    final remote = FakeJournalRemote();
    await _start(
      local: FakeJournalRepository([_entry('q1', 1)]),
      remote: remote,
      signedIn: false,
    );

    expect(remote.stored, isEmpty);
  });

  test('does nothing without Firebase', () async {
    final local = FakeJournalRepository([_entry('q1', 1)]);
    await _start(local: local);

    expect(local.saved, hasLength(1));
  });
}
