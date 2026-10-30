import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/partners/application/partner_providers.dart';
import 'package:mochi_moon/features/partners/domain/partner.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';

import '../support/fake_partners.dart';

ProviderContainer _container(
  FakePartnerRepository repository, {
  required bool premium,
}) {
  final container = ProviderContainer(
    overrides: [
      partnerRepositoryProvider.overrideWithValue(repository),
      hasPremiumProvider.overrideWithValue(premium),
      partnerIdGeneratorProvider.overrideWithValue(() => 'new-id'),
      clockProvider.overrideWithValue(() => DateTime(2026, 10, 30, 9)),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('limits are 1 for Free and 5 for Premium', () {
    expect(partnerLimit(hasPremium: false), 1);
    expect(partnerLimit(hasPremium: true), 5);
  });

  test('startNew gives an id and the time from the clock', () {
    final container = _container(FakePartnerRepository(), premium: false);
    final fresh = container.read(partnersProvider.notifier).startNew();
    expect(fresh.id, 'new-id');
    expect(fresh.createdAt, DateTime(2026, 10, 30, 9));
  });

  test('a Free user can save one partner, not a second', () async {
    final repository = FakePartnerRepository();
    final container = _container(repository, premium: false);
    final notifier = container.read(partnersProvider.notifier);
    await container.read(partnersProvider.future);

    expect(container.read(canAddPartnerProvider), isTrue);
    await notifier.save(partner('a'));
    expect(container.read(canAddPartnerProvider), isFalse);

    await expectLater(
      notifier.save(partner('b', day: 2)),
      throwsA(isA<PartnerLimitReached>().having((e) => e.limit, 'limit', 1)),
    );
    expect(repository.saved.map((p) => p.id), ['a']);
  });

  test('editing a partner is allowed at the limit', () async {
    final repository = FakePartnerRepository([partner('a')]);
    final container = _container(repository, premium: false);
    await container.read(partnersProvider.future);

    await container
        .read(partnersProvider.notifier)
        .save(partner('a', nickname: 'Sol'));

    expect(repository.saved.single.nickname, 'Sol');
    expect(container.read(partnersProvider).value!.single.nickname, 'Sol');
  });

  test('a Premium user can save five, not six', () async {
    final repository = FakePartnerRepository();
    final container = _container(repository, premium: true);
    final notifier = container.read(partnersProvider.notifier);
    await container.read(partnersProvider.future);

    for (var i = 0; i < 5; i++) {
      await notifier.save(partner('p$i', day: i + 1));
    }
    expect(container.read(canAddPartnerProvider), isFalse);
    await expectLater(
      notifier.save(partner('p5', day: 9)),
      throwsA(isA<PartnerLimitReached>()),
    );
  });

  test('removing a partner frees a place', () async {
    final repository = FakePartnerRepository([partner('a')]);
    final container = _container(repository, premium: false);
    await container.read(partnersProvider.future);
    expect(container.read(canAddPartnerProvider), isFalse);

    await container.read(partnersProvider.notifier).remove('a');

    expect(repository.saved, isEmpty);
    expect(container.read(canAddPartnerProvider), isTrue);
  });
}
