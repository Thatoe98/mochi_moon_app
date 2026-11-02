// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entitlement_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The signed-in user's entitlement from Firestore (PRD §6.13). Without an
/// account or without Firebase it is [Entitlement.none].

@ProviderFor(entitlement)
final entitlementProvider = EntitlementProvider._();

/// The signed-in user's entitlement from Firestore (PRD §6.13). Without an
/// account or without Firebase it is [Entitlement.none].

final class EntitlementProvider
    extends
        $FunctionalProvider<
          AsyncValue<Entitlement>,
          Entitlement,
          Stream<Entitlement>
        >
    with $FutureModifier<Entitlement>, $StreamProvider<Entitlement> {
  /// The signed-in user's entitlement from Firestore (PRD §6.13). Without an
  /// account or without Firebase it is [Entitlement.none].
  EntitlementProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'entitlementProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$entitlementHash();

  @$internal
  @override
  $StreamProviderElement<Entitlement> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Entitlement> create(Ref ref) {
    return entitlement(ref);
  }
}

String _$entitlementHash() => r'76976075bbde7ede6055bf1aa59e722304f6b6d0';

/// Whether the user has Premium (PRD §6.12).
///
/// True only when the server's entitlement says so; until it is known it is
/// false.

@ProviderFor(hasPremium)
final hasPremiumProvider = HasPremiumProvider._();

/// Whether the user has Premium (PRD §6.12).
///
/// True only when the server's entitlement says so; until it is known it is
/// false.

final class HasPremiumProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the user has Premium (PRD §6.12).
  ///
  /// True only when the server's entitlement says so; until it is known it is
  /// false.
  HasPremiumProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasPremiumProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasPremiumHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return hasPremium(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hasPremiumHash() => r'536002f4744976d3c0e1956f0be4060c5c621809';
