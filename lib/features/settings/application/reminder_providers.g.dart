// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reminderSettingsRepository)
final reminderSettingsRepositoryProvider =
    ReminderSettingsRepositoryProvider._();

final class ReminderSettingsRepositoryProvider
    extends
        $FunctionalProvider<
          ReminderSettingsRepository,
          ReminderSettingsRepository,
          ReminderSettingsRepository
        >
    with $Provider<ReminderSettingsRepository> {
  ReminderSettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderSettingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderSettingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReminderSettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReminderSettingsRepository create(Ref ref) {
    return reminderSettingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReminderSettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReminderSettingsRepository>(value),
    );
  }
}

String _$reminderSettingsRepositoryHash() =>
    r'2063937f5a3d0cdfdc4cd312c7a1c4222cb40395';

@ProviderFor(reminderScheduler)
final reminderSchedulerProvider = ReminderSchedulerProvider._();

final class ReminderSchedulerProvider
    extends
        $FunctionalProvider<
          ReminderScheduler,
          ReminderScheduler,
          ReminderScheduler
        >
    with $Provider<ReminderScheduler> {
  ReminderSchedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderSchedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderSchedulerHash();

  @$internal
  @override
  $ProviderElement<ReminderScheduler> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReminderScheduler create(Ref ref) {
    return reminderScheduler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReminderScheduler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReminderScheduler>(value),
    );
  }
}

String _$reminderSchedulerHash() => r'a6e729e7974386505e81d2b0c35b7d39e324905b';

/// Language of the notification text: Burmese when the device uses it,
/// English otherwise. Overridden in tests.

@ProviderFor(reminderLanguage)
final reminderLanguageProvider = ReminderLanguageProvider._();

/// Language of the notification text: Burmese when the device uses it,
/// English otherwise. Overridden in tests.

final class ReminderLanguageProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Language of the notification text: Burmese when the device uses it,
  /// English otherwise. Overridden in tests.
  ReminderLanguageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderLanguageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderLanguageHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return reminderLanguage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$reminderLanguageHash() => r'4582c502da162bf21e826f4c8a87709e490ffb53';

/// The user's reminder choice, kept in sync with what is scheduled.

@ProviderFor(ReminderController)
final reminderControllerProvider = ReminderControllerProvider._();

/// The user's reminder choice, kept in sync with what is scheduled.
final class ReminderControllerProvider
    extends $AsyncNotifierProvider<ReminderController, ReminderSettings> {
  /// The user's reminder choice, kept in sync with what is scheduled.
  ReminderControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderControllerHash();

  @$internal
  @override
  ReminderController create() => ReminderController();
}

String _$reminderControllerHash() =>
    r'7f5069ee101ce18337eabf8920e067c990f6b6e4';

/// The user's reminder choice, kept in sync with what is scheduled.

abstract class _$ReminderController extends $AsyncNotifier<ReminderSettings> {
  FutureOr<ReminderSettings> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ReminderSettings>, ReminderSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ReminderSettings>, ReminderSettings>,
              AsyncValue<ReminderSettings>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Re-plans the reminder window once per app run; watched from the app root.

@ProviderFor(reminderSync)
final reminderSyncProvider = ReminderSyncProvider._();

/// Re-plans the reminder window once per app run; watched from the app root.

final class ReminderSyncProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Re-plans the reminder window once per app run; watched from the app root.
  ReminderSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderSyncHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return reminderSync(ref);
  }
}

String _$reminderSyncHash() => r'5bf8b18a125c11af96d3dc43d4b25f9de84acc62';
