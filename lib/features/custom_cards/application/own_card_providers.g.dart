// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'own_card_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ownCardRepository)
final ownCardRepositoryProvider = OwnCardRepositoryProvider._();

final class OwnCardRepositoryProvider
    extends
        $FunctionalProvider<
          OwnCardRepository,
          OwnCardRepository,
          OwnCardRepository
        >
    with $Provider<OwnCardRepository> {
  OwnCardRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ownCardRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ownCardRepositoryHash();

  @$internal
  @override
  $ProviderElement<OwnCardRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OwnCardRepository create(Ref ref) {
    return ownCardRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OwnCardRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OwnCardRepository>(value),
    );
  }
}

String _$ownCardRepositoryHash() => r'8e5dc983f83fcf1477056a7872b0339d63f94cf3';

/// The Firestore copy, or null when Firebase did not start.

@ProviderFor(ownCardRemote)
final ownCardRemoteProvider = OwnCardRemoteProvider._();

/// The Firestore copy, or null when Firebase did not start.

final class OwnCardRemoteProvider
    extends $FunctionalProvider<OwnCardRemote?, OwnCardRemote?, OwnCardRemote?>
    with $Provider<OwnCardRemote?> {
  /// The Firestore copy, or null when Firebase did not start.
  OwnCardRemoteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ownCardRemoteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ownCardRemoteHash();

  @$internal
  @override
  $ProviderElement<OwnCardRemote?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OwnCardRemote? create(Ref ref) {
    return ownCardRemote(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OwnCardRemote? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OwnCardRemote?>(value),
    );
  }
}

String _$ownCardRemoteHash() => r'9f3b49f03e9bc1fb9e1371b529ab334326da38e9';

/// Every card she wrote, newest first.

@ProviderFor(ownCards)
final ownCardsProvider = OwnCardsProvider._();

/// Every card she wrote, newest first.

final class OwnCardsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OwnCard>>,
          List<OwnCard>,
          Stream<List<OwnCard>>
        >
    with $FutureModifier<List<OwnCard>>, $StreamProvider<List<OwnCard>> {
  /// Every card she wrote, newest first.
  OwnCardsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ownCardsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ownCardsHash();

  @$internal
  @override
  $StreamProviderElement<List<OwnCard>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<OwnCard>> create(Ref ref) {
    return ownCards(ref);
  }
}

String _$ownCardsHash() => r'b7e2e392eb49833cfd8c052db7aae9026e073ee5';

/// Her cards as deck cards (category `self_love`, id `own_<id>`).

@ProviderFor(ownCardQuotes)
final ownCardQuotesProvider = OwnCardQuotesProvider._();

/// Her cards as deck cards (category `self_love`, id `own_<id>`).

final class OwnCardQuotesProvider
    extends $FunctionalProvider<List<Quote>, List<Quote>, List<Quote>>
    with $Provider<List<Quote>> {
  /// Her cards as deck cards (category `self_love`, id `own_<id>`).
  OwnCardQuotesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ownCardQuotesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ownCardQuotesHash();

  @$internal
  @override
  $ProviderElement<List<Quote>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Quote> create(Ref ref) {
    return ownCardQuotes(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Quote> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Quote>>(value),
    );
  }
}

String _$ownCardQuotesHash() => r'8c832b8b8b59e538c01a4a8762b1828c4f5e127a';

/// Every card the deck can deal: the bundled quotes, then the ones she wrote.
/// The deck, the ritual, the journal and the widget all draw from this.

@ProviderFor(cardPool)
final cardPoolProvider = CardPoolProvider._();

/// Every card the deck can deal: the bundled quotes, then the ones she wrote.
/// The deck, the ritual, the journal and the widget all draw from this.

final class CardPoolProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Quote>>,
          List<Quote>,
          FutureOr<List<Quote>>
        >
    with $FutureModifier<List<Quote>>, $FutureProvider<List<Quote>> {
  /// Every card the deck can deal: the bundled quotes, then the ones she wrote.
  /// The deck, the ritual, the journal and the widget all draw from this.
  CardPoolProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cardPoolProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cardPoolHash();

  @$internal
  @override
  $FutureProviderElement<List<Quote>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Quote>> create(Ref ref) {
    return cardPool(ref);
  }
}

String _$cardPoolHash() => r'd6e101d106e4ffd2dddf757a95013e565d27165e';

/// How many more cards she can write: null means no limit (Premium).

@ProviderFor(ownCardSlotsLeft)
final ownCardSlotsLeftProvider = OwnCardSlotsLeftProvider._();

/// How many more cards she can write: null means no limit (Premium).

final class OwnCardSlotsLeftProvider
    extends $FunctionalProvider<int?, int?, int?>
    with $Provider<int?> {
  /// How many more cards she can write: null means no limit (Premium).
  OwnCardSlotsLeftProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ownCardSlotsLeftProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ownCardSlotsLeftHash();

  @$internal
  @override
  $ProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int? create(Ref ref) {
    return ownCardSlotsLeft(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$ownCardSlotsLeftHash() => r'da74c97334f64ea0e34bdadf0cb54ba68f8d49b6';

/// Creates a card, or edits the one with `editId`. Returns why it was not
/// saved, or null when it was. The count is read from the store, so two quick
/// taps cannot pass the free limit. Editing never counts against the limit,
/// and deleting a card frees its slot.

@ProviderFor(saveOwnCard)
final saveOwnCardProvider = SaveOwnCardProvider._();

/// Creates a card, or edits the one with `editId`. Returns why it was not
/// saved, or null when it was. The count is read from the store, so two quick
/// taps cannot pass the free limit. Editing never counts against the limit,
/// and deleting a card frees its slot.

final class SaveOwnCardProvider
    extends
        $FunctionalProvider<
          Future<OwnCardRejection?> Function(
            String text,
            String illustrationId, {
            String? editId,
          }),
          Future<OwnCardRejection?> Function(
            String text,
            String illustrationId, {
            String? editId,
          }),
          Future<OwnCardRejection?> Function(
            String text,
            String illustrationId, {
            String? editId,
          })
        >
    with
        $Provider<
          Future<OwnCardRejection?> Function(
            String text,
            String illustrationId, {
            String? editId,
          })
        > {
  /// Creates a card, or edits the one with `editId`. Returns why it was not
  /// saved, or null when it was. The count is read from the store, so two quick
  /// taps cannot pass the free limit. Editing never counts against the limit,
  /// and deleting a card frees its slot.
  SaveOwnCardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saveOwnCardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saveOwnCardHash();

  @$internal
  @override
  $ProviderElement<
    Future<OwnCardRejection?> Function(
      String text,
      String illustrationId, {
      String? editId,
    })
  >
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Future<OwnCardRejection?> Function(
    String text,
    String illustrationId, {
    String? editId,
  })
  create(Ref ref) {
    return saveOwnCard(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    Future<OwnCardRejection?> Function(
      String text,
      String illustrationId, {
      String? editId,
    })
    value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<
            Future<OwnCardRejection?> Function(
              String text,
              String illustrationId, {
              String? editId,
            })
          >(value),
    );
  }
}

String _$saveOwnCardHash() => r'bb60359a819229fde0f88c38e6a6ca98ace65208';

/// Deletes a card here and, when signed in, in Firestore. If Firestore cannot
/// be reached the copy there comes back with the next sync.

@ProviderFor(deleteOwnCard)
final deleteOwnCardProvider = DeleteOwnCardProvider._();

/// Deletes a card here and, when signed in, in Firestore. If Firestore cannot
/// be reached the copy there comes back with the next sync.

final class DeleteOwnCardProvider
    extends
        $FunctionalProvider<
          Future<void> Function(String id),
          Future<void> Function(String id),
          Future<void> Function(String id)
        >
    with $Provider<Future<void> Function(String id)> {
  /// Deletes a card here and, when signed in, in Firestore. If Firestore cannot
  /// be reached the copy there comes back with the next sync.
  DeleteOwnCardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteOwnCardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteOwnCardHash();

  @$internal
  @override
  $ProviderElement<Future<void> Function(String id)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<void> Function(String id) create(Ref ref) {
    return deleteOwnCard(ref);
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

String _$deleteOwnCardHash() => r'bc3cd0790bc088d6c69413e22efe9e55dda99e4f';

/// Keeps her cards in Firestore in step with the device while someone is
/// signed in: cards only Firestore has are added here, and new or edited ones
/// here are sent. A failed upload is tried again with the next change.
/// Watched from the app root.

@ProviderFor(ownCardSync)
final ownCardSyncProvider = OwnCardSyncProvider._();

/// Keeps her cards in Firestore in step with the device while someone is
/// signed in: cards only Firestore has are added here, and new or edited ones
/// here are sent. A failed upload is tried again with the next change.
/// Watched from the app root.

final class OwnCardSyncProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Keeps her cards in Firestore in step with the device while someone is
  /// signed in: cards only Firestore has are added here, and new or edited ones
  /// here are sent. A failed upload is tried again with the next change.
  /// Watched from the app root.
  OwnCardSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ownCardSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ownCardSyncHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return ownCardSync(ref);
  }
}

String _$ownCardSyncHash() => r'2d8d3171bb3b3c8d039aa6eb8abfe01cb50a754b';
