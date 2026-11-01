// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recap_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Last month's recap, built on the device from her ritual days, moods and
/// saved cards. Nothing is uploaded.

@ProviderFor(lastMonthRecap)
final lastMonthRecapProvider = LastMonthRecapProvider._();

/// Last month's recap, built on the device from her ritual days, moods and
/// saved cards. Nothing is uploaded.

final class LastMonthRecapProvider
    extends
        $FunctionalProvider<
          AsyncValue<RecapView>,
          RecapView,
          FutureOr<RecapView>
        >
    with $FutureModifier<RecapView>, $FutureProvider<RecapView> {
  /// Last month's recap, built on the device from her ritual days, moods and
  /// saved cards. Nothing is uploaded.
  LastMonthRecapProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastMonthRecapProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastMonthRecapHash();

  @$internal
  @override
  $FutureProviderElement<RecapView> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<RecapView> create(Ref ref) {
    return lastMonthRecap(ref);
  }
}

String _$lastMonthRecapHash() => r'd622adc0d72b4700d605147b8e7e1eb7760a3cd0';
