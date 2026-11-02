// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trial_offer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(trialOfferRepository)
final trialOfferRepositoryProvider = TrialOfferRepositoryProvider._();

final class TrialOfferRepositoryProvider
    extends
        $FunctionalProvider<
          TrialOfferRepository,
          TrialOfferRepository,
          TrialOfferRepository
        >
    with $Provider<TrialOfferRepository> {
  TrialOfferRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trialOfferRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trialOfferRepositoryHash();

  @$internal
  @override
  $ProviderElement<TrialOfferRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TrialOfferRepository create(Ref ref) {
    return trialOfferRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TrialOfferRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TrialOfferRepository>(value),
    );
  }
}

String _$trialOfferRepositoryHash() =>
    r'7c0912f7fa06e740e8720d76744204b428b55630';

/// Whether the one-time trial offer shows on Today right now (PRD §6.13).
///
/// Once it is on screen it stays until she answers it; it is remembered as
/// shown the moment the card appears, so it never comes back.

@ProviderFor(TrialOffer)
final trialOfferProvider = TrialOfferProvider._();

/// Whether the one-time trial offer shows on Today right now (PRD §6.13).
///
/// Once it is on screen it stays until she answers it; it is remembered as
/// shown the moment the card appears, so it never comes back.
final class TrialOfferProvider
    extends $AsyncNotifierProvider<TrialOffer, bool> {
  /// Whether the one-time trial offer shows on Today right now (PRD §6.13).
  ///
  /// Once it is on screen it stays until she answers it; it is remembered as
  /// shown the moment the card appears, so it never comes back.
  TrialOfferProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trialOfferProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trialOfferHash();

  @$internal
  @override
  TrialOffer create() => TrialOffer();
}

String _$trialOfferHash() => r'a8c558483ee4bca633e1b9e49d25ee72195201e9';

/// Whether the one-time trial offer shows on Today right now (PRD §6.13).
///
/// Once it is on screen it stays until she answers it; it is remembered as
/// shown the moment the card appears, so it never comes back.

abstract class _$TrialOffer extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Remembers that she opened the hard-day kit today, so no offer shows today.

@ProviderFor(noteHardDayOpened)
final noteHardDayOpenedProvider = NoteHardDayOpenedProvider._();

/// Remembers that she opened the hard-day kit today, so no offer shows today.

final class NoteHardDayOpenedProvider
    extends
        $FunctionalProvider<
          Future<void> Function(),
          Future<void> Function(),
          Future<void> Function()
        >
    with $Provider<Future<void> Function()> {
  /// Remembers that she opened the hard-day kit today, so no offer shows today.
  NoteHardDayOpenedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'noteHardDayOpenedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$noteHardDayOpenedHash();

  @$internal
  @override
  $ProviderElement<Future<void> Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<void> Function() create(Ref ref) {
    return noteHardDayOpened(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<void> Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<void> Function()>(value),
    );
  }
}

String _$noteHardDayOpenedHash() => r'c9de5bf7fcfdd545fd79b2f0c6f36aeb08b90a77';
