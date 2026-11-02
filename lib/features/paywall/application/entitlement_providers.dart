import 'package:flutter/foundation.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/paywall/data/firestore_entitlement_remote.dart';
import 'package:mochi_moon/features/paywall/domain/entitlement.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'entitlement_providers.g.dart';

/// Debug builds only: `--dart-define=PREMIUM_OVERRIDE=true` turns Premium on
/// without a purchase so Premium screens can be tried. Release builds ignore
/// it.
const _premiumOverride = bool.fromEnvironment('PREMIUM_OVERRIDE');

/// The signed-in user's entitlement from Firestore (PRD §6.13). Without an
/// account or without Firebase it is [Entitlement.none].
@Riverpod(keepAlive: true)
Stream<Entitlement> entitlement(Ref ref) {
  final user = ref.watch(authUserProvider).value;
  if (user == null || !ref.watch(firebaseReadyProvider)) {
    return Stream.value(Entitlement.none);
  }
  return FirestoreEntitlementRemote().watch(user.uid);
}

/// How many one-off compatibility report credits she has (PRD §6.13); the
/// server counts them. Zero until known.
@Riverpod(keepAlive: true)
int reportCredits(Ref ref) =>
    ref.watch(entitlementProvider).value?.reportCredits ?? 0;

/// Whether the user has Premium (PRD §6.12).
///
/// True only when the server's entitlement says so; until it is known it is
/// false.
@Riverpod(keepAlive: true)
bool hasPremium(Ref ref) {
  if (kDebugMode && _premiumOverride) return true;
  final value = ref.watch(entitlementProvider).value;
  return value?.isPremiumAt(DateTime.now()) ?? false;
}
