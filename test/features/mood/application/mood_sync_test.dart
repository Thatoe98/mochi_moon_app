import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/auth/domain/auth_repository.dart';
import 'package:mochi_moon/features/mood/application/mood_providers.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';

import '../../auth/support/fake_auth_repository.dart';
import '../support/fake_mood.dart';

const _uid = 'uid_1';

DayMood _mood(int day, Mood mood) =>
    DayMood(day: DateTime(2026, 10, day), mood: mood);

Future<void> _start({
  required FakeMoodRepository local,
  FakeMoodRemote? remote,
  bool signedIn = true,
}) async {
  final container = ProviderContainer(
    overrides: [
      moodRepositoryProvider.overrideWithValue(local),
      moodRemoteProvider.overrideWithValue(remote),
      authRepositoryProvider.overrideWithValue(
        FakeAuthRepository(
          signedIn: signedIn ? const AuthUser(uid: _uid) : null,
        ),
      ),
    ],
  );
  addTearDown(container.dispose);
  container.listen(moodSyncProvider, (_, _) {});
  await container.read(moodSyncProvider.future);
  await pumpEventQueue();
}

void main() {
  test('uploads the moods set on this device', () async {
    final local = FakeMoodRepository();
    await local.set(_mood(1, Mood.calm));
    final remote = FakeMoodRemote();
    await _start(local: local, remote: remote);

    expect(remote.stored[_uid], [_mood(1, Mood.calm)]);
  });

  test('brings back days that only Firestore has', () async {
    final local = FakeMoodRepository();
    final remote = FakeMoodRemote({
      _uid: [_mood(2, Mood.happy)],
    });
    await _start(local: local, remote: remote);

    expect(await local.entries(), [_mood(2, Mood.happy)]);
  });

  test('the device wins when both have a day', () async {
    final local = FakeMoodRepository();
    await local.set(_mood(3, Mood.sad));
    final remote = FakeMoodRemote({
      _uid: [_mood(3, Mood.happy)],
    });
    await _start(local: local, remote: remote);

    expect(await local.entries(), [_mood(3, Mood.sad)]);
    expect(remote.stored[_uid], [_mood(3, Mood.sad)]);
  });

  test('mirrors a mood chosen later', () async {
    final local = FakeMoodRepository();
    final remote = FakeMoodRemote();
    await _start(local: local, remote: remote);

    await local.set(_mood(4, Mood.tired));
    await pumpEventQueue();

    expect(remote.stored[_uid], [_mood(4, Mood.tired)]);
  });

  test('does nothing when signed out', () async {
    final local = FakeMoodRepository();
    await local.set(_mood(1, Mood.calm));
    final remote = FakeMoodRemote();
    await _start(local: local, remote: remote, signedIn: false);

    expect(remote.stored, isEmpty);
  });
}
