// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cosmic_unlock.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The "Unlock your cosmic side" flow (PRD §6.1): birth date, birth time,
/// birthplace. Saving puts them on the profile; nothing is saved before that,
/// so leaving mid-flow keeps Cosmic locked.

@ProviderFor(CosmicUnlock)
final cosmicUnlockProvider = CosmicUnlockProvider._();

/// The "Unlock your cosmic side" flow (PRD §6.1): birth date, birth time,
/// birthplace. Saving puts them on the profile; nothing is saved before that,
/// so leaving mid-flow keeps Cosmic locked.
final class CosmicUnlockProvider
    extends $NotifierProvider<CosmicUnlock, UnlockState> {
  /// The "Unlock your cosmic side" flow (PRD §6.1): birth date, birth time,
  /// birthplace. Saving puts them on the profile; nothing is saved before that,
  /// so leaving mid-flow keeps Cosmic locked.
  CosmicUnlockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cosmicUnlockProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cosmicUnlockHash();

  @$internal
  @override
  CosmicUnlock create() => CosmicUnlock();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UnlockState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UnlockState>(value),
    );
  }
}

String _$cosmicUnlockHash() => r'766ec00a3d62d44dc31540f56928794292026b2b';

/// The "Unlock your cosmic side" flow (PRD §6.1): birth date, birth time,
/// birthplace. Saving puts them on the profile; nothing is saved before that,
/// so leaving mid-flow keeps Cosmic locked.

abstract class _$CosmicUnlock extends $Notifier<UnlockState> {
  UnlockState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<UnlockState, UnlockState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UnlockState, UnlockState>,
              UnlockState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
