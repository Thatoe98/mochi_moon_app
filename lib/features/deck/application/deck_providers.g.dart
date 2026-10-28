// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(deckRepository)
final deckRepositoryProvider = DeckRepositoryProvider._();

final class DeckRepositoryProvider
    extends $FunctionalProvider<DeckRepository, DeckRepository, DeckRepository>
    with $Provider<DeckRepository> {
  DeckRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deckRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deckRepositoryHash();

  @$internal
  @override
  $ProviderElement<DeckRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeckRepository create(Ref ref) {
    return deckRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeckRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeckRepository>(value),
    );
  }
}

String _$deckRepositoryHash() => r'27c8bf1978599c28271faf7eed30e061aa8524e3';

/// Current time; overridden in tests.

@ProviderFor(clock)
final clockProvider = ClockProvider._();

/// Current time; overridden in tests.

final class ClockProvider
    extends
        $FunctionalProvider<
          DateTime Function(),
          DateTime Function(),
          DateTime Function()
        >
    with $Provider<DateTime Function()> {
  /// Current time; overridden in tests.
  ClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockHash();

  @$internal
  @override
  $ProviderElement<DateTime Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DateTime Function() create(Ref ref) {
    return clock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime Function()>(value),
    );
  }
}

String _$clockHash() => r'3f65ad34ac6fcd532de9004042bdf2ed2bd85b13';

@ProviderFor(random)
final randomProvider = RandomProvider._();

final class RandomProvider extends $FunctionalProvider<Random, Random, Random>
    with $Provider<Random> {
  RandomProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'randomProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$randomHash();

  @$internal
  @override
  $ProviderElement<Random> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Random create(Ref ref) {
    return random(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Random value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Random>(value),
    );
  }
}

String _$randomHash() => r'83ff04d9c2bda3b7d29c4393f76230f33f8c6839';

/// Cards per day on the free plan. Premium (M4) overrides this.

@ProviderFor(dailyCardLimit)
final dailyCardLimitProvider = DailyCardLimitProvider._();

/// Cards per day on the free plan. Premium (M4) overrides this.

final class DailyCardLimitProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Cards per day on the free plan. Premium (M4) overrides this.
  DailyCardLimitProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyCardLimitProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyCardLimitHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return dailyCardLimit(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$dailyCardLimitHash() => r'9c65c58451c8b88609843282b190c106f55b6c5b';

@ProviderFor(Deck)
final deckProvider = DeckProvider._();

final class DeckProvider extends $AsyncNotifierProvider<Deck, DeckState> {
  DeckProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deckProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deckHash();

  @$internal
  @override
  Deck create() => Deck();
}

String _$deckHash() => r'd342e32cb89fc0e501672dbc1641babddc861350';

abstract class _$Deck extends $AsyncNotifier<DeckState> {
  FutureOr<DeckState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<DeckState>, DeckState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DeckState>, DeckState>,
              AsyncValue<DeckState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
