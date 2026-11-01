// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(moodRepository)
final moodRepositoryProvider = MoodRepositoryProvider._();

final class MoodRepositoryProvider
    extends $FunctionalProvider<MoodRepository, MoodRepository, MoodRepository>
    with $Provider<MoodRepository> {
  MoodRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'moodRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$moodRepositoryHash();

  @$internal
  @override
  $ProviderElement<MoodRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MoodRepository create(Ref ref) {
    return moodRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MoodRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MoodRepository>(value),
    );
  }
}

String _$moodRepositoryHash() => r'30001d0a297c593ed8b5b9ae1a88e974041d5bc5';

/// The Firestore copy, or null when Firebase did not start.

@ProviderFor(moodRemote)
final moodRemoteProvider = MoodRemoteProvider._();

/// The Firestore copy, or null when Firebase did not start.

final class MoodRemoteProvider
    extends $FunctionalProvider<MoodRemote?, MoodRemote?, MoodRemote?>
    with $Provider<MoodRemote?> {
  /// The Firestore copy, or null when Firebase did not start.
  MoodRemoteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'moodRemoteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$moodRemoteHash();

  @$internal
  @override
  $ProviderElement<MoodRemote?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MoodRemote? create(Ref ref) {
    return moodRemote(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MoodRemote? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MoodRemote?>(value),
    );
  }
}

String _$moodRemoteHash() => r'413b76e409ab6e4177921b1bd2c675aff7e4510a';

/// Every day with a mood, oldest first.

@ProviderFor(dayMoods)
final dayMoodsProvider = DayMoodsProvider._();

/// Every day with a mood, oldest first.

final class DayMoodsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DayMood>>,
          List<DayMood>,
          Stream<List<DayMood>>
        >
    with $FutureModifier<List<DayMood>>, $StreamProvider<List<DayMood>> {
  /// Every day with a mood, oldest first.
  DayMoodsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dayMoodsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dayMoodsHash();

  @$internal
  @override
  $StreamProviderElement<List<DayMood>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<DayMood>> create(Ref ref) {
    return dayMoods(ref);
  }
}

String _$dayMoodsHash() => r'2841bfc67564f1de1ba308f483a1ff90e03d5eed';

/// Days the ritual was finished, from the device.

@ProviderFor(ritualDaySet)
final ritualDaySetProvider = RitualDaySetProvider._();

/// Days the ritual was finished, from the device.

final class RitualDaySetProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<DateTime>>,
          Set<DateTime>,
          Stream<Set<DateTime>>
        >
    with $FutureModifier<Set<DateTime>>, $StreamProvider<Set<DateTime>> {
  /// Days the ritual was finished, from the device.
  RitualDaySetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ritualDaySetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ritualDaySetHash();

  @$internal
  @override
  $StreamProviderElement<Set<DateTime>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Set<DateTime>> create(Ref ref) {
    return ritualDaySet(ref);
  }
}

String _$ritualDaySetHash() => r'5253e4937d15d40f3f900d20a8e1eb98726a1e0d';

/// The gentle patterns in her own moods; computed on the device only.

@ProviderFor(moodInsights)
final moodInsightsProvider = MoodInsightsProvider._();

/// The gentle patterns in her own moods; computed on the device only.

final class MoodInsightsProvider
    extends $FunctionalProvider<MoodInsights?, MoodInsights?, MoodInsights?>
    with $Provider<MoodInsights?> {
  /// The gentle patterns in her own moods; computed on the device only.
  MoodInsightsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'moodInsightsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$moodInsightsHash();

  @$internal
  @override
  $ProviderElement<MoodInsights?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MoodInsights? create(Ref ref) {
    return moodInsights(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MoodInsights? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MoodInsights?>(value),
    );
  }
}

String _$moodInsightsHash() => r'2cb304cef1edeff218b140b179281cb2e16e91ec';

/// Today's mood, or null until she picks one.

@ProviderFor(todayMood)
final todayMoodProvider = TodayMoodProvider._();

/// Today's mood, or null until she picks one.

final class TodayMoodProvider extends $FunctionalProvider<Mood?, Mood?, Mood?>
    with $Provider<Mood?> {
  /// Today's mood, or null until she picks one.
  TodayMoodProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayMoodProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayMoodHash();

  @$internal
  @override
  $ProviderElement<Mood?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Mood? create(Ref ref) {
    return todayMood(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Mood? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Mood?>(value),
    );
  }
}

String _$todayMoodHash() => r'84f8b35e05aa44cd9c93fadc8a59e33d920fb2dc';

/// Stores the given mood as today's mood; the last choice of the day wins.

@ProviderFor(setTodayMood)
final setTodayMoodProvider = SetTodayMoodProvider._();

/// Stores the given mood as today's mood; the last choice of the day wins.

final class SetTodayMoodProvider
    extends
        $FunctionalProvider<
          Future<void> Function(Mood mood),
          Future<void> Function(Mood mood),
          Future<void> Function(Mood mood)
        >
    with $Provider<Future<void> Function(Mood mood)> {
  /// Stores the given mood as today's mood; the last choice of the day wins.
  SetTodayMoodProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setTodayMoodProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setTodayMoodHash();

  @$internal
  @override
  $ProviderElement<Future<void> Function(Mood mood)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<void> Function(Mood mood) create(Ref ref) {
    return setTodayMood(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<void> Function(Mood mood) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<void> Function(Mood mood)>(
        value,
      ),
    );
  }
}

String _$setTodayMoodHash() => r'89f5a920ea947f8e216419c2a94085211fc924c7';

/// Keeps the moods in Firestore in step with the device while someone is
/// signed in. The device wins: days only Firestore has are added here, and
/// days changed here are sent. A failed upload is tried again with the next
/// change. Watched from the app root.

@ProviderFor(moodSync)
final moodSyncProvider = MoodSyncProvider._();

/// Keeps the moods in Firestore in step with the device while someone is
/// signed in. The device wins: days only Firestore has are added here, and
/// days changed here are sent. A failed upload is tried again with the next
/// change. Watched from the app root.

final class MoodSyncProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Keeps the moods in Firestore in step with the device while someone is
  /// signed in. The device wins: days only Firestore has are added here, and
  /// days changed here are sent. A failed upload is tried again with the next
  /// change. Watched from the app root.
  MoodSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'moodSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$moodSyncHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return moodSync(ref);
  }
}

String _$moodSyncHash() => r'735fd5c0d6f9c3fb6267ff85c7ef17c3ecbd03a4';
