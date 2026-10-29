// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retrograde_alert_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(retrogradeAlertSettingsRepository)
final retrogradeAlertSettingsRepositoryProvider =
    RetrogradeAlertSettingsRepositoryProvider._();

final class RetrogradeAlertSettingsRepositoryProvider
    extends
        $FunctionalProvider<
          RetrogradeAlertSettingsRepository,
          RetrogradeAlertSettingsRepository,
          RetrogradeAlertSettingsRepository
        >
    with $Provider<RetrogradeAlertSettingsRepository> {
  RetrogradeAlertSettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'retrogradeAlertSettingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$retrogradeAlertSettingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<RetrogradeAlertSettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RetrogradeAlertSettingsRepository create(Ref ref) {
    return retrogradeAlertSettingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RetrogradeAlertSettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RetrogradeAlertSettingsRepository>(
        value,
      ),
    );
  }
}

String _$retrogradeAlertSettingsRepositoryHash() =>
    r'a8901d79efaf585f2afcef82b59f2fafb35cf587';

@ProviderFor(retrogradeAlertScheduler)
final retrogradeAlertSchedulerProvider = RetrogradeAlertSchedulerProvider._();

final class RetrogradeAlertSchedulerProvider
    extends
        $FunctionalProvider<
          RetrogradeAlertScheduler,
          RetrogradeAlertScheduler,
          RetrogradeAlertScheduler
        >
    with $Provider<RetrogradeAlertScheduler> {
  RetrogradeAlertSchedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'retrogradeAlertSchedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$retrogradeAlertSchedulerHash();

  @$internal
  @override
  $ProviderElement<RetrogradeAlertScheduler> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RetrogradeAlertScheduler create(Ref ref) {
    return retrogradeAlertScheduler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RetrogradeAlertScheduler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RetrogradeAlertScheduler>(value),
    );
  }
}

String _$retrogradeAlertSchedulerHash() =>
    r'b1176ec577e4af908b0c37717a5712aec2a689e4';

/// The planets the user wants a heads-up for, kept in sync with what is
/// scheduled. Notification permission comes from the reminder scheduler, the
/// one place the app asks for it.

@ProviderFor(RetrogradeAlertController)
final retrogradeAlertControllerProvider = RetrogradeAlertControllerProvider._();

/// The planets the user wants a heads-up for, kept in sync with what is
/// scheduled. Notification permission comes from the reminder scheduler, the
/// one place the app asks for it.
final class RetrogradeAlertControllerProvider
    extends $AsyncNotifierProvider<RetrogradeAlertController, Set<Body>> {
  /// The planets the user wants a heads-up for, kept in sync with what is
  /// scheduled. Notification permission comes from the reminder scheduler, the
  /// one place the app asks for it.
  RetrogradeAlertControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'retrogradeAlertControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$retrogradeAlertControllerHash();

  @$internal
  @override
  RetrogradeAlertController create() => RetrogradeAlertController();
}

String _$retrogradeAlertControllerHash() =>
    r'3fcebbee8b6f423a47b8caa8144509377e6b4212';

/// The planets the user wants a heads-up for, kept in sync with what is
/// scheduled. Notification permission comes from the reminder scheduler, the
/// one place the app asks for it.

abstract class _$RetrogradeAlertController extends $AsyncNotifier<Set<Body>> {
  FutureOr<Set<Body>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Set<Body>>, Set<Body>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Set<Body>>, Set<Body>>,
              AsyncValue<Set<Body>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Re-plans the alerts once per app run and again when the app language
/// changes, so the text follows it. A calendar that cannot be built leaves the
/// previous alerts in place rather than failing the app. Watched from the app
/// root.

@ProviderFor(retrogradeAlertSync)
final retrogradeAlertSyncProvider = RetrogradeAlertSyncProvider._();

/// Re-plans the alerts once per app run and again when the app language
/// changes, so the text follows it. A calendar that cannot be built leaves the
/// previous alerts in place rather than failing the app. Watched from the app
/// root.

final class RetrogradeAlertSyncProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Re-plans the alerts once per app run and again when the app language
  /// changes, so the text follows it. A calendar that cannot be built leaves the
  /// previous alerts in place rather than failing the app. Watched from the app
  /// root.
  RetrogradeAlertSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'retrogradeAlertSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$retrogradeAlertSyncHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return retrogradeAlertSync(ref);
  }
}

String _$retrogradeAlertSyncHash() =>
    r'e38f573382a756cd7561c5dda61a2ea66a47a3fa';
