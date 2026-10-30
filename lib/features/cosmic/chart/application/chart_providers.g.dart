// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The user's natal chart, or null while there is no birth date. It is cast
/// again whenever the profile changes, so editing the birth data updates it
/// (PRD §6.11).

@ProviderFor(natalChart)
final natalChartProvider = NatalChartProvider._();

/// The user's natal chart, or null while there is no birth date. It is cast
/// again whenever the profile changes, so editing the birth data updates it
/// (PRD §6.11).

final class NatalChartProvider
    extends
        $FunctionalProvider<
          AsyncValue<NatalChart?>,
          NatalChart?,
          FutureOr<NatalChart?>
        >
    with $FutureModifier<NatalChart?>, $FutureProvider<NatalChart?> {
  /// The user's natal chart, or null while there is no birth date. It is cast
  /// again whenever the profile changes, so editing the birth data updates it
  /// (PRD §6.11).
  NatalChartProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'natalChartProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$natalChartHash();

  @$internal
  @override
  $FutureProviderElement<NatalChart?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<NatalChart?> create(Ref ref) {
    return natalChart(ref);
  }
}

String _$natalChartHash() => r'dd9c8c2885e5c38521e1b24063cb254d5db289c3';
