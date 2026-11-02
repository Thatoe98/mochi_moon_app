// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'for_you_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the Deck tab is set to the For You deck (PRD §6.9). A choice for
/// this session; the plain deck is the default. Premium is checked where the
/// deck is dealt, so a stale "on" never gives a free user the ranked deck.

@ProviderFor(ForYouSelected)
final forYouSelectedProvider = ForYouSelectedProvider._();

/// Whether the Deck tab is set to the For You deck (PRD §6.9). A choice for
/// this session; the plain deck is the default. Premium is checked where the
/// deck is dealt, so a stale "on" never gives a free user the ranked deck.
final class ForYouSelectedProvider
    extends $NotifierProvider<ForYouSelected, bool> {
  /// Whether the Deck tab is set to the For You deck (PRD §6.9). A choice for
  /// this session; the plain deck is the default. Premium is checked where the
  /// deck is dealt, so a stale "on" never gives a free user the ranked deck.
  ForYouSelectedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'forYouSelectedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$forYouSelectedHash();

  @$internal
  @override
  ForYouSelected create() => ForYouSelected();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$forYouSelectedHash() => r'52a9b21cd3222320948c9f39c10b1e28a363119e';

/// Whether the Deck tab is set to the For You deck (PRD §6.9). A choice for
/// this session; the plain deck is the default. Premium is checked where the
/// deck is dealt, so a stale "on" never gives a free user the ranked deck.

abstract class _$ForYouSelected extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
