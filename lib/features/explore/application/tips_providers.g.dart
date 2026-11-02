// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tips_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tipsRepository)
final tipsRepositoryProvider = TipsRepositoryProvider._();

final class TipsRepositoryProvider
    extends $FunctionalProvider<TipsRepository, TipsRepository, TipsRepository>
    with $Provider<TipsRepository> {
  TipsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tipsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tipsRepositoryHash();

  @$internal
  @override
  $ProviderElement<TipsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TipsRepository create(Ref ref) {
    return tipsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TipsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TipsRepository>(value),
    );
  }
}

String _$tipsRepositoryHash() => r'ce32077b5fe40cf5c33dd0a65bc939b48de85b8a';

/// Whether she has taken (or skipped) the "How Mochi works" tour. Loading
/// until known, so the Today prompt never flashes.

@ProviderFor(TourSeen)
final tourSeenProvider = TourSeenProvider._();

/// Whether she has taken (or skipped) the "How Mochi works" tour. Loading
/// until known, so the Today prompt never flashes.
final class TourSeenProvider extends $AsyncNotifierProvider<TourSeen, bool> {
  /// Whether she has taken (or skipped) the "How Mochi works" tour. Loading
  /// until known, so the Today prompt never flashes.
  TourSeenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tourSeenProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tourSeenHash();

  @$internal
  @override
  TourSeen create() => TourSeen();
}

String _$tourSeenHash() => r'e96edebd10e2dd77c292c53eba294c3dc295d0f9';

/// Whether she has taken (or skipped) the "How Mochi works" tour. Loading
/// until known, so the Today prompt never flashes.

abstract class _$TourSeen extends $AsyncNotifier<bool> {
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

/// The first-time intro sheets on Explore.

@ProviderFor(FeatureIntros)
final featureIntrosProvider = FeatureIntrosProvider._();

/// The first-time intro sheets on Explore.
final class FeatureIntrosProvider
    extends $NotifierProvider<FeatureIntros, void> {
  /// The first-time intro sheets on Explore.
  FeatureIntrosProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'featureIntrosProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$featureIntrosHash();

  @$internal
  @override
  FeatureIntros create() => FeatureIntros();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$featureIntrosHash() => r'3fdc1495d3e4ff704ec278d951024e9c726db8f9';

/// The first-time intro sheets on Explore.

abstract class _$FeatureIntros extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
