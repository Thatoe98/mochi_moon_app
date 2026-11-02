// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(onboardingRepository)
final onboardingRepositoryProvider = OnboardingRepositoryProvider._();

final class OnboardingRepositoryProvider
    extends
        $FunctionalProvider<
          OnboardingRepository,
          OnboardingRepository,
          OnboardingRepository
        >
    with $Provider<OnboardingRepository> {
  OnboardingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingRepositoryHash();

  @$internal
  @override
  $ProviderElement<OnboardingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OnboardingRepository create(Ref ref) {
    return onboardingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardingRepository>(value),
    );
  }
}

String _$onboardingRepositoryHash() =>
    r'3a36fc9540cd318153b1e14fb26c3455f3941d72';

/// The saved first-run flag, read before the app starts so the router knows
/// where to begin. `bootstrap` overrides it; so do tests.

@ProviderFor(initialOnboardingComplete)
final initialOnboardingCompleteProvider = InitialOnboardingCompleteProvider._();

/// The saved first-run flag, read before the app starts so the router knows
/// where to begin. `bootstrap` overrides it; so do tests.

final class InitialOnboardingCompleteProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// The saved first-run flag, read before the app starts so the router knows
  /// where to begin. `bootstrap` overrides it; so do tests.
  InitialOnboardingCompleteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'initialOnboardingCompleteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$initialOnboardingCompleteHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return initialOnboardingComplete(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$initialOnboardingCompleteHash() =>
    r'6f8546e81eb3fc67c22cd41fa86bba683ee92d46';

/// Whether the first-run flow is done. The router watches it.

@ProviderFor(OnboardingComplete)
final onboardingCompleteProvider = OnboardingCompleteProvider._();

/// Whether the first-run flow is done. The router watches it.
final class OnboardingCompleteProvider
    extends $NotifierProvider<OnboardingComplete, bool> {
  /// Whether the first-run flow is done. The router watches it.
  OnboardingCompleteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingCompleteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingCompleteHash();

  @$internal
  @override
  OnboardingComplete create() => OnboardingComplete();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$onboardingCompleteHash() =>
    r'b830cc59faf6af079e2e40c69b87e4450d5c0e99';

/// Whether the first-run flow is done. The router watches it.

abstract class _$OnboardingComplete extends $Notifier<bool> {
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

/// The three cards shown before sign-in. Swipes go through the deck
/// repository like any other, so a saved sample card is already in the journal.

@ProviderFor(SampleDeck)
final sampleDeckProvider = SampleDeckProvider._();

/// The three cards shown before sign-in. Swipes go through the deck
/// repository like any other, so a saved sample card is already in the journal.
final class SampleDeckProvider
    extends $AsyncNotifierProvider<SampleDeck, SampleDeckState> {
  /// The three cards shown before sign-in. Swipes go through the deck
  /// repository like any other, so a saved sample card is already in the journal.
  SampleDeckProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sampleDeckProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sampleDeckHash();

  @$internal
  @override
  SampleDeck create() => SampleDeck();
}

String _$sampleDeckHash() => r'89a41d076d854fe06641618e9eede09fff2d7e17';

/// The three cards shown before sign-in. Swipes go through the deck
/// repository like any other, so a saved sample card is already in the journal.

abstract class _$SampleDeck extends $AsyncNotifier<SampleDeckState> {
  FutureOr<SampleDeckState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SampleDeckState>, SampleDeckState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SampleDeckState>, SampleDeckState>,
              AsyncValue<SampleDeckState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
