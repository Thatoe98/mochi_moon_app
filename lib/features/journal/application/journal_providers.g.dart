// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(journalRepository)
final journalRepositoryProvider = JournalRepositoryProvider._();

final class JournalRepositoryProvider
    extends
        $FunctionalProvider<
          JournalRepository,
          JournalRepository,
          JournalRepository
        >
    with $Provider<JournalRepository> {
  JournalRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'journalRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$journalRepositoryHash();

  @$internal
  @override
  $ProviderElement<JournalRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  JournalRepository create(Ref ref) {
    return journalRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JournalRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JournalRepository>(value),
    );
  }
}

String _$journalRepositoryHash() => r'bda6d81166377177c732cbe4655e44b10d42ca9f';

/// The Firestore copy, or null when Firebase did not start.

@ProviderFor(journalRemote)
final journalRemoteProvider = JournalRemoteProvider._();

/// The Firestore copy, or null when Firebase did not start.

final class JournalRemoteProvider
    extends $FunctionalProvider<JournalRemote?, JournalRemote?, JournalRemote?>
    with $Provider<JournalRemote?> {
  /// The Firestore copy, or null when Firebase did not start.
  JournalRemoteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'journalRemoteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$journalRemoteHash();

  @$internal
  @override
  $ProviderElement<JournalRemote?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  JournalRemote? create(Ref ref) {
    return journalRemote(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JournalRemote? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JournalRemote?>(value),
    );
  }
}

String _$journalRemoteHash() => r'46f3b8792328f935f0e86831986790267cf58419';

/// Keeps the journal in Firestore in step with the device while someone is
/// signed in. The device stays the source of truth, so every change is applied
/// here first and mirrored afterwards.
///
/// On start, cards that only Firestore has (a reinstall, another phone) are
/// added here; the rest of the changes are mirrored as they happen. A removal
/// that could not be sent is not remembered, so that card comes back the next
/// time the app opens. Watched from the app root.

@ProviderFor(journalSync)
final journalSyncProvider = JournalSyncProvider._();

/// Keeps the journal in Firestore in step with the device while someone is
/// signed in. The device stays the source of truth, so every change is applied
/// here first and mirrored afterwards.
///
/// On start, cards that only Firestore has (a reinstall, another phone) are
/// added here; the rest of the changes are mirrored as they happen. A removal
/// that could not be sent is not remembered, so that card comes back the next
/// time the app opens. Watched from the app root.

final class JournalSyncProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Keeps the journal in Firestore in step with the device while someone is
  /// signed in. The device stays the source of truth, so every change is applied
  /// here first and mirrored afterwards.
  ///
  /// On start, cards that only Firestore has (a reinstall, another phone) are
  /// added here; the rest of the changes are mirrored as they happen. A removal
  /// that could not be sent is not remembered, so that card comes back the next
  /// time the app opens. Watched from the app root.
  JournalSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'journalSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$journalSyncHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return journalSync(ref);
  }
}

String _$journalSyncHash() => r'e1693cbc1f656d2e156d52879c7db992ba0b6e9c';

/// Saved cards, newest first. Rebuilds on each visit so it never shows a
/// stale list after the deck saved something.

@ProviderFor(Journal)
final journalProvider = JournalProvider._();

/// Saved cards, newest first. Rebuilds on each visit so it never shows a
/// stale list after the deck saved something.
final class JournalProvider
    extends $AsyncNotifierProvider<Journal, List<JournalItem>> {
  /// Saved cards, newest first. Rebuilds on each visit so it never shows a
  /// stale list after the deck saved something.
  JournalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'journalProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$journalHash();

  @$internal
  @override
  Journal create() => Journal();
}

String _$journalHash() => r'372928ae565c6cc9133fe124a13714adf4c6876c';

/// Saved cards, newest first. Rebuilds on each visit so it never shows a
/// stale list after the deck saved something.

abstract class _$Journal extends $AsyncNotifier<List<JournalItem>> {
  FutureOr<List<JournalItem>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<JournalItem>>, List<JournalItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<JournalItem>>, List<JournalItem>>,
              AsyncValue<List<JournalItem>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
