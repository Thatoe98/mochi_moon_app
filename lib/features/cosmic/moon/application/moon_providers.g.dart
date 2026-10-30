// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moon_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// What the Moon looks like right now. The engine needs no network and only a
/// few milliseconds, so it runs on the main isolate.

@ProviderFor(moonNow)
final moonNowProvider = MoonNowProvider._();

/// What the Moon looks like right now. The engine needs no network and only a
/// few milliseconds, so it runs on the main isolate.

final class MoonNowProvider
    extends $FunctionalProvider<MoonPhase, MoonPhase, MoonPhase>
    with $Provider<MoonPhase> {
  /// What the Moon looks like right now. The engine needs no network and only a
  /// few milliseconds, so it runs on the main isolate.
  MoonNowProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'moonNowProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$moonNowHash();

  @$internal
  @override
  $ProviderElement<MoonPhase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MoonPhase create(Ref ref) {
    return moonNow(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MoonPhase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MoonPhase>(value),
    );
  }
}

String _$moonNowHash() => r'e0587ce78099b71be3e630cb3a4dc34873d8a927';
