// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reduce_motion_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reduceMotionSettingRepository)
final reduceMotionSettingRepositoryProvider =
    ReduceMotionSettingRepositoryProvider._();

final class ReduceMotionSettingRepositoryProvider
    extends
        $FunctionalProvider<
          ReduceMotionSettingRepository,
          ReduceMotionSettingRepository,
          ReduceMotionSettingRepository
        >
    with $Provider<ReduceMotionSettingRepository> {
  ReduceMotionSettingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reduceMotionSettingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reduceMotionSettingRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReduceMotionSettingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReduceMotionSettingRepository create(Ref ref) {
    return reduceMotionSettingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReduceMotionSettingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReduceMotionSettingRepository>(
        value,
      ),
    );
  }
}

String _$reduceMotionSettingRepositoryHash() =>
    r'0e8d0cd70849507a2685020c20c2e8a9f031ca9b';

/// Whether the user switched "Reduce motion" on, kept in sync with what is
/// saved. The system setting is separate: widgets read it from `MediaQuery`,
/// and the app turns this switch into the same signal (see `app.dart`).

@ProviderFor(ReduceMotionController)
final reduceMotionControllerProvider = ReduceMotionControllerProvider._();

/// Whether the user switched "Reduce motion" on, kept in sync with what is
/// saved. The system setting is separate: widgets read it from `MediaQuery`,
/// and the app turns this switch into the same signal (see `app.dart`).
final class ReduceMotionControllerProvider
    extends $AsyncNotifierProvider<ReduceMotionController, bool> {
  /// Whether the user switched "Reduce motion" on, kept in sync with what is
  /// saved. The system setting is separate: widgets read it from `MediaQuery`,
  /// and the app turns this switch into the same signal (see `app.dart`).
  ReduceMotionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reduceMotionControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reduceMotionControllerHash();

  @$internal
  @override
  ReduceMotionController create() => ReduceMotionController();
}

String _$reduceMotionControllerHash() =>
    r'29109de7ca7695a2dc265774ee96c3931d6b486b';

/// Whether the user switched "Reduce motion" on, kept in sync with what is
/// saved. The system setting is separate: widgets read it from `MediaQuery`,
/// and the app turns this switch into the same signal (see `app.dart`).

abstract class _$ReduceMotionController extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
