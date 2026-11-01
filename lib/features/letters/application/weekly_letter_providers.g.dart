// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_letter_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The Readings API with the device cache in front; without a server only a
/// saved letter can be shown.

@ProviderFor(weeklyLetterRepository)
final weeklyLetterRepositoryProvider = WeeklyLetterRepositoryProvider._();

/// The Readings API with the device cache in front; without a server only a
/// saved letter can be shown.

final class WeeklyLetterRepositoryProvider
    extends
        $FunctionalProvider<
          WeeklyLetterRepository,
          WeeklyLetterRepository,
          WeeklyLetterRepository
        >
    with $Provider<WeeklyLetterRepository> {
  /// The Readings API with the device cache in front; without a server only a
  /// saved letter can be shown.
  WeeklyLetterRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyLetterRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyLetterRepositoryHash();

  @$internal
  @override
  $ProviderElement<WeeklyLetterRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WeeklyLetterRepository create(Ref ref) {
    return weeklyLetterRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeeklyLetterRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeeklyLetterRepository>(value),
    );
  }
}

String _$weeklyLetterRepositoryHash() =>
    r'3f4bcc1ae349f478786d4007471eec33fbf2fd6a';

@ProviderFor(questDoneLog)
final questDoneLogProvider = QuestDoneLogProvider._();

final class QuestDoneLogProvider
    extends $FunctionalProvider<QuestDoneLog, QuestDoneLog, QuestDoneLog>
    with $Provider<QuestDoneLog> {
  QuestDoneLogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'questDoneLogProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$questDoneLogHash();

  @$internal
  @override
  $ProviderElement<QuestDoneLog> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  QuestDoneLog create(Ref ref) {
    return questDoneLog(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuestDoneLog value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuestDoneLog>(value),
    );
  }
}

String _$questDoneLogHash() => r'e6d01e88d4ed5e0e32c896766aa420835f4c4aee';

@ProviderFor(weeklyLetterScheduler)
final weeklyLetterSchedulerProvider = WeeklyLetterSchedulerProvider._();

final class WeeklyLetterSchedulerProvider
    extends
        $FunctionalProvider<
          WeeklyLetterNotifier,
          WeeklyLetterNotifier,
          WeeklyLetterNotifier
        >
    with $Provider<WeeklyLetterNotifier> {
  WeeklyLetterSchedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyLetterSchedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyLetterSchedulerHash();

  @$internal
  @override
  $ProviderElement<WeeklyLetterNotifier> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WeeklyLetterNotifier create(Ref ref) {
    return weeklyLetterScheduler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeeklyLetterNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeeklyLetterNotifier>(value),
    );
  }
}

String _$weeklyLetterSchedulerHash() =>
    r'c3b580746f463f15a2a6fa4b2edb2d4cf3422381';

/// The days she finished a quest, from the device log.

@ProviderFor(questDoneDays)
final questDoneDaysProvider = QuestDoneDaysProvider._();

/// The days she finished a quest, from the device log.

final class QuestDoneDaysProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// The days she finished a quest, from the device log.
  QuestDoneDaysProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'questDoneDaysProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$questDoneDaysHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return questDoneDays(ref);
  }
}

String _$questDoneDaysHash() => r'ca02af1418e91f8a2f04cf1923e065f386ec6108';

/// The Monday of the week the letter is about right now.

@ProviderFor(weeklyLetterWeek)
final weeklyLetterWeekProvider = WeeklyLetterWeekProvider._();

/// The Monday of the week the letter is about right now.

final class WeeklyLetterWeekProvider
    extends $FunctionalProvider<DateTime, DateTime, DateTime>
    with $Provider<DateTime> {
  /// The Monday of the week the letter is about right now.
  WeeklyLetterWeekProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyLetterWeekProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyLetterWeekHash();

  @$internal
  @override
  $ProviderElement<DateTime> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DateTime create(Ref ref) {
    return weeklyLetterWeek(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$weeklyLetterWeekHash() => r'25868a55722f018cab56c05a24a8618d65aa163f';

/// This week's counts, or null while her data loads. Counts and ids only.

@ProviderFor(weekAggregates)
final weekAggregatesProvider = WeekAggregatesProvider._();

/// This week's counts, or null while her data loads. Counts and ids only.

final class WeekAggregatesProvider
    extends
        $FunctionalProvider<WeekAggregates?, WeekAggregates?, WeekAggregates?>
    with $Provider<WeekAggregates?> {
  /// This week's counts, or null while her data loads. Counts and ids only.
  WeekAggregatesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weekAggregatesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weekAggregatesHash();

  @$internal
  @override
  $ProviderElement<WeekAggregates?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WeekAggregates? create(Ref ref) {
    return weekAggregates(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeekAggregates? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeekAggregates?>(value),
    );
  }
}

String _$weekAggregatesHash() => r'53c6201269b5352a45a0e6984072b03efb90962e';

/// The letter to show: a saved one, otherwise the server's, otherwise the
/// bundled fallback. Null for a free user (she sees the teaser), while her
/// week loads, or when the week had nothing in it (no call is made then).

@ProviderFor(weeklyLetter)
final weeklyLetterProvider = WeeklyLetterProvider._();

/// The letter to show: a saved one, otherwise the server's, otherwise the
/// bundled fallback. Null for a free user (she sees the teaser), while her
/// week loads, or when the week had nothing in it (no call is made then).

final class WeeklyLetterProvider
    extends
        $FunctionalProvider<
          AsyncValue<WeeklyLetterView?>,
          WeeklyLetterView?,
          FutureOr<WeeklyLetterView?>
        >
    with
        $FutureModifier<WeeklyLetterView?>,
        $FutureProvider<WeeklyLetterView?> {
  /// The letter to show: a saved one, otherwise the server's, otherwise the
  /// bundled fallback. Null for a free user (she sees the teaser), while her
  /// week loads, or when the week had nothing in it (no call is made then).
  WeeklyLetterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyLetterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyLetterHash();

  @$internal
  @override
  $FutureProviderElement<WeeklyLetterView?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WeeklyLetterView?> create(Ref ref) {
    return weeklyLetter(ref);
  }
}

String _$weeklyLetterHash() => r'd70b2f6194a1e51b557d8546ef675847eb5e8e23';

/// Plans the Sunday notification for the next few weeks while she is Premium
/// and has allowed notifications; cancels it otherwise. The text only says a
/// letter is ready. Re-planned when Premium or the language changes and once
/// per app run. Watched from the app root.

@ProviderFor(weeklyLetterNotificationsSync)
final weeklyLetterNotificationsSyncProvider =
    WeeklyLetterNotificationsSyncProvider._();

/// Plans the Sunday notification for the next few weeks while she is Premium
/// and has allowed notifications; cancels it otherwise. The text only says a
/// letter is ready. Re-planned when Premium or the language changes and once
/// per app run. Watched from the app root.

final class WeeklyLetterNotificationsSyncProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Plans the Sunday notification for the next few weeks while she is Premium
  /// and has allowed notifications; cancels it otherwise. The text only says a
  /// letter is ready. Re-planned when Premium or the language changes and once
  /// per app run. Watched from the app root.
  WeeklyLetterNotificationsSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyLetterNotificationsSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyLetterNotificationsSyncHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return weeklyLetterNotificationsSync(ref);
  }
}

String _$weeklyLetterNotificationsSyncHash() =>
    r'2e27ff888e573de818244adb8c20749c3c11ff23';
