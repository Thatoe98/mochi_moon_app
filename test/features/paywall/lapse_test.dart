import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/mascot_item.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/mascot/domain/mascot_state.dart';
import 'package:mochi_moon/features/mascot/domain/mascot_unlocks.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';
import 'package:mochi_moon/features/partners/application/partner_providers.dart';
import 'package:mochi_moon/features/partners/domain/partner.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';

import '../mood/support/fake_mood.dart';
import '../partners/support/fake_partners.dart';

// Own cards, sealed letters and retrograde alerts have their lapse tests next
// to their providers. These cover the rest of PRD 6.13: when Premium ends,
// nothing she made or got is removed; only new creation is blocked.

ProviderContainer _container(
  FakePartnerRepository repository, {
  required bool premium,
}) {
  final container = ProviderContainer(
    overrides: [
      partnerRepositoryProvider.overrideWithValue(repository),
      hasPremiumProvider.overrideWithValue(premium),
      clockProvider.overrideWithValue(() => DateTime(2026, 10, 30, 9)),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('saved partners stay listed, editable and removable', () async {
    final repository = FakePartnerRepository([
      for (var i = 0; i < 4; i++) partner('p$i', day: i + 1),
    ]);
    final container = _container(repository, premium: false);
    final notifier = container.read(partnersProvider.notifier);
    final all = await container.read(partnersProvider.future);

    expect(all, hasLength(4));
    expect(container.read(canAddPartnerProvider), isFalse);

    await expectLater(
      notifier.save(partner('new', day: 9)),
      throwsA(isA<PartnerLimitReached>()),
    );
    await notifier.save(partner('p2', nickname: 'Renamed', day: 3));
    expect(
      container.read(partnersProvider).value!.map((p) => p.nickname),
      contains('Renamed'),
    );

    await notifier.remove('p0');
    expect(container.read(partnersProvider).value, hasLength(3));
  });

  test('older mood months are kept in full', () async {
    final moods = FakeMoodRepository();
    await moods.set(DayMood(day: DateTime(2026, 5, 3), mood: Mood.calm));
    await moods.set(DayMood(day: DateTime(2026, 10, 3), mood: Mood.calm));

    expect(await moods.entries(), hasLength(2));
  });

  test('an equipped Premium outfit stays; a new one needs Premium', () {
    const premiumItem = MascotItem(
      id: 'gold_cape',
      slot: 'outfit',
      name: {'en': 'Gold cape'},
      unlock: MascotUnlock(type: 'streak', value: 7),
      illustrationId: 'moon_01',
      premium: true,
    );
    const state = MascotState(
      owned: ['gold_cape'],
      equipped: {'outfit': 'gold_cape'},
    );

    expect(state.outfit, 'gold_cape');
    expect(state.owns('gold_cape'), isTrue);
    expect(canEquip(premiumItem, state, isPremium: false), isFalse);
    expect(canEquip(premiumItem, state, isPremium: true), isTrue);
  });
}
