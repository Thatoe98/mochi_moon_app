// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retrograde_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The scan takes a couple of seconds, so it runs off the main isolate. Tests
/// override this with a fake calendar.

@ProviderFor(retrogradeCalendarSource)
final retrogradeCalendarSourceProvider = RetrogradeCalendarSourceProvider._();

/// The scan takes a couple of seconds, so it runs off the main isolate. Tests
/// override this with a fake calendar.

final class RetrogradeCalendarSourceProvider
    extends
        $FunctionalProvider<
          RetrogradeCalendarSource,
          RetrogradeCalendarSource,
          RetrogradeCalendarSource
        >
    with $Provider<RetrogradeCalendarSource> {
  /// The scan takes a couple of seconds, so it runs off the main isolate. Tests
  /// override this with a fake calendar.
  RetrogradeCalendarSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'retrogradeCalendarSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$retrogradeCalendarSourceHash();

  @$internal
  @override
  $ProviderElement<RetrogradeCalendarSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RetrogradeCalendarSource create(Ref ref) {
    return retrogradeCalendarSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RetrogradeCalendarSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RetrogradeCalendarSource>(value),
    );
  }
}

String _$retrogradeCalendarSourceHash() =>
    r'3b31252d6f4a2aa6193bbdf3dfca925c34943b08';

/// Every planet's retrograde periods for this year and the next, as of now.

@ProviderFor(retrogradeOverview)
final retrogradeOverviewProvider = RetrogradeOverviewProvider._();

/// Every planet's retrograde periods for this year and the next, as of now.

final class RetrogradeOverviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<RetrogradeOverview>,
          RetrogradeOverview,
          FutureOr<RetrogradeOverview>
        >
    with
        $FutureModifier<RetrogradeOverview>,
        $FutureProvider<RetrogradeOverview> {
  /// Every planet's retrograde periods for this year and the next, as of now.
  RetrogradeOverviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'retrogradeOverviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$retrogradeOverviewHash();

  @$internal
  @override
  $FutureProviderElement<RetrogradeOverview> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RetrogradeOverview> create(Ref ref) {
    return retrogradeOverview(ref);
  }
}

String _$retrogradeOverviewHash() =>
    r'093ea89a34bd553142024ddb613461c2ddc9acfd';
