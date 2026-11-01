// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(journeyRepository)
final journeyRepositoryProvider = JourneyRepositoryProvider._();

final class JourneyRepositoryProvider
    extends
        $FunctionalProvider<
          JourneyRepository,
          JourneyRepository,
          JourneyRepository
        >
    with $Provider<JourneyRepository> {
  JourneyRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'journeyRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$journeyRepositoryHash();

  @$internal
  @override
  $ProviderElement<JourneyRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  JourneyRepository create(Ref ref) {
    return journeyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JourneyRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JourneyRepository>(value),
    );
  }
}

String _$journeyRepositoryHash() => r'77efe7f640869f193506d1547cfd125efe7a6459';

/// The Firestore copy, or null when Firebase did not start.

@ProviderFor(journeyRemote)
final journeyRemoteProvider = JourneyRemoteProvider._();

/// The Firestore copy, or null when Firebase did not start.

final class JourneyRemoteProvider
    extends $FunctionalProvider<JourneyRemote?, JourneyRemote?, JourneyRemote?>
    with $Provider<JourneyRemote?> {
  /// The Firestore copy, or null when Firebase did not start.
  JourneyRemoteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'journeyRemoteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$journeyRemoteHash();

  @$internal
  @override
  $ProviderElement<JourneyRemote?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  JourneyRemote? create(Ref ref) {
    return journeyRemote(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JourneyRemote? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JourneyRemote?>(value),
    );
  }
}

String _$journeyRemoteHash() => r'54b54f2b2383831a3d97359dc4af610318e3d5cc';

/// Every journey she has started.

@ProviderFor(journeyProgressList)
final journeyProgressListProvider = JourneyProgressListProvider._();

/// Every journey she has started.

final class JourneyProgressListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<JourneyProgress>>,
          List<JourneyProgress>,
          Stream<List<JourneyProgress>>
        >
    with
        $FutureModifier<List<JourneyProgress>>,
        $StreamProvider<List<JourneyProgress>> {
  /// Every journey she has started.
  JourneyProgressListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'journeyProgressListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$journeyProgressListHash();

  @$internal
  @override
  $StreamProviderElement<List<JourneyProgress>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<JourneyProgress>> create(Ref ref) {
    return journeyProgressList(ref);
  }
}

String _$journeyProgressListHash() =>
    r'425f96cdbb85a08113704c0443ac0ef5e862acb6';

/// The journeys she can see, with the one she is on first.

@ProviderFor(journeyById)
final journeyByIdProvider = JourneyByIdFamily._();

/// The journeys she can see, with the one she is on first.

final class JourneyByIdProvider
    extends
        $FunctionalProvider<AsyncValue<Journey?>, Journey?, FutureOr<Journey?>>
    with $FutureModifier<Journey?>, $FutureProvider<Journey?> {
  /// The journeys she can see, with the one she is on first.
  JourneyByIdProvider._({
    required JourneyByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'journeyByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$journeyByIdHash();

  @override
  String toString() {
    return r'journeyByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Journey?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Journey?> create(Ref ref) {
    final argument = this.argument as String;
    return journeyById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is JourneyByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$journeyByIdHash() => r'2c94062d159d8392c47e93a1819473bd35b46969';

/// The journeys she can see, with the one she is on first.

final class JourneyByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Journey?>, String> {
  JourneyByIdFamily._()
    : super(
        retry: null,
        name: r'journeyByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The journeys she can see, with the one she is on first.

  JourneyByIdProvider call(String journeyId) =>
      JourneyByIdProvider._(argument: journeyId, from: this);

  @override
  String toString() => r'journeyByIdProvider';
}

/// Day `day` of `journeyId` with its cards and quest looked up, or null.

@ProviderFor(journeyDay)
final journeyDayProvider = JourneyDayFamily._();

/// Day `day` of `journeyId` with its cards and quest looked up, or null.

final class JourneyDayProvider
    extends
        $FunctionalProvider<
          AsyncValue<ResolvedJourneyDay?>,
          ResolvedJourneyDay?,
          FutureOr<ResolvedJourneyDay?>
        >
    with
        $FutureModifier<ResolvedJourneyDay?>,
        $FutureProvider<ResolvedJourneyDay?> {
  /// Day `day` of `journeyId` with its cards and quest looked up, or null.
  JourneyDayProvider._({
    required JourneyDayFamily super.from,
    required (String, int) super.argument,
  }) : super(
         retry: null,
         name: r'journeyDayProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$journeyDayHash();

  @override
  String toString() {
    return r'journeyDayProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<ResolvedJourneyDay?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ResolvedJourneyDay?> create(Ref ref) {
    final argument = this.argument as (String, int);
    return journeyDay(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is JourneyDayProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$journeyDayHash() => r'aece03fc4ea20f9b3ee8d54b3af9511c0f5c2552';

/// Day `day` of `journeyId` with its cards and quest looked up, or null.

final class JourneyDayFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<ResolvedJourneyDay?>,
          (String, int)
        > {
  JourneyDayFamily._()
    : super(
        retry: null,
        name: r'journeyDayProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Day `day` of `journeyId` with its cards and quest looked up, or null.

  JourneyDayProvider call(String journeyId, int day) =>
      JourneyDayProvider._(argument: (journeyId, day), from: this);

  @override
  String toString() => r'journeyDayProvider';
}

/// Starts the journey `journeyId`. Does nothing when another journey is still
/// going (one at a time) or the id is unknown. A finished journey can be
/// started again.

@ProviderFor(startJourneyAction)
final startJourneyActionProvider = StartJourneyActionProvider._();

/// Starts the journey `journeyId`. Does nothing when another journey is still
/// going (one at a time) or the id is unknown. A finished journey can be
/// started again.

final class StartJourneyActionProvider
    extends
        $FunctionalProvider<
          Future<void> Function(String journeyId),
          Future<void> Function(String journeyId),
          Future<void> Function(String journeyId)
        >
    with $Provider<Future<void> Function(String journeyId)> {
  /// Starts the journey `journeyId`. Does nothing when another journey is still
  /// going (one at a time) or the id is unknown. A finished journey can be
  /// started again.
  StartJourneyActionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'startJourneyActionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$startJourneyActionHash();

  @$internal
  @override
  $ProviderElement<Future<void> Function(String journeyId)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<void> Function(String journeyId) create(Ref ref) {
    return startJourneyAction(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<void> Function(String journeyId) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<Future<void> Function(String journeyId)>(value),
    );
  }
}

String _$startJourneyActionHash() =>
    r'be57b4d2481fad93722fb9da79e25dde2147d71b';

/// Finishes the current day of `journeyId`, with her optional private
/// reflection. Does nothing when she already finished a day today.

@ProviderFor(completeJourneyDay)
final completeJourneyDayProvider = CompleteJourneyDayProvider._();

/// Finishes the current day of `journeyId`, with her optional private
/// reflection. Does nothing when she already finished a day today.

final class CompleteJourneyDayProvider
    extends
        $FunctionalProvider<
          Future<void> Function(String journeyId, {String? reflection}),
          Future<void> Function(String journeyId, {String? reflection}),
          Future<void> Function(String journeyId, {String? reflection})
        >
    with
        $Provider<
          Future<void> Function(String journeyId, {String? reflection})
        > {
  /// Finishes the current day of `journeyId`, with her optional private
  /// reflection. Does nothing when she already finished a day today.
  CompleteJourneyDayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'completeJourneyDayProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$completeJourneyDayHash();

  @$internal
  @override
  $ProviderElement<
    Future<void> Function(String journeyId, {String? reflection})
  >
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Future<void> Function(String journeyId, {String? reflection}) create(
    Ref ref,
  ) {
    return completeJourneyDay(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    Future<void> Function(String journeyId, {String? reflection}) value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<
            Future<void> Function(String journeyId, {String? reflection})
          >(value),
    );
  }
}

String _$completeJourneyDayHash() =>
    r'8fbf97ba77bf1d5ba4e56dafdef96910fabfe8bf';

/// Keeps the journey progress in Firestore in step with the device while
/// someone is signed in. Progress never goes backwards: a record from
/// Firestore only replaces the local one when it is further along. A failed
/// upload is retried with the next change. Watched from the app root.

@ProviderFor(journeySync)
final journeySyncProvider = JourneySyncProvider._();

/// Keeps the journey progress in Firestore in step with the device while
/// someone is signed in. Progress never goes backwards: a record from
/// Firestore only replaces the local one when it is further along. A failed
/// upload is retried with the next change. Watched from the app root.

final class JourneySyncProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Keeps the journey progress in Firestore in step with the device while
  /// someone is signed in. Progress never goes backwards: a record from
  /// Firestore only replaces the local one when it is further along. A failed
  /// upload is retried with the next change. Watched from the app root.
  JourneySyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'journeySyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$journeySyncHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return journeySync(ref);
  }
}

String _$journeySyncHash() => r'4160bb458feec6d2db7e4463084d633c0c35b8c2';
