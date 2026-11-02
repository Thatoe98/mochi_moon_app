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

/// Where the counters are copied to, or null when Firebase did not start.

@ProviderFor(deckCountersRemote)
final deckCountersRemoteProvider = DeckCountersRemoteProvider._();

/// Where the counters are copied to, or null when Firebase did not start.

final class DeckCountersRemoteProvider
    extends
        $FunctionalProvider<
          DeckCountersRemote?,
          DeckCountersRemote?,
          DeckCountersRemote?
        >
    with $Provider<DeckCountersRemote?> {
  /// Where the counters are copied to, or null when Firebase did not start.
  DeckCountersRemoteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deckCountersRemoteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deckCountersRemoteHash();

  @$internal
  @override
  $ProviderElement<DeckCountersRemote?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeckCountersRemote? create(Ref ref) {
    return deckCountersRemote(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeckCountersRemote? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeckCountersRemote?>(value),
    );
  }
}

String _$deckCountersRemoteHash() =>
    r'9c6c3e34e8cf842f6130a6ae93309c67e909058d';

/// Copies the streak and today's count to Firestore while someone is signed
/// in: once when the app opens and again after every swipe or undo. The local
/// history stays the source of truth. A failed upload is retried with the next
/// change. Watched from the app root.

@ProviderFor(deckSync)
final deckSyncProvider = DeckSyncProvider._();

/// Copies the streak and today's count to Firestore while someone is signed
/// in: once when the app opens and again after every swipe or undo. The local
/// history stays the source of truth. A failed upload is retried with the next
/// change. Watched from the app root.

final class DeckSyncProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Copies the streak and today's count to Firestore while someone is signed
  /// in: once when the app opens and again after every swipe or undo. The local
  /// history stays the source of truth. A failed upload is retried with the next
  /// change. Watched from the app root.
  DeckSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deckSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deckSyncHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return deckSync(ref);
  }
}

String _$deckSyncHash() => r'b933c581b865a64847b6d5d9f52fc4548fbdbe22';

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

/// New cards a day from the ritual and the deck (PRD §6.2): five on the free
/// plan, none (null) with Premium. Sample, journey-day and hard-day cards do
/// not use it up.

@ProviderFor(dailyCardLimit)
final dailyCardLimitProvider = DailyCardLimitProvider._();

/// New cards a day from the ritual and the deck (PRD §6.2): five on the free
/// plan, none (null) with Premium. Sample, journey-day and hard-day cards do
/// not use it up.

final class DailyCardLimitProvider extends $FunctionalProvider<int?, int?, int?>
    with $Provider<int?> {
  /// New cards a day from the ritual and the deck (PRD §6.2): five on the free
  /// plan, none (null) with Premium. Sample, journey-day and hard-day cards do
  /// not use it up.
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
  $ProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int? create(Ref ref) {
    return dailyCardLimit(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$dailyCardLimitHash() => r'f3ab5fff07f45359226f31def5eee5483f2d1e73';

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

String _$deckHash() => r'5fe5c8854a38e60a940da01736196943d1c3afa2';

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
