import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:mochi_moon/features/paywall/domain/entitlement.dart';

void main() {
  test('without an account there is no Premium', () async {
    final container = ProviderContainer(
      overrides: [
        firebaseReadyProvider.overrideWithValue(false),
        authUserProvider.overrideWith((ref) => Stream.value(null)),
      ],
    );
    addTearDown(container.dispose);
    container.listen(authUserProvider, (_, _) {});
    await container.read(authUserProvider.future);
    container.listen(entitlementProvider, (_, _) {});
    await container.read(entitlementProvider.future);
    expect(container.read(hasPremiumProvider), isFalse);
  });

  test('Premium follows the entitlement', () async {
    final controller = StreamController<Entitlement>();
    addTearDown(controller.close);
    final container = ProviderContainer(
      overrides: [entitlementProvider.overrideWith((ref) => controller.stream)],
    );
    addTearDown(container.dispose);
    container.listen(entitlementProvider, (_, _) {});

    expect(container.read(hasPremiumProvider), isFalse); // not known yet

    controller.add(const Entitlement(premium: true));
    await container.read(entitlementProvider.future);
    container.invalidate(hasPremiumProvider);
    expect(container.read(hasPremiumProvider), isTrue);
  });
}
