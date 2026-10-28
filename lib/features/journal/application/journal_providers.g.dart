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
