// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ritual_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ritualProgressRepository)
final ritualProgressRepositoryProvider = RitualProgressRepositoryProvider._();

final class RitualProgressRepositoryProvider
    extends
        $FunctionalProvider<
          RitualProgressRepository,
          RitualProgressRepository,
          RitualProgressRepository
        >
    with $Provider<RitualProgressRepository> {
  RitualProgressRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ritualProgressRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ritualProgressRepositoryHash();

  @$internal
  @override
  $ProviderElement<RitualProgressRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RitualProgressRepository create(Ref ref) {
    return ritualProgressRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RitualProgressRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RitualProgressRepository>(value),
    );
  }
}

String _$ritualProgressRepositoryHash() =>
    r'cf375ed987fba151fcaec0e95e9a5fe3d3d591da';

/// Today's daily ritual (PRD §6.15): mood, three cards, a gratitude line and
/// a celebration. It resumes at the same step when she leaves and returns the
/// same day, and starts again when the day turns.

@ProviderFor(RitualController)
final ritualControllerProvider = RitualControllerProvider._();

/// Today's daily ritual (PRD §6.15): mood, three cards, a gratitude line and
/// a celebration. It resumes at the same step when she leaves and returns the
/// same day, and starts again when the day turns.
final class RitualControllerProvider
    extends $AsyncNotifierProvider<RitualController, RitualState> {
  /// Today's daily ritual (PRD §6.15): mood, three cards, a gratitude line and
  /// a celebration. It resumes at the same step when she leaves and returns the
  /// same day, and starts again when the day turns.
  RitualControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ritualControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ritualControllerHash();

  @$internal
  @override
  RitualController create() => RitualController();
}

String _$ritualControllerHash() => r'4e7df1fe3c8e59d54293b8ee8acf2177d460227d';

/// Today's daily ritual (PRD §6.15): mood, three cards, a gratitude line and
/// a celebration. It resumes at the same step when she leaves and returns the
/// same day, and starts again when the day turns.

abstract class _$RitualController extends $AsyncNotifier<RitualState> {
  FutureOr<RitualState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<RitualState>, RitualState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<RitualState>, RitualState>,
              AsyncValue<RitualState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
