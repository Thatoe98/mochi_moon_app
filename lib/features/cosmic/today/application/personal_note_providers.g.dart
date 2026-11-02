// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_note_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The Readings API with the device cache in front; without a server only a
/// saved note can be shown.

@ProviderFor(personalNoteRepository)
final personalNoteRepositoryProvider = PersonalNoteRepositoryProvider._();

/// The Readings API with the device cache in front; without a server only a
/// saved note can be shown.

final class PersonalNoteRepositoryProvider
    extends
        $FunctionalProvider<
          PersonalNoteRepository,
          PersonalNoteRepository,
          PersonalNoteRepository
        >
    with $Provider<PersonalNoteRepository> {
  /// The Readings API with the device cache in front; without a server only a
  /// saved note can be shown.
  PersonalNoteRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'personalNoteRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$personalNoteRepositoryHash();

  @$internal
  @override
  $ProviderElement<PersonalNoteRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PersonalNoteRepository create(Ref ref) {
    return personalNoteRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PersonalNoteRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PersonalNoteRepository>(value),
    );
  }
}

String _$personalNoteRepositoryHash() =>
    r'8c1f6b96d54f07d752b9a162e8a4bd3a27743825';

/// Today's personal note in [lang], or null: for a free user (she sees the
/// locked preview), without a birth date, or when it cannot be written. The
/// page simply leaves the block out then; no made-up text stands in.

@ProviderFor(personalNote)
final personalNoteProvider = PersonalNoteFamily._();

/// Today's personal note in [lang], or null: for a free user (she sees the
/// locked preview), without a birth date, or when it cannot be written. The
/// page simply leaves the block out then; no made-up text stands in.

final class PersonalNoteProvider
    extends
        $FunctionalProvider<
          AsyncValue<PersonalNote?>,
          PersonalNote?,
          FutureOr<PersonalNote?>
        >
    with $FutureModifier<PersonalNote?>, $FutureProvider<PersonalNote?> {
  /// Today's personal note in [lang], or null: for a free user (she sees the
  /// locked preview), without a birth date, or when it cannot be written. The
  /// page simply leaves the block out then; no made-up text stands in.
  PersonalNoteProvider._({
    required PersonalNoteFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'personalNoteProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$personalNoteHash();

  @override
  String toString() {
    return r'personalNoteProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PersonalNote?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PersonalNote?> create(Ref ref) {
    final argument = this.argument as String;
    return personalNote(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PersonalNoteProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$personalNoteHash() => r'8321cf9777e1826c786be097ac40075b4bc098b4';

/// Today's personal note in [lang], or null: for a free user (she sees the
/// locked preview), without a birth date, or when it cannot be written. The
/// page simply leaves the block out then; no made-up text stands in.

final class PersonalNoteFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PersonalNote?>, String> {
  PersonalNoteFamily._()
    : super(
        retry: null,
        name: r'personalNoteProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Today's personal note in [lang], or null: for a free user (she sees the
  /// locked preview), without a birth date, or when it cannot be written. The
  /// page simply leaves the block out then; no made-up text stands in.

  PersonalNoteProvider call(String lang) =>
      PersonalNoteProvider._(argument: lang, from: this);

  @override
  String toString() => r'personalNoteProvider';
}
