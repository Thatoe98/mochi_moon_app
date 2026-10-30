import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/auth/domain/auth_repository.dart';
import 'package:mochi_moon/features/partners/application/partner_providers.dart';

import '../../auth/support/fake_auth_repository.dart';
import '../support/fake_partners.dart';

const _uid = 'uid_1';

Future<void> _start({
  required FakePartnerRepository local,
  FakePartnerRemote? remote,
  bool signedIn = true,
}) async {
  final container = ProviderContainer(
    overrides: [
      partnerRepositoryProvider.overrideWithValue(local),
      partnerRemoteProvider.overrideWithValue(remote),
      authRepositoryProvider.overrideWithValue(
        FakeAuthRepository(
          signedIn: signedIn ? const AuthUser(uid: _uid) : null,
        ),
      ),
    ],
  );
  addTearDown(container.dispose);
  container.listen(partnerSyncProvider, (_, _) {});
  await container.read(partnerSyncProvider.future);
  await pumpEventQueue();
}

void main() {
  test('uploads the partners saved on this device', () async {
    final remote = FakePartnerRemote();
    await _start(
      local: FakePartnerRepository([partner('a'), partner('b', day: 2)]),
      remote: remote,
    );

    expect(remote.idsOf(_uid), unorderedEquals(['a', 'b']));
  });

  test('brings back partners that only Firestore has', () async {
    final local = FakePartnerRepository([partner('a', nickname: 'Mine')]);
    final remote = FakePartnerRemote({
      _uid: [partner('a', nickname: 'Theirs'), partner('z', day: 3)],
    });
    await _start(local: local, remote: remote);

    expect(local.saved.map((p) => p.id), unorderedEquals(['a', 'z']));
    // The device wins for a partner both sides have, and is sent up.
    expect(local.saved.firstWhere((p) => p.id == 'a').nickname, 'Mine');
    expect(
      remote.stored[_uid]!.firstWhere((p) => p.id == 'a').nickname,
      'Mine',
    );
  });

  test('does not upload a partner Firestore already has unchanged', () async {
    final remote = FakePartnerRemote({
      _uid: [partner('a')],
    });
    await _start(local: FakePartnerRepository([partner('a')]), remote: remote);

    expect(remote.puts, 0);
  });

  test('mirrors a partner added later', () async {
    final local = FakePartnerRepository();
    final remote = FakePartnerRemote();
    await _start(local: local, remote: remote);

    await local.save(partner('c'));
    await pumpEventQueue();

    expect(remote.idsOf(_uid), ['c']);
  });

  test('mirrors an edit', () async {
    final local = FakePartnerRepository([partner('a')]);
    final remote = FakePartnerRemote();
    await _start(local: local, remote: remote);

    await local.save(partner('a', nickname: 'Sol', birthMinutes: 600));
    await pumpEventQueue();

    final stored = remote.stored[_uid]!.single;
    expect(stored.nickname, 'Sol');
    expect(stored.birthMinutes, 600);
  });

  test('mirrors an individual delete and leaves the others', () async {
    final local = FakePartnerRepository([partner('a'), partner('b', day: 2)]);
    final remote = FakePartnerRemote();
    await _start(local: local, remote: remote);

    await local.remove('a');
    await pumpEventQueue();

    expect(remote.idsOf(_uid), ['b']);
  });

  test('retries a failed upload with the next change', () async {
    final local = FakePartnerRepository();
    final remote = FakePartnerRemote();
    await _start(local: local, remote: remote);

    remote.error = const NetworkFailure();
    await local.save(partner('a'));
    await pumpEventQueue();
    expect(remote.idsOf(_uid), isEmpty);

    remote.error = null;
    await local.save(partner('b', day: 2));
    await pumpEventQueue();
    expect(remote.idsOf(_uid), unorderedEquals(['a', 'b']));
  });

  test('keeps working on this device when Firestore cannot be read', () async {
    final local = FakePartnerRepository([partner('a')]);
    final remote = FakePartnerRemote()..error = const NetworkFailure();
    await _start(local: local, remote: remote);

    expect(local.saved.map((p) => p.id), ['a']);
  });

  test('does nothing when signed out or without Firebase', () async {
    final remote = FakePartnerRemote();
    await _start(
      local: FakePartnerRepository([partner('a')]),
      remote: remote,
      signedIn: false,
    );
    expect(remote.idsOf(_uid), isEmpty);

    await _start(local: FakePartnerRepository([partner('a')]));
  });
}
