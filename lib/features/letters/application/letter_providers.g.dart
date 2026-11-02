// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'letter_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(letterRepository)
final letterRepositoryProvider = LetterRepositoryProvider._();

final class LetterRepositoryProvider
    extends
        $FunctionalProvider<
          LetterRepository,
          LetterRepository,
          LetterRepository
        >
    with $Provider<LetterRepository> {
  LetterRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'letterRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$letterRepositoryHash();

  @$internal
  @override
  $ProviderElement<LetterRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LetterRepository create(Ref ref) {
    return letterRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LetterRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LetterRepository>(value),
    );
  }
}

String _$letterRepositoryHash() => r'2e2d63f5a750e10f380de254d8d3659f89a98e8e';

/// The Firestore copy, or null when Firebase did not start.

@ProviderFor(letterRemote)
final letterRemoteProvider = LetterRemoteProvider._();

/// The Firestore copy, or null when Firebase did not start.

final class LetterRemoteProvider
    extends $FunctionalProvider<LetterRemote?, LetterRemote?, LetterRemote?>
    with $Provider<LetterRemote?> {
  /// The Firestore copy, or null when Firebase did not start.
  LetterRemoteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'letterRemoteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$letterRemoteHash();

  @$internal
  @override
  $ProviderElement<LetterRemote?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LetterRemote? create(Ref ref) {
    return letterRemote(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LetterRemote? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LetterRemote?>(value),
    );
  }
}

String _$letterRemoteHash() => r'55fb9cae7ebf57b912ab391257a5c257ce4bdd46';

@ProviderFor(letterScheduler)
final letterSchedulerProvider = LetterSchedulerProvider._();

final class LetterSchedulerProvider
    extends $FunctionalProvider<LetterNotifier, LetterNotifier, LetterNotifier>
    with $Provider<LetterNotifier> {
  LetterSchedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'letterSchedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$letterSchedulerHash();

  @$internal
  @override
  $ProviderElement<LetterNotifier> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LetterNotifier create(Ref ref) {
    return letterScheduler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LetterNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LetterNotifier>(value),
    );
  }
}

String _$letterSchedulerHash() => r'719d246fac2d274575e448bef5c9955f6b9d8991';

/// Every letter, the one that opens soonest first.

@ProviderFor(futureLetters)
final futureLettersProvider = FutureLettersProvider._();

/// Every letter, the one that opens soonest first.

final class FutureLettersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FutureLetter>>,
          List<FutureLetter>,
          Stream<List<FutureLetter>>
        >
    with
        $FutureModifier<List<FutureLetter>>,
        $StreamProvider<List<FutureLetter>> {
  /// Every letter, the one that opens soonest first.
  FutureLettersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'futureLettersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$futureLettersHash();

  @$internal
  @override
  $StreamProviderElement<List<FutureLetter>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<FutureLetter>> create(Ref ref) {
    return futureLetters(ref);
  }
}

String _$futureLettersHash() => r'0a27c7c5201a98b5d97015902921e8eff1819c9e';

/// The letter `letterId`, or null when there is none.

@ProviderFor(futureLetter)
final futureLetterProvider = FutureLetterFamily._();

/// The letter `letterId`, or null when there is none.

final class FutureLetterProvider
    extends
        $FunctionalProvider<
          AsyncValue<FutureLetter?>,
          FutureLetter?,
          FutureOr<FutureLetter?>
        >
    with $FutureModifier<FutureLetter?>, $FutureProvider<FutureLetter?> {
  /// The letter `letterId`, or null when there is none.
  FutureLetterProvider._({
    required FutureLetterFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'futureLetterProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$futureLetterHash();

  @override
  String toString() {
    return r'futureLetterProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<FutureLetter?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FutureLetter?> create(Ref ref) {
    final argument = this.argument as String;
    return futureLetter(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FutureLetterProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$futureLetterHash() => r'1707c1a1103c267deec78805d8d1c9f79f47dbcc';

/// The letter `letterId`, or null when there is none.

final class FutureLetterFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<FutureLetter?>, String> {
  FutureLetterFamily._()
    : super(
        retry: null,
        name: r'futureLetterProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The letter `letterId`, or null when there is none.

  FutureLetterProvider call(String letterId) =>
      FutureLetterProvider._(argument: letterId, from: this);

  @override
  String toString() => r'futureLetterProvider';
}

/// How many more letters she can seal right now: null means no limit
/// (Premium). Free accounts keep [FreeLimits.sealedLetters] sealed at a time;
/// a letter that has opened no longer uses the slot.

@ProviderFor(sealedLettersLeft)
final sealedLettersLeftProvider = SealedLettersLeftProvider._();

/// How many more letters she can seal right now: null means no limit
/// (Premium). Free accounts keep [FreeLimits.sealedLetters] sealed at a time;
/// a letter that has opened no longer uses the slot.

final class SealedLettersLeftProvider
    extends $FunctionalProvider<int?, int?, int?>
    with $Provider<int?> {
  /// How many more letters she can seal right now: null means no limit
  /// (Premium). Free accounts keep [FreeLimits.sealedLetters] sealed at a time;
  /// a letter that has opened no longer uses the slot.
  SealedLettersLeftProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sealedLettersLeftProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sealedLettersLeftHash();

  @$internal
  @override
  $ProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int? create(Ref ref) {
    return sealedLettersLeft(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$sealedLettersLeftHash() => r'455d64583ef2d366da34417894d3ae78d82e40ff';

/// Seals a letter written now. Asks for notification permission first, the
/// same way the daily reminder does, so the letter can announce itself.

@ProviderFor(sealLetterAction)
final sealLetterActionProvider = SealLetterActionProvider._();

/// Seals a letter written now. Asks for notification permission first, the
/// same way the daily reminder does, so the letter can announce itself.

final class SealLetterActionProvider
    extends
        $FunctionalProvider<
          Future<SealOutcome> Function(String text, int unlockDays),
          Future<SealOutcome> Function(String text, int unlockDays),
          Future<SealOutcome> Function(String text, int unlockDays)
        >
    with $Provider<Future<SealOutcome> Function(String text, int unlockDays)> {
  /// Seals a letter written now. Asks for notification permission first, the
  /// same way the daily reminder does, so the letter can announce itself.
  SealLetterActionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sealLetterActionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sealLetterActionHash();

  @$internal
  @override
  $ProviderElement<Future<SealOutcome> Function(String text, int unlockDays)>
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Future<SealOutcome> Function(String text, int unlockDays) create(Ref ref) {
    return sealLetterAction(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    Future<SealOutcome> Function(String text, int unlockDays) value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<
            Future<SealOutcome> Function(String text, int unlockDays)
          >(value),
    );
  }
}

String _$sealLetterActionHash() => r'0f7d66b747ed2387a9fa497112941be049950675';

/// Deletes a letter here, its notification and, when signed in, its copy in
/// Firestore. If Firestore cannot be reached the copy there comes back with
/// the next sync.

@ProviderFor(deleteLetter)
final deleteLetterProvider = DeleteLetterProvider._();

/// Deletes a letter here, its notification and, when signed in, its copy in
/// Firestore. If Firestore cannot be reached the copy there comes back with
/// the next sync.

final class DeleteLetterProvider
    extends
        $FunctionalProvider<
          Future<void> Function(String id),
          Future<void> Function(String id),
          Future<void> Function(String id)
        >
    with $Provider<Future<void> Function(String id)> {
  /// Deletes a letter here, its notification and, when signed in, its copy in
  /// Firestore. If Firestore cannot be reached the copy there comes back with
  /// the next sync.
  DeleteLetterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteLetterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteLetterHash();

  @$internal
  @override
  $ProviderElement<Future<void> Function(String id)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<void> Function(String id) create(Ref ref) {
    return deleteLetter(ref);
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

String _$deleteLetterHash() => r'ea57c1c68628204ff845821c1d40f664a59314bf';

/// Keeps one notification per sealed letter that has not opened yet, in the
/// app language. The notification says only that a letter is ready; it never
/// carries the letter. Re-planned whenever the letters or the language change
/// and once per app run. Watched from the app root.

@ProviderFor(letterNotificationsSync)
final letterNotificationsSyncProvider = LetterNotificationsSyncProvider._();

/// Keeps one notification per sealed letter that has not opened yet, in the
/// app language. The notification says only that a letter is ready; it never
/// carries the letter. Re-planned whenever the letters or the language change
/// and once per app run. Watched from the app root.

final class LetterNotificationsSyncProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Keeps one notification per sealed letter that has not opened yet, in the
  /// app language. The notification says only that a letter is ready; it never
  /// carries the letter. Re-planned whenever the letters or the language change
  /// and once per app run. Watched from the app root.
  LetterNotificationsSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'letterNotificationsSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$letterNotificationsSyncHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return letterNotificationsSync(ref);
  }
}

String _$letterNotificationsSyncHash() =>
    r'3042413ec93174581831c517a57f41ed01229386';

/// Keeps the letters in Firestore in step with the device while someone is
/// signed in: letters only Firestore has are added here, and new ones here are
/// sent. A failed upload is tried again with the next change. Watched from the
/// app root.

@ProviderFor(letterSync)
final letterSyncProvider = LetterSyncProvider._();

/// Keeps the letters in Firestore in step with the device while someone is
/// signed in: letters only Firestore has are added here, and new ones here are
/// sent. A failed upload is tried again with the next change. Watched from the
/// app root.

final class LetterSyncProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Keeps the letters in Firestore in step with the device while someone is
  /// signed in: letters only Firestore has are added here, and new ones here are
  /// sent. A failed upload is tried again with the next change. Watched from the
  /// app root.
  LetterSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'letterSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$letterSyncHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return letterSync(ref);
  }
}

String _$letterSyncHash() => r'5a441652676772081ba1894111bf1b9a7a2eebe9';
