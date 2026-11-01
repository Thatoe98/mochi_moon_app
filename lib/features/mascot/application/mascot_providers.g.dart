// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mascot_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mascotRepository)
final mascotRepositoryProvider = MascotRepositoryProvider._();

final class MascotRepositoryProvider
    extends
        $FunctionalProvider<
          MascotRepository,
          MascotRepository,
          MascotRepository
        >
    with $Provider<MascotRepository> {
  MascotRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mascotRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mascotRepositoryHash();

  @$internal
  @override
  $ProviderElement<MascotRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MascotRepository create(Ref ref) {
    return mascotRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MascotRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MascotRepository>(value),
    );
  }
}

String _$mascotRepositoryHash() => r'0489f11f0a824cb5584c9c263f66371800e44277';

/// The Firestore copy, or null when Firebase did not start.

@ProviderFor(mascotRemote)
final mascotRemoteProvider = MascotRemoteProvider._();

/// The Firestore copy, or null when Firebase did not start.

final class MascotRemoteProvider
    extends $FunctionalProvider<MascotRemote?, MascotRemote?, MascotRemote?>
    with $Provider<MascotRemote?> {
  /// The Firestore copy, or null when Firebase did not start.
  MascotRemoteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mascotRemoteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mascotRemoteHash();

  @$internal
  @override
  $ProviderElement<MascotRemote?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MascotRemote? create(Ref ref) {
    return mascotRemote(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MascotRemote? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MascotRemote?>(value),
    );
  }
}

String _$mascotRemoteHash() => r'571dd9606cba3ee4b0fdd46fd0ed4f888e2bd217';

/// What Mochi owns and wears.

@ProviderFor(mascotState)
final mascotStateProvider = MascotStateProvider._();

/// What Mochi owns and wears.

final class MascotStateProvider
    extends
        $FunctionalProvider<
          AsyncValue<MascotState>,
          MascotState,
          Stream<MascotState>
        >
    with $FutureModifier<MascotState>, $StreamProvider<MascotState> {
  /// What Mochi owns and wears.
  MascotStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mascotStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mascotStateHash();

  @$internal
  @override
  $StreamProviderElement<MascotState> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<MascotState> create(Ref ref) {
    return mascotState(ref);
  }
}

String _$mascotStateHash() => r'7882dda312b13f959b0265898a5f949f882e0c38';

/// Gives Mochi every item whose rule is now met (PRD §6.23). Items are only
/// added, so a streak that breaks later takes nothing away. Watched from the
/// app root.

@ProviderFor(mascotEarner)
final mascotEarnerProvider = MascotEarnerProvider._();

/// Gives Mochi every item whose rule is now met (PRD §6.23). Items are only
/// added, so a streak that breaks later takes nothing away. Watched from the
/// app root.

final class MascotEarnerProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Gives Mochi every item whose rule is now met (PRD §6.23). Items are only
  /// added, so a streak that breaks later takes nothing away. Watched from the
  /// app root.
  MascotEarnerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mascotEarnerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mascotEarnerHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return mascotEarner(ref);
  }
}

String _$mascotEarnerHash() => r'8acfd4964766e59b5ba0d5d9dddb526c4fe62292';

/// Puts `item` on Mochi, or does nothing when she does not own it or it needs
/// Premium. Returns whether it was equipped.

@ProviderFor(equipMascotItem)
final equipMascotItemProvider = EquipMascotItemProvider._();

/// Puts `item` on Mochi, or does nothing when she does not own it or it needs
/// Premium. Returns whether it was equipped.

final class EquipMascotItemProvider
    extends
        $FunctionalProvider<
          Future<bool> Function(MascotItem item),
          Future<bool> Function(MascotItem item),
          Future<bool> Function(MascotItem item)
        >
    with $Provider<Future<bool> Function(MascotItem item)> {
  /// Puts `item` on Mochi, or does nothing when she does not own it or it needs
  /// Premium. Returns whether it was equipped.
  EquipMascotItemProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'equipMascotItemProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$equipMascotItemHash();

  @$internal
  @override
  $ProviderElement<Future<bool> Function(MascotItem item)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<bool> Function(MascotItem item) create(Ref ref) {
    return equipMascotItem(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<bool> Function(MascotItem item) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<Future<bool> Function(MascotItem item)>(value),
    );
  }
}

String _$equipMascotItemHash() => r'1a85b6dd069afb36f393e5d139f83397f8819dd5';

/// Takes whatever is in `slot` off.

@ProviderFor(unequipMascotSlot)
final unequipMascotSlotProvider = UnequipMascotSlotProvider._();

/// Takes whatever is in `slot` off.

final class UnequipMascotSlotProvider
    extends
        $FunctionalProvider<
          Future<void> Function(String slot),
          Future<void> Function(String slot),
          Future<void> Function(String slot)
        >
    with $Provider<Future<void> Function(String slot)> {
  /// Takes whatever is in `slot` off.
  UnequipMascotSlotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unequipMascotSlotProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unequipMascotSlotHash();

  @$internal
  @override
  $ProviderElement<Future<void> Function(String slot)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<void> Function(String slot) create(Ref ref) {
    return unequipMascotSlot(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<void> Function(String slot) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<void> Function(String slot)>(
        value,
      ),
    );
  }
}

String _$unequipMascotSlotHash() => r'67478ae137e45c28b40ab9864de7380e720404fa';

/// Keeps the mascot document in Firestore in step with the device while
/// someone is signed in. Owned items are merged both ways. A failed upload is
/// retried with the next change. Watched from the app root.

@ProviderFor(mascotSync)
final mascotSyncProvider = MascotSyncProvider._();

/// Keeps the mascot document in Firestore in step with the device while
/// someone is signed in. Owned items are merged both ways. A failed upload is
/// retried with the next change. Watched from the app root.

final class MascotSyncProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Keeps the mascot document in Firestore in step with the device while
  /// someone is signed in. Owned items are merged both ways. A failed upload is
  /// retried with the next change. Watched from the app root.
  MascotSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mascotSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mascotSyncHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return mascotSync(ref);
  }
}

String _$mascotSyncHash() => r'11d0e488939afeeb158f4248b80458d2308a0749';
