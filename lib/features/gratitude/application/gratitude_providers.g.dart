// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gratitude_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gratitudeRepository)
final gratitudeRepositoryProvider = GratitudeRepositoryProvider._();

final class GratitudeRepositoryProvider
    extends
        $FunctionalProvider<
          GratitudeRepository,
          GratitudeRepository,
          GratitudeRepository
        >
    with $Provider<GratitudeRepository> {
  GratitudeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gratitudeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gratitudeRepositoryHash();

  @$internal
  @override
  $ProviderElement<GratitudeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GratitudeRepository create(Ref ref) {
    return gratitudeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GratitudeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GratitudeRepository>(value),
    );
  }
}

String _$gratitudeRepositoryHash() =>
    r'bfec1d9bfb8d2e421835743b933098ef74d32c8f';

/// The Firestore copy, or null when Firebase did not start.

@ProviderFor(gratitudeRemote)
final gratitudeRemoteProvider = GratitudeRemoteProvider._();

/// The Firestore copy, or null when Firebase did not start.

final class GratitudeRemoteProvider
    extends
        $FunctionalProvider<
          GratitudeRemote?,
          GratitudeRemote?,
          GratitudeRemote?
        >
    with $Provider<GratitudeRemote?> {
  /// The Firestore copy, or null when Firebase did not start.
  GratitudeRemoteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gratitudeRemoteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gratitudeRemoteHash();

  @$internal
  @override
  $ProviderElement<GratitudeRemote?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GratitudeRemote? create(Ref ref) {
    return gratitudeRemote(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GratitudeRemote? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GratitudeRemote?>(value),
    );
  }
}

String _$gratitudeRemoteHash() => r'1c9791d89ffd1b99a18d601d9cd8d277b008c4b0';

/// Every entry, newest first.

@ProviderFor(gratitudeEntries)
final gratitudeEntriesProvider = GratitudeEntriesProvider._();

/// Every entry, newest first.

final class GratitudeEntriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GratitudeNote>>,
          List<GratitudeNote>,
          Stream<List<GratitudeNote>>
        >
    with
        $FutureModifier<List<GratitudeNote>>,
        $StreamProvider<List<GratitudeNote>> {
  /// Every entry, newest first.
  GratitudeEntriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gratitudeEntriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gratitudeEntriesHash();

  @$internal
  @override
  $StreamProviderElement<List<GratitudeNote>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<GratitudeNote>> create(Ref ref) {
    return gratitudeEntries(ref);
  }
}

String _$gratitudeEntriesHash() => r'88be2ae5782365cf9093b3ba5275f298cd7d881b';

/// How many entries she has written today.

@ProviderFor(gratitudeCountToday)
final gratitudeCountTodayProvider = GratitudeCountTodayProvider._();

/// How many entries she has written today.

final class GratitudeCountTodayProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// How many entries she has written today.
  GratitudeCountTodayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gratitudeCountTodayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gratitudeCountTodayHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return gratitudeCountToday(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$gratitudeCountTodayHash() =>
    r'5cc08b19bae7abe8c38143177c61ad09f8cfedee';

/// Adds today's entry. Returns why it was not added, or null when it was.
/// The count is read from the store, so two quick taps cannot pass the limit.

@ProviderFor(addGratitude)
final addGratitudeProvider = AddGratitudeProvider._();

/// Adds today's entry. Returns why it was not added, or null when it was.
/// The count is read from the store, so two quick taps cannot pass the limit.

final class AddGratitudeProvider
    extends
        $FunctionalProvider<
          Future<GratitudeRejection?> Function(String text),
          Future<GratitudeRejection?> Function(String text),
          Future<GratitudeRejection?> Function(String text)
        >
    with $Provider<Future<GratitudeRejection?> Function(String text)> {
  /// Adds today's entry. Returns why it was not added, or null when it was.
  /// The count is read from the store, so two quick taps cannot pass the limit.
  AddGratitudeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addGratitudeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addGratitudeHash();

  @$internal
  @override
  $ProviderElement<Future<GratitudeRejection?> Function(String text)>
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Future<GratitudeRejection?> Function(String text) create(Ref ref) {
    return addGratitude(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    Future<GratitudeRejection?> Function(String text) value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<Future<GratitudeRejection?> Function(String text)>(
            value,
          ),
    );
  }
}

String _$addGratitudeHash() => r'c92da884e70c50f5b1b08595562e2c381e5cb38e';

/// Deletes an entry here and, when signed in, in Firestore. If Firestore
/// cannot be reached the copy there comes back with the next sync.

@ProviderFor(deleteGratitude)
final deleteGratitudeProvider = DeleteGratitudeProvider._();

/// Deletes an entry here and, when signed in, in Firestore. If Firestore
/// cannot be reached the copy there comes back with the next sync.

final class DeleteGratitudeProvider
    extends
        $FunctionalProvider<
          Future<void> Function(String id),
          Future<void> Function(String id),
          Future<void> Function(String id)
        >
    with $Provider<Future<void> Function(String id)> {
  /// Deletes an entry here and, when signed in, in Firestore. If Firestore
  /// cannot be reached the copy there comes back with the next sync.
  DeleteGratitudeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteGratitudeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteGratitudeHash();

  @$internal
  @override
  $ProviderElement<Future<void> Function(String id)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<void> Function(String id) create(Ref ref) {
    return deleteGratitude(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<void> Function(String id) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<void> Function(String id)>(
        value,
      ),
    );
  }
}

String _$deleteGratitudeHash() => r'fb2d17266adabdea35b197942f843de3192e5294';

/// Keeps the entries in Firestore in step with the device while someone is
/// signed in: entries only Firestore has are added here, and new ones here are
/// sent. A failed upload is tried again with the next change. Watched from the
/// app root.

@ProviderFor(gratitudeSync)
final gratitudeSyncProvider = GratitudeSyncProvider._();

/// Keeps the entries in Firestore in step with the device while someone is
/// signed in: entries only Firestore has are added here, and new ones here are
/// sent. A failed upload is tried again with the next change. Watched from the
/// app root.

final class GratitudeSyncProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Keeps the entries in Firestore in step with the device while someone is
  /// signed in: entries only Firestore has are added here, and new ones here are
  /// sent. A failed upload is tried again with the next change. Watched from the
  /// app root.
  GratitudeSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gratitudeSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gratitudeSyncHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return gratitudeSync(ref);
  }
}

String _$gratitudeSyncHash() => r'feed6db70861c880eb6086e7192325ab4e43dab4';
