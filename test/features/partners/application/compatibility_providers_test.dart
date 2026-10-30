import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/cosmic/astro/synastry.dart';
import 'package:mochi_moon/features/partners/application/compatibility_providers.dart';
import 'package:mochi_moon/features/partners/application/partner_chart.dart';
import 'package:mochi_moon/features/partners/application/partner_providers.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';

import '../../profile/support/fake_profile.dart';
import '../support/fake_partners.dart';

ProviderContainer _container({
  UserProfile? profile,
  List<String> partnerIds = const ['a'],
}) {
  final container = ProviderContainer(
    overrides: [
      profileRepositoryProvider.overrideWithValue(
        FakeProfileRepository(profile),
      ),
      partnerRepositoryProvider.overrideWithValue(
        FakePartnerRepository([for (final id in partnerIds) partner(id)]),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

final _profile = UserProfile(
  displayName: 'Mochi',
  birthDate: DateTime(1998, 11, 8),
);

void main() {
  test('reads the user against the partner on the device', () async {
    final container = _container(profile: _profile);

    final result = await container.read(compatibilityProvider('a').future);

    expect(result, isNotNull);
    expect(result!.partner.id, 'a');
    expect(result.synastry.overall, inInclusiveRange(35, 98));
    expect(result.synastry.light, isTrue);
  });

  test('is null while the user has no birth date', () async {
    final container = _container();

    expect(await container.read(compatibilityProvider('a').future), isNull);
  });

  test('throws PartnerNotFound for an unknown id', () async {
    final container = _container(profile: _profile)
      ..listen(compatibilityProvider('nope'), (_, _) {});

    await expectLater(
      container.read(compatibilityProvider('nope').future),
      throwsA(isA<PartnerNotFound>()),
    );
  });

  test('lists at most three supportive and two growth aspects', () async {
    final container = _container(profile: _profile);

    final result = (await container.read(compatibilityProvider('a').future))!;

    expect(result.topSupportive.length, lessThanOrEqualTo(topSupportiveCount));
    expect(result.topGrowth.length, lessThanOrEqualTo(topGrowthCount));
    expect(
      result.topSupportive,
      result.synastry.supportive.take(topSupportiveCount).toList(),
    );
    expect(result.topSupportive.every((a) => a.contribution > 0), isTrue);
    expect(result.topGrowth.every((a) => a.contribution < 0), isTrue);
  });

  test('the overall score is the same whichever side is "you"', () async {
    final container = _container(profile: _profile);
    final result = (await container.read(compatibilityProvider('a').future))!;

    final swapped = synastry(chartOfPartner(result.partner), result.you);

    expect(swapped.overall, result.synastry.overall);
    expect(swapped.light, result.synastry.light);
  });
}
