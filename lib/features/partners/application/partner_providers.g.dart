// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(partnerRepository)
final partnerRepositoryProvider = PartnerRepositoryProvider._();

final class PartnerRepositoryProvider
    extends
        $FunctionalProvider<
          PartnerRepository,
          PartnerRepository,
          PartnerRepository
        >
    with $Provider<PartnerRepository> {
  PartnerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'partnerRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$partnerRepositoryHash();

  @$internal
  @override
  $ProviderElement<PartnerRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PartnerRepository create(Ref ref) {
    return partnerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PartnerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PartnerRepository>(value),
    );
  }
}

String _$partnerRepositoryHash() => r'53c87858f71a4f5c851e09f5974cdad384f27d9c';

/// The Firestore copy, or null when Firebase did not start.

@ProviderFor(partnerRemote)
final partnerRemoteProvider = PartnerRemoteProvider._();

/// The Firestore copy, or null when Firebase did not start.

final class PartnerRemoteProvider
    extends $FunctionalProvider<PartnerRemote?, PartnerRemote?, PartnerRemote?>
    with $Provider<PartnerRemote?> {
  /// The Firestore copy, or null when Firebase did not start.
  PartnerRemoteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'partnerRemoteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$partnerRemoteHash();

  @$internal
  @override
  $ProviderElement<PartnerRemote?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PartnerRemote? create(Ref ref) {
    return partnerRemote(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PartnerRemote? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PartnerRemote?>(value),
    );
  }
}

String _$partnerRemoteHash() => r'a512eb19cbd77bc7b6301e97d1700a84ec293818';

/// Makes the id of a new partner. Overridden in tests.

@ProviderFor(partnerIdGenerator)
final partnerIdGeneratorProvider = PartnerIdGeneratorProvider._();

/// Makes the id of a new partner. Overridden in tests.

final class PartnerIdGeneratorProvider
    extends
        $FunctionalProvider<
          String Function(),
          String Function(),
          String Function()
        >
    with $Provider<String Function()> {
  /// Makes the id of a new partner. Overridden in tests.
  PartnerIdGeneratorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'partnerIdGeneratorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$partnerIdGeneratorHash();

  @$internal
  @override
  $ProviderElement<String Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  String Function() create(Ref ref) {
    return partnerIdGenerator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String Function()>(value),
    );
  }
}

String _$partnerIdGeneratorHash() =>
    r'85711419ed43edb9179b9e279ab8cafa59f97cd0';

/// Keeps the partners in Firestore in step with the device while someone is
/// signed in, the same way as the journal: the device is the source of truth,
/// every change is applied here first and mirrored afterwards. Edits are
/// noticed by comparing what was last sent for each partner.
///
/// On start, partners that only Firestore has (a reinstall, another phone) are
/// added here. A removal that could not be sent is not remembered, so that
/// partner comes back the next time the app opens. Watched from the app root.

@ProviderFor(partnerSync)
final partnerSyncProvider = PartnerSyncProvider._();

/// Keeps the partners in Firestore in step with the device while someone is
/// signed in, the same way as the journal: the device is the source of truth,
/// every change is applied here first and mirrored afterwards. Edits are
/// noticed by comparing what was last sent for each partner.
///
/// On start, partners that only Firestore has (a reinstall, another phone) are
/// added here. A removal that could not be sent is not remembered, so that
/// partner comes back the next time the app opens. Watched from the app root.

final class PartnerSyncProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Keeps the partners in Firestore in step with the device while someone is
  /// signed in, the same way as the journal: the device is the source of truth,
  /// every change is applied here first and mirrored afterwards. Edits are
  /// noticed by comparing what was last sent for each partner.
  ///
  /// On start, partners that only Firestore has (a reinstall, another phone) are
  /// added here. A removal that could not be sent is not remembered, so that
  /// partner comes back the next time the app opens. Watched from the app root.
  PartnerSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'partnerSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$partnerSyncHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return partnerSync(ref);
  }
}

String _$partnerSyncHash() => r'3ba1631ee618609296b112ebe80da34e77cb3acc';

/// The saved partners, oldest first.

@ProviderFor(Partners)
final partnersProvider = PartnersProvider._();

/// The saved partners, oldest first.
final class PartnersProvider
    extends $AsyncNotifierProvider<Partners, List<Partner>> {
  /// The saved partners, oldest first.
  PartnersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'partnersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$partnersHash();

  @$internal
  @override
  Partners create() => Partners();
}

String _$partnersHash() => r'18d1fa99c9769d238315b786e86b4432ac171c9a';

/// The saved partners, oldest first.

abstract class _$Partners extends $AsyncNotifier<List<Partner>> {
  FutureOr<List<Partner>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Partner>>, List<Partner>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Partner>>, List<Partner>>,
              AsyncValue<List<Partner>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Whether one more partner can be saved: false once the Free or Premium
/// limit is reached.

@ProviderFor(canAddPartner)
final canAddPartnerProvider = CanAddPartnerProvider._();

/// Whether one more partner can be saved: false once the Free or Premium
/// limit is reached.

final class CanAddPartnerProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether one more partner can be saved: false once the Free or Premium
  /// limit is reached.
  CanAddPartnerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canAddPartnerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canAddPartnerHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return canAddPartner(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$canAddPartnerHash() => r'3e3b014cddd3813e1b5900410d28de8be3a6ebca';
