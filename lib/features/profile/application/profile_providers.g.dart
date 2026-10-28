// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(profileRepository)
final profileRepositoryProvider = ProfileRepositoryProvider._();

final class ProfileRepositoryProvider
    extends
        $FunctionalProvider<
          ProfileRepository,
          ProfileRepository,
          ProfileRepository
        >
    with $Provider<ProfileRepository> {
  ProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileRepository create(Ref ref) {
    return profileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileRepository>(value),
    );
  }
}

String _$profileRepositoryHash() => r'9f979afb3a9ca342b2a8f56235f5efc5fab09483';

/// The Firestore copy, or null when Firebase did not start.

@ProviderFor(profileRemote)
final profileRemoteProvider = ProfileRemoteProvider._();

/// The Firestore copy, or null when Firebase did not start.

final class ProfileRemoteProvider
    extends $FunctionalProvider<ProfileRemote?, ProfileRemote?, ProfileRemote?>
    with $Provider<ProfileRemote?> {
  /// The Firestore copy, or null when Firebase did not start.
  ProfileRemoteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRemoteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRemoteHash();

  @$internal
  @override
  $ProviderElement<ProfileRemote?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProfileRemote? create(Ref ref) {
    return profileRemote(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileRemote? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileRemote?>(value),
    );
  }
}

String _$profileRemoteHash() => r'3674670b5a498ca3588a8d5c4d8313eb382694e6';

/// The user's profile, local first: it is saved on the device, then copied to
/// Firestore when someone is signed in.

@ProviderFor(ProfileController)
final profileControllerProvider = ProfileControllerProvider._();

/// The user's profile, local first: it is saved on the device, then copied to
/// Firestore when someone is signed in.
final class ProfileControllerProvider
    extends $AsyncNotifierProvider<ProfileController, UserProfile?> {
  /// The user's profile, local first: it is saved on the device, then copied to
  /// Firestore when someone is signed in.
  ProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileControllerHash();

  @$internal
  @override
  ProfileController create() => ProfileController();
}

String _$profileControllerHash() => r'13b8354d9b470f38df7c4920735288615c79bcee';

/// The user's profile, local first: it is saved on the device, then copied to
/// Firestore when someone is signed in.

abstract class _$ProfileController extends $AsyncNotifier<UserProfile?> {
  FutureOr<UserProfile?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserProfile?>, UserProfile?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserProfile?>, UserProfile?>,
              AsyncValue<UserProfile?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Reconciles the profile whenever an account is signed in, so a failed
/// upload is retried the next time the app opens. Watched from the app root.

@ProviderFor(profileSync)
final profileSyncProvider = ProfileSyncProvider._();

/// Reconciles the profile whenever an account is signed in, so a failed
/// upload is retried the next time the app opens. Watched from the app root.

final class ProfileSyncProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Reconciles the profile whenever an account is signed in, so a failed
  /// upload is retried the next time the app opens. Watched from the app root.
  ProfileSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileSyncHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return profileSync(ref);
  }
}

String _$profileSyncHash() => r'32e66053eca48b7a291826f0156c8b7a85eb1d87';
