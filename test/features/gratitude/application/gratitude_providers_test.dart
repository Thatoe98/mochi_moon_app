import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/auth/domain/auth_repository.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/gratitude/application/gratitude_providers.dart';
import 'package:mochi_moon/features/gratitude/domain/gratitude.dart';

import '../../auth/support/fake_auth_repository.dart';
import '../support/fake_gratitude.dart';

const _uid = 'uid_1';
final _now = DateTime(2026, 10, 28, 12);

GratitudeNote _note(String id, int day) => GratitudeNote(
  id: id,
  day: DateTime(2026, 10, day),
  body: 'Thanks $id',
  createdAt: DateTime(2026, 10, day, 9),
);

ProviderContainer _container({
  required FakeGratitudeRepository local,
  FakeGratitudeRemote? remote,
  bool signedIn = true,
}) {
  final container = ProviderContainer(
    overrides: [
      gratitudeRepositoryProvider.overrideWithValue(local),
      gratitudeRemoteProvider.overrideWithValue(remote),
      clockProvider.overrideWithValue(() => _now),
      authRepositoryProvider.overrideWithValue(
        FakeAuthRepository(
          signedIn: signedIn ? const AuthUser(uid: _uid) : null,
        ),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> _sync(ProviderContainer container) async {
  container.listen(gratitudeSyncProvider, (_, _) {});
  await container.read(gratitudeSyncProvider.future);
  await pumpEventQueue();
}

void main() {
  group('addGratitude', () {
    test('stores a trimmed entry for today', () async {
      final local = FakeGratitudeRepository();
      final container = _container(local: local);

      final result = await container.read(addGratitudeProvider)('  Warm tea ');

      expect(result, isNull);
      expect(local.all.single.body, 'Warm tea');
      expect(local.all.single.day, DateTime(2026, 10, 28));
    });

    test('refuses a 201 character line', () async {
      final local = FakeGratitudeRepository();
      final container = _container(local: local);

      final result = await container.read(addGratitudeProvider)('a' * 201);

      expect(result, GratitudeRejection.tooLong);
      expect(local.all, isEmpty);
    });

    test('refuses a fourth entry on the same day', () async {
      final local = FakeGratitudeRepository();
      final container = _container(local: local);
      final add = container.read(addGratitudeProvider);

      expect(await add('one'), isNull);
      expect(await add('two'), isNull);
      expect(await add('three'), isNull);
      expect(await add('four'), GratitudeRejection.dayFull);
      expect(local.all, hasLength(3));
    });

    test('earlier days do not count toward today', () async {
      final local = FakeGratitudeRepository([
        _note('a', 27),
        _note('b', 27),
        _note('c', 27),
      ]);
      final container = _container(local: local);

      expect(await container.read(addGratitudeProvider)('today'), isNull);
    });
  });

  group('deleteGratitude', () {
    test('removes the entry here and in Firestore', () async {
      final local = FakeGratitudeRepository([_note('a', 1)]);
      final remote = FakeGratitudeRemote({
        _uid: [_note('a', 1)],
      });
      final container = _container(local: local, remote: remote);
      await container.listen(authUserProvider.future, (_, _) {}).read();

      await container.read(deleteGratitudeProvider)('a');

      expect(local.all, isEmpty);
      expect(remote.stored[_uid], isEmpty);
    });

    test('still deletes on the device when Firestore is unreachable', () async {
      final local = FakeGratitudeRepository([_note('a', 1)]);
      final remote = FakeGratitudeRemote()..error = const NetworkFailure();
      final container = _container(local: local, remote: remote);
      await container.listen(authUserProvider.future, (_, _) {}).read();

      await container.read(deleteGratitudeProvider)('a');

      expect(local.all, isEmpty);
    });
  });

  group('gratitudeSync', () {
    test('uploads entries written on this device', () async {
      final local = FakeGratitudeRepository();
      await local.add(_note('a', 1));
      final remote = FakeGratitudeRemote();
      await _sync(_container(local: local, remote: remote));

      expect(remote.stored[_uid], [_note('a', 1)]);
    });

    test('brings back entries that only Firestore has', () async {
      final local = FakeGratitudeRepository();
      final remote = FakeGratitudeRemote({
        _uid: [_note('b', 2)],
      });
      await _sync(_container(local: local, remote: remote));

      expect(local.all, [_note('b', 2)]);
    });

    test('mirrors an entry added later', () async {
      final local = FakeGratitudeRepository();
      final remote = FakeGratitudeRemote();
      await _sync(_container(local: local, remote: remote));

      await local.add(_note('c', 3));
      await pumpEventQueue();

      expect(remote.stored[_uid], [_note('c', 3)]);
    });

    test('keeps the entry and retries after a failed upload', () async {
      final local = FakeGratitudeRepository();
      await local.add(_note('a', 1));
      final remote = FakeGratitudeRemote()..error = const NetworkFailure();
      await _sync(_container(local: local, remote: remote));

      expect(await local.unsynced(), hasLength(1));
    });

    test('does nothing when signed out', () async {
      final local = FakeGratitudeRepository();
      await local.add(_note('a', 1));
      final remote = FakeGratitudeRemote();
      await _sync(_container(local: local, remote: remote, signedIn: false));

      expect(remote.stored, isEmpty);
    });
  });
}
