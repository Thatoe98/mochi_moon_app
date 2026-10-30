// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_deletion_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The server deletes the account when the build has a Readings API; without
/// one the app deletes the Firestore data and the Auth user itself.

@ProviderFor(accountRemote)
final accountRemoteProvider = AccountRemoteProvider._();

/// The server deletes the account when the build has a Readings API; without
/// one the app deletes the Firestore data and the Auth user itself.

final class AccountRemoteProvider
    extends $FunctionalProvider<AccountRemote, AccountRemote, AccountRemote>
    with $Provider<AccountRemote> {
  /// The server deletes the account when the build has a Readings API; without
  /// one the app deletes the Firestore data and the Auth user itself.
  AccountRemoteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountRemoteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountRemoteHash();

  @$internal
  @override
  $ProviderElement<AccountRemote> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AccountRemote create(Ref ref) {
    return accountRemote(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountRemote value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountRemote>(value),
    );
  }
}

String _$accountRemoteHash() => r'afbed4fe93d14c15e54832d0820934256b705ad9';

@ProviderFor(localDataEraser)
final localDataEraserProvider = LocalDataEraserProvider._();

final class LocalDataEraserProvider
    extends
        $FunctionalProvider<LocalDataEraser, LocalDataEraser, LocalDataEraser>
    with $Provider<LocalDataEraser> {
  LocalDataEraserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localDataEraserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localDataEraserHash();

  @$internal
  @override
  $ProviderElement<LocalDataEraser> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocalDataEraser create(Ref ref) {
    return localDataEraser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalDataEraser value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalDataEraser>(value),
    );
  }
}

String _$localDataEraserHash() => r'7b931eca00a168d45439d815e728829bb1a958ce';

/// Deletes the account from Mochi Moon and wipes this phone. The state is
/// whether a deletion is running.
///
/// The order matters: confirm the Google account first, so backing out of it
/// leaves everything as it was; then cloud data (the rules need the user
/// signed in), then the Auth user, then the local data. The sync providers stop once the
/// user is gone, so nothing recreates the cloud copy afterwards. Signed out,
/// only the local wipe runs, which makes this a full reset for testing.
///
/// With the Readings API the server removes the cloud data and the Auth user
/// in one call, so the app only signs out afterwards.

@ProviderFor(AccountDeletion)
final accountDeletionProvider = AccountDeletionProvider._();

/// Deletes the account from Mochi Moon and wipes this phone. The state is
/// whether a deletion is running.
///
/// The order matters: confirm the Google account first, so backing out of it
/// leaves everything as it was; then cloud data (the rules need the user
/// signed in), then the Auth user, then the local data. The sync providers stop once the
/// user is gone, so nothing recreates the cloud copy afterwards. Signed out,
/// only the local wipe runs, which makes this a full reset for testing.
///
/// With the Readings API the server removes the cloud data and the Auth user
/// in one call, so the app only signs out afterwards.
final class AccountDeletionProvider
    extends $NotifierProvider<AccountDeletion, bool> {
  /// Deletes the account from Mochi Moon and wipes this phone. The state is
  /// whether a deletion is running.
  ///
  /// The order matters: confirm the Google account first, so backing out of it
  /// leaves everything as it was; then cloud data (the rules need the user
  /// signed in), then the Auth user, then the local data. The sync providers stop once the
  /// user is gone, so nothing recreates the cloud copy afterwards. Signed out,
  /// only the local wipe runs, which makes this a full reset for testing.
  ///
  /// With the Readings API the server removes the cloud data and the Auth user
  /// in one call, so the app only signs out afterwards.
  AccountDeletionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountDeletionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountDeletionHash();

  @$internal
  @override
  AccountDeletion create() => AccountDeletion();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$accountDeletionHash() => r'79b1f4fba35663b92df56263b47bff9cd6541472';

/// Deletes the account from Mochi Moon and wipes this phone. The state is
/// whether a deletion is running.
///
/// The order matters: confirm the Google account first, so backing out of it
/// leaves everything as it was; then cloud data (the rules need the user
/// signed in), then the Auth user, then the local data. The sync providers stop once the
/// user is gone, so nothing recreates the cloud copy afterwards. Signed out,
/// only the local wipe runs, which makes this a full reset for testing.
///
/// With the Readings API the server removes the cloud data and the Auth user
/// in one call, so the app only signs out afterwards.

abstract class _$AccountDeletion extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
