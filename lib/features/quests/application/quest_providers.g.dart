// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(questRepository)
final questRepositoryProvider = QuestRepositoryProvider._();

final class QuestRepositoryProvider
    extends
        $FunctionalProvider<QuestRepository, QuestRepository, QuestRepository>
    with $Provider<QuestRepository> {
  QuestRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'questRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$questRepositoryHash();

  @$internal
  @override
  $ProviderElement<QuestRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  QuestRepository create(Ref ref) {
    return questRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuestRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuestRepository>(value),
    );
  }
}

String _$questRepositoryHash() => r'e61505425b6d9806a701a23c52fb1fbbbc0ea2d7';

/// The Firestore copy, or null when Firebase did not start.

@ProviderFor(questRemote)
final questRemoteProvider = QuestRemoteProvider._();

/// The Firestore copy, or null when Firebase did not start.

final class QuestRemoteProvider
    extends $FunctionalProvider<QuestRemote?, QuestRemote?, QuestRemote?>
    with $Provider<QuestRemote?> {
  /// The Firestore copy, or null when Firebase did not start.
  QuestRemoteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'questRemoteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$questRemoteHash();

  @$internal
  @override
  $ProviderElement<QuestRemote?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  QuestRemote? create(Ref ref) {
    return questRemote(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuestRemote? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuestRemote?>(value),
    );
  }
}

String _$questRemoteHash() => r'91aafcd30d621227f75d82e57d6ce907c6f2e000';

/// The saved quest day (the latest one she used), or null.

@ProviderFor(savedQuestDay)
final savedQuestDayProvider = SavedQuestDayProvider._();

/// The saved quest day (the latest one she used), or null.

final class SavedQuestDayProvider
    extends
        $FunctionalProvider<AsyncValue<QuestDay?>, QuestDay?, Stream<QuestDay?>>
    with $FutureModifier<QuestDay?>, $StreamProvider<QuestDay?> {
  /// The saved quest day (the latest one she used), or null.
  SavedQuestDayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedQuestDayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedQuestDayHash();

  @$internal
  @override
  $StreamProviderElement<QuestDay?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<QuestDay?> create(Ref ref) {
    return savedQuestDay(ref);
  }
}

String _$savedQuestDayHash() => r'45fadea4a63e30c9e9fe0bd8b4791a143333bf27';

/// Today's quest, or null while the quests load or when there are none. It is
/// the day's deterministic pick until she swaps or finishes it.

@ProviderFor(todayQuest)
final todayQuestProvider = TodayQuestProvider._();

/// Today's quest, or null while the quests load or when there are none. It is
/// the day's deterministic pick until she swaps or finishes it.

final class TodayQuestProvider
    extends $FunctionalProvider<TodayQuest?, TodayQuest?, TodayQuest?>
    with $Provider<TodayQuest?> {
  /// Today's quest, or null while the quests load or when there are none. It is
  /// the day's deterministic pick until she swaps or finishes it.
  TodayQuestProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayQuestProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayQuestHash();

  @$internal
  @override
  $ProviderElement<TodayQuest?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TodayQuest? create(Ref ref) {
    return todayQuest(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodayQuest? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodayQuest?>(value),
    );
  }
}

String _$todayQuestHash() => r'f0dc2bba2f7a20fb4053225a312db153ea5b774d';

/// Marks today's quest done.

@ProviderFor(completeQuest)
final completeQuestProvider = CompleteQuestProvider._();

/// Marks today's quest done.

final class CompleteQuestProvider
    extends
        $FunctionalProvider<
          Future<void> Function(),
          Future<void> Function(),
          Future<void> Function()
        >
    with $Provider<Future<void> Function()> {
  /// Marks today's quest done.
  CompleteQuestProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'completeQuestProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$completeQuestHash();

  @$internal
  @override
  $ProviderElement<Future<void> Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<void> Function() create(Ref ref) {
    return completeQuest(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<void> Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<void> Function()>(value),
    );
  }
}

String _$completeQuestHash() => r'801e29dff0c0996ca8d76768522b06eb85175ba1';

/// Trades today's quest for the other pick, once a day.

@ProviderFor(swapQuest)
final swapQuestProvider = SwapQuestProvider._();

/// Trades today's quest for the other pick, once a day.

final class SwapQuestProvider
    extends
        $FunctionalProvider<
          Future<void> Function(),
          Future<void> Function(),
          Future<void> Function()
        >
    with $Provider<Future<void> Function()> {
  /// Trades today's quest for the other pick, once a day.
  SwapQuestProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapQuestProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapQuestHash();

  @$internal
  @override
  $ProviderElement<Future<void> Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<void> Function() create(Ref ref) {
    return swapQuest(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<void> Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<void> Function()>(value),
    );
  }
}

String _$swapQuestHash() => r'2633bc74b08db10cab8152222725f6cd707662b6';

/// Keeps the quest state in Firestore in step with the device while someone
/// is signed in. The device wins when its day is the same or newer. A failed
/// upload is retried with the next change. Watched from the app root.

@ProviderFor(questSync)
final questSyncProvider = QuestSyncProvider._();

/// Keeps the quest state in Firestore in step with the device while someone
/// is signed in. The device wins when its day is the same or newer. A failed
/// upload is retried with the next change. Watched from the app root.

final class QuestSyncProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Keeps the quest state in Firestore in step with the device while someone
  /// is signed in. The device wins when its day is the same or newer. A failed
  /// upload is retried with the next change. Watched from the app root.
  QuestSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'questSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$questSyncHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return questSync(ref);
  }
}

String _$questSyncHash() => r'bab752cb738009e0d547e201a0069d35c28ddd22';
