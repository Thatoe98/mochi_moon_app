import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/auth/domain/auth_repository.dart';
import 'package:mochi_moon/features/custom_cards/application/own_card_providers.dart';
import 'package:mochi_moon/features/custom_cards/domain/own_card.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';

import '../../auth/support/fake_auth_repository.dart';
import '../support/fake_own_cards.dart';

const _uid = 'uid_1';
final _now = DateTime(2026, 10, 31, 12);

OwnCard _card(String id, int day) => OwnCard(
  id: id,
  body: 'Words $id',
  illustrationId: 'moon_01',
  createdAt: DateTime(2026, 10, day),
);

ProviderContainer _container({
  required FakeOwnCardRepository local,
  FakeOwnCardRemote? remote,
  bool signedIn = true,
  bool premium = false,
}) {
  final container = ProviderContainer(
    overrides: [
      ownCardRepositoryProvider.overrideWithValue(local),
      ownCardRemoteProvider.overrideWithValue(remote),
      hasPremiumProvider.overrideWithValue(premium),
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
  container.listen(ownCardSyncProvider, (_, _) {});
  await container.read(ownCardSyncProvider.future);
  await pumpEventQueue();
}

void main() {
  group('saveOwnCard', () {
    test('stores a trimmed card', () async {
      final local = FakeOwnCardRepository();
      final container = _container(local: local);

      final result = await container.read(saveOwnCardProvider)(
        '  I am enough ',
        'moon_01',
      );

      expect(result, isNull);
      expect(local.all.single.body, 'I am enough');
      expect(local.all.single.illustrationId, 'moon_01');
      expect(local.all.single.createdAt, _now);
    });

    test('refuses 141 characters', () async {
      final local = FakeOwnCardRepository();
      final container = _container(local: local);

      final result = await container.read(saveOwnCardProvider)(
        'a' * 141,
        'moon_01',
      );

      expect(result, OwnCardRejection.tooLong);
      expect(local.all, isEmpty);
    });

    test('free: the fourth card is refused', () async {
      final local = FakeOwnCardRepository();
      final container = _container(local: local);
      final save = container.read(saveOwnCardProvider);

      expect(await save('one', 'moon_01'), isNull);
      expect(await save('two', 'moon_01'), isNull);
      expect(await save('three', 'moon_01'), isNull);
      expect(await save('four', 'moon_01'), OwnCardRejection.limitReached);
      expect(local.all, hasLength(3));
    });

    test('Premium: no limit', () async {
      final local = FakeOwnCardRepository();
      final container = _container(local: local, premium: true);
      final save = container.read(saveOwnCardProvider);

      for (var i = 0; i < 6; i++) {
        expect(await save('card $i', 'moon_01'), isNull);
      }
      expect(local.all, hasLength(6));
    });

    test('deleting a card frees a slot', () async {
      final local = FakeOwnCardRepository([
        _card('a', 1),
        _card('b', 2),
        _card('c', 3),
      ]);
      final container = _container(local: local);
      await container.listen(authUserProvider.future, (_, _) {}).read();

      expect(
        await container.read(saveOwnCardProvider)('new', 'moon_01'),
        OwnCardRejection.limitReached,
      );
      await container.read(deleteOwnCardProvider)('b');
      expect(
        await container.read(saveOwnCardProvider)('new', 'moon_01'),
        isNull,
      );
    });

    test('editing at the limit works and keeps id and date', () async {
      final local = FakeOwnCardRepository([
        _card('a', 1),
        _card('b', 2),
        _card('c', 3),
      ]);
      final container = _container(local: local);

      final result = await container.read(saveOwnCardProvider)(
        'Rewritten',
        'sun_02',
        editId: 'b',
      );

      expect(result, isNull);
      expect(local.all, hasLength(3));
      final edited = local.all.firstWhere((c) => c.id == 'b');
      expect(edited.body, 'Rewritten');
      expect(edited.illustrationId, 'sun_02');
      expect(edited.createdAt, DateTime(2026, 10, 2));
    });
  });

  group('ownCardQuotes', () {
    test('turns cards into private self_love deck cards', () async {
      final local = FakeOwnCardRepository([_card('a', 1)]);
      final container = _container(local: local);
      await container.listen(ownCardsProvider.future, (_, _) {}).read();

      final quote = container.read(ownCardQuotesProvider).single;

      expect(quote.id, 'own_a');
      expect(quote.category, 'self_love');
      expect(quote.moods, isEmpty);
    });
  });

  group('ownCardSlotsLeft', () {
    test('counts down for a free user', () async {
      final local = FakeOwnCardRepository([_card('a', 1)]);
      final container = _container(local: local);
      await container.listen(ownCardsProvider.future, (_, _) {}).read();

      expect(container.read(ownCardSlotsLeftProvider), 2);
    });

    test('is null for Premium', () {
      final container = _container(
        local: FakeOwnCardRepository(),
        premium: true,
      );

      expect(container.read(ownCardSlotsLeftProvider), isNull);
    });
  });

  group('deleteOwnCard', () {
    test('removes the card here and in Firestore', () async {
      final local = FakeOwnCardRepository([_card('a', 1)]);
      final remote = FakeOwnCardRemote({
        _uid: [_card('a', 1)],
      });
      final container = _container(local: local, remote: remote);
      await container.listen(authUserProvider.future, (_, _) {}).read();

      await container.read(deleteOwnCardProvider)('a');

      expect(local.all, isEmpty);
      expect(remote.stored[_uid], isEmpty);
    });

    test('still deletes on the device when Firestore is unreachable', () async {
      final local = FakeOwnCardRepository([_card('a', 1)]);
      final remote = FakeOwnCardRemote()..error = const NetworkFailure();
      final container = _container(local: local, remote: remote);
      await container.listen(authUserProvider.future, (_, _) {}).read();

      await container.read(deleteOwnCardProvider)('a');

      expect(local.all, isEmpty);
    });
  });

  group('ownCardSync', () {
    test('uploads cards written on this device', () async {
      final local = FakeOwnCardRepository();
      await local.save(_card('a', 1));
      final remote = FakeOwnCardRemote();
      await _sync(_container(local: local, remote: remote));

      expect(remote.stored[_uid], [_card('a', 1)]);
    });

    test('brings back cards that only Firestore has', () async {
      final local = FakeOwnCardRepository();
      final remote = FakeOwnCardRemote({
        _uid: [_card('b', 2)],
      });
      await _sync(_container(local: local, remote: remote));

      expect(local.all, [_card('b', 2)]);
    });

    test('mirrors a card added later', () async {
      final local = FakeOwnCardRepository();
      final remote = FakeOwnCardRemote();
      await _sync(_container(local: local, remote: remote));

      await local.save(_card('c', 3));
      await pumpEventQueue();

      expect(remote.stored[_uid], [_card('c', 3)]);
    });

    test('mirrors an edit', () async {
      final local = FakeOwnCardRepository([_card('a', 1)]);
      final remote = FakeOwnCardRemote({
        _uid: [_card('a', 1)],
      });
      await _sync(_container(local: local, remote: remote));

      final edited = _card('a', 1).copyWith(body: 'Better words');
      await local.save(edited);
      await pumpEventQueue();

      expect(remote.stored[_uid], [edited]);
    });

    test('keeps the card and retries after a failed upload', () async {
      final local = FakeOwnCardRepository();
      await local.save(_card('a', 1));
      final remote = FakeOwnCardRemote()..error = const NetworkFailure();
      await _sync(_container(local: local, remote: remote));

      expect(await local.unsynced(), hasLength(1));
    });

    test('does nothing when signed out', () async {
      final local = FakeOwnCardRepository();
      await local.save(_card('a', 1));
      final remote = FakeOwnCardRemote();
      await _sync(_container(local: local, remote: remote, signedIn: false));

      expect(remote.stored, isEmpty);
    });
  });
}
