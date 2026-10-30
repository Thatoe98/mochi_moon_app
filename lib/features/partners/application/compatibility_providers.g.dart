// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compatibility_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The compatibility reading of the user and the partner with [partnerId].
/// Null while the user has no birth date of their own. Throws
/// [PartnerNotFound] when the partner is not saved. Computed on the device;
/// no birth data leaves it.

@ProviderFor(compatibility)
final compatibilityProvider = CompatibilityFamily._();

/// The compatibility reading of the user and the partner with [partnerId].
/// Null while the user has no birth date of their own. Throws
/// [PartnerNotFound] when the partner is not saved. Computed on the device;
/// no birth data leaves it.

final class CompatibilityProvider
    extends
        $FunctionalProvider<
          AsyncValue<Compatibility?>,
          Compatibility?,
          FutureOr<Compatibility?>
        >
    with $FutureModifier<Compatibility?>, $FutureProvider<Compatibility?> {
  /// The compatibility reading of the user and the partner with [partnerId].
  /// Null while the user has no birth date of their own. Throws
  /// [PartnerNotFound] when the partner is not saved. Computed on the device;
  /// no birth data leaves it.
  CompatibilityProvider._({
    required CompatibilityFamily super.from,
    required String super.argument,
  }) : super(
         retry: _retry,
         name: r'compatibilityProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$compatibilityHash();

  @override
  String toString() {
    return r'compatibilityProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Compatibility?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Compatibility?> create(Ref ref) {
    final argument = this.argument as String;
    return compatibility(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CompatibilityProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$compatibilityHash() => r'ac3f44f3cd99f2608d079496f7ffee24849bd853';

/// The compatibility reading of the user and the partner with [partnerId].
/// Null while the user has no birth date of their own. Throws
/// [PartnerNotFound] when the partner is not saved. Computed on the device;
/// no birth data leaves it.

final class CompatibilityFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Compatibility?>, String> {
  CompatibilityFamily._()
    : super(
        retry: _retry,
        name: r'compatibilityProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The compatibility reading of the user and the partner with [partnerId].
  /// Null while the user has no birth date of their own. Throws
  /// [PartnerNotFound] when the partner is not saved. Computed on the device;
  /// no birth data leaves it.

  CompatibilityProvider call(String partnerId) =>
      CompatibilityProvider._(argument: partnerId, from: this);

  @override
  String toString() => r'compatibilityProvider';
}
