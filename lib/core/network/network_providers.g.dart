// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The Readings API base URL from the flavor config; empty when the build has
/// none. `bootstrap` overrides it.

@ProviderFor(readingsApiBaseUrl)
final readingsApiBaseUrlProvider = ReadingsApiBaseUrlProvider._();

/// The Readings API base URL from the flavor config; empty when the build has
/// none. `bootstrap` overrides it.

final class ReadingsApiBaseUrlProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// The Readings API base URL from the flavor config; empty when the build has
  /// none. `bootstrap` overrides it.
  ReadingsApiBaseUrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readingsApiBaseUrlProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readingsApiBaseUrlHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return readingsApiBaseUrl(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$readingsApiBaseUrlHash() =>
    r'e86a98d040b460917cfb35545701a082d1a72596';

/// The signed-in user's ID token for the Readings API. Always null without
/// Firebase.

@ProviderFor(idTokenSource)
final idTokenSourceProvider = IdTokenSourceProvider._();

/// The signed-in user's ID token for the Readings API. Always null without
/// Firebase.

final class IdTokenSourceProvider
    extends $FunctionalProvider<IdTokenSource, IdTokenSource, IdTokenSource>
    with $Provider<IdTokenSource> {
  /// The signed-in user's ID token for the Readings API. Always null without
  /// Firebase.
  IdTokenSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'idTokenSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$idTokenSourceHash();

  @$internal
  @override
  $ProviderElement<IdTokenSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IdTokenSource create(Ref ref) {
    return idTokenSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IdTokenSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IdTokenSource>(value),
    );
  }
}

String _$idTokenSourceHash() => r'dd828ae6f3b4895183bd68739a13c6aa1f59535b';

/// The Readings API client, or null while the build has no base URL.

@ProviderFor(readingsApi)
final readingsApiProvider = ReadingsApiProvider._();

/// The Readings API client, or null while the build has no base URL.

final class ReadingsApiProvider
    extends $FunctionalProvider<ReadingsApi?, ReadingsApi?, ReadingsApi?>
    with $Provider<ReadingsApi?> {
  /// The Readings API client, or null while the build has no base URL.
  ReadingsApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readingsApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readingsApiHash();

  @$internal
  @override
  $ProviderElement<ReadingsApi?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ReadingsApi? create(Ref ref) {
    return readingsApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReadingsApi? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReadingsApi?>(value),
    );
  }
}

String _$readingsApiHash() => r'b3d4e271f17c9ce0feec06ecf0c7dad085c68a96';
