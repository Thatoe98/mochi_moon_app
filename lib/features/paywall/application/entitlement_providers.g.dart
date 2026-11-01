// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entitlement_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the user has Premium (PRD §6.12).
///
/// Always true until Google Play Billing and the server entitlement exist
/// (M4), so Premium features can be built and tried now. Switch this to the
/// real entitlement then; nothing else has to change.
// TODO(Thatoe98): read the real entitlement in M4.

@ProviderFor(hasPremium)
final hasPremiumProvider = HasPremiumProvider._();

/// Whether the user has Premium (PRD §6.12).
///
/// Always true until Google Play Billing and the server entitlement exist
/// (M4), so Premium features can be built and tried now. Switch this to the
/// real entitlement then; nothing else has to change.
// TODO(Thatoe98): read the real entitlement in M4.

final class HasPremiumProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the user has Premium (PRD §6.12).
  ///
  /// Always true until Google Play Billing and the server entitlement exist
  /// (M4), so Premium features can be built and tried now. Switch this to the
  /// real entitlement then; nothing else has to change.
  // TODO(Thatoe98): read the real entitlement in M4.
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

String _$hasPremiumHash() => r'031231660c784c2ffc0b49b2b92f7b244bb528e7';
