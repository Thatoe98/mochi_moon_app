import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/auth/domain/auth_repository.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/deck/domain/deck_counters.dart';

import '../../auth/support/fake_auth_repository.dart';
import '../support/fake_deck_repository.dart';

const _uid = 'uid_1';

void main() {
  var now = DateTime(2026, 10, 28, 12);

  setUp(() => now = DateTime(2026, 10, 28, 12));

  Future<ProviderContainer> start({
    required FakeDeckRepository repo,
    FakeDeckCountersRemote? remote,
    bool signedIn = true,
  }) async {
    final container = ProviderContainer(
      overrides: [
        deckRepositoryProvider.overrideWithValue(repo),
        deckCountersRemoteProvider.overrideWithValue(remote),
        clockProvider.overrideWithValue(() => now),
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository(
            signedIn: signedIn ? const AuthUser(uid: _uid) : null,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    container.listen(deckSyncProvider, (_, _) {});
    await container.read(deckSyncProvider.future);
    await pumpEventQueue();
    return container;
  }

  DeckEvent event(int id, DateTime at) =>
      DeckEvent(id: id, quoteId: 'q$id', action: DeckAction.skipped, at: at);

  test('sends the counters when the app opens', () async {
    final remote = FakeDeckCountersRemote();
    await start(
      repo: FakeDeckRepository([
        event(1, DateTime(2026, 10, 27, 9)),
        event(2, DateTime(2026, 10, 28, 8)),
        event(3, DateTime(2026, 10, 28, 9)),
      ]),
      remote: remote,
    );

    final put = remote.puts.single;
    expect(put.uid, _uid);
    expect(put.counters.streak, 2);
    expect(put.counters.todayCount, 2);
    expect(put.counters.todayDate, DateTime(2026, 10, 28));
    expect(put.counters.lastCompletedDate, DateTime(2026, 10, 28));
  });

  test('a finished ritual counts in the counters', () async {
    final repo = FakeDeckRepository();
    final remote = FakeDeckCountersRemote();
    await start(repo: repo, remote: remote);

    await repo.markRitualDay(now);
    await pumpEventQueue();

    final counters = remote.puts.last.counters;
    expect(counters.streak, 1);
    expect(counters.todayCount, 0);
    expect(counters.lastCompletedDate, DateTime(2026, 10, 28));
  });

  test('sends zeroes and no last day before the first card', () async {
    final remote = FakeDeckCountersRemote();
    await start(repo: FakeDeckRepository(), remote: remote);

    final counters = remote.puts.single.counters;
    expect(counters.streak, 0);
    expect(counters.todayCount, 0);
    expect(counters.lastCompletedDate, isNull);
  });

  test('sends the new counters after each swipe and after an undo', () async {
    final repo = FakeDeckRepository();
    final remote = FakeDeckCountersRemote();
    await start(repo: repo, remote: remote);

    final first = await repo.record('q1', DeckAction.saved, now);
    await pumpEventQueue();
    await repo.record('q2', DeckAction.skipped, now);
    await pumpEventQueue();
    expect(remote.puts.last.counters.todayCount, 2);
    expect(remote.puts.last.counters.streak, 1);

    await repo.undo(first);
    await pumpEventQueue();
    expect(remote.puts.last.counters.todayCount, 1);
  });

  test('does not resend counters that have not changed', () async {
    final repo = FakeDeckRepository();
    final remote = FakeDeckCountersRemote();
    await start(repo: repo, remote: remote);
    final before = remote.puts.length;

    // Undoing an event that is not in the history changes nothing.
    await repo.undo(event(-1, now));
    await pumpEventQueue();

    expect(remote.puts.length, before);
  });

  test('a failed upload is retried with the next change', () async {
    final repo = FakeDeckRepository();
    final remote = FakeDeckCountersRemote();
    await start(repo: repo, remote: remote);

    remote.error = const NetworkFailure();
    await repo.record('q1', DeckAction.skipped, now);
    await pumpEventQueue();
    final sent = remote.puts.length;

    remote.error = null;
    await repo.record('q2', DeckAction.skipped, now);
    await pumpEventQueue();

    expect(remote.puts.length, sent + 1);
    expect(remote.puts.last.counters.todayCount, 2);
  });

  test('does nothing while signed out', () async {
    final remote = FakeDeckCountersRemote();
    await start(repo: FakeDeckRepository(), remote: remote, signedIn: false);

    expect(remote.puts, isEmpty);
  });

  test('does nothing without Firebase', () async {
    await start(repo: FakeDeckRepository());
  });

  group('DeckCounters.from', () {
    test('keeps a streak that reached yesterday', () {
      final counters = DeckCounters.from([
        event(1, DateTime(2026, 10, 26, 9)),
        event(2, DateTime(2026, 10, 27, 9)),
      ], now);

      expect(counters.streak, 2);
      expect(counters.todayCount, 0);
      expect(counters.lastCompletedDate, DateTime(2026, 10, 27));
    });
  });
}
