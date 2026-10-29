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

/// The retrograde periods of [year] and the next, merged. Kept for the whole
/// session: the scan is slow, and scrolling away from a screen that shows it
/// must not throw the result away.

@ProviderFor(retrogradePeriods)
final retrogradePeriodsProvider = RetrogradePeriodsFamily._();

/// The retrograde periods of [year] and the next, merged. Kept for the whole
/// session: the scan is slow, and scrolling away from a screen that shows it
/// must not throw the result away.

final class RetrogradePeriodsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RetrogradePeriod>>,
          List<RetrogradePeriod>,
          FutureOr<List<RetrogradePeriod>>
        >
    with
        $FutureModifier<List<RetrogradePeriod>>,
        $FutureProvider<List<RetrogradePeriod>> {
  /// The retrograde periods of [year] and the next, merged. Kept for the whole
  /// session: the scan is slow, and scrolling away from a screen that shows it
  /// must not throw the result away.
  RetrogradePeriodsProvider._({
    required RetrogradePeriodsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'retrogradePeriodsProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$retrogradePeriodsHash();

  @override
  String toString() {
    return r'retrogradePeriodsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<RetrogradePeriod>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RetrogradePeriod>> create(Ref ref) {
    final argument = this.argument as int;
    return retrogradePeriods(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RetrogradePeriodsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$retrogradePeriodsHash() => r'a7f9b388ec5534fbf426bc1e88b7f695e1bcbb95';

/// The retrograde periods of [year] and the next, merged. Kept for the whole
/// session: the scan is slow, and scrolling away from a screen that shows it
/// must not throw the result away.

final class RetrogradePeriodsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<RetrogradePeriod>>, int> {
  RetrogradePeriodsFamily._()
    : super(
        retry: null,
        name: r'retrogradePeriodsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// The retrograde periods of [year] and the next, merged. Kept for the whole
  /// session: the scan is slow, and scrolling away from a screen that shows it
  /// must not throw the result away.

  RetrogradePeriodsProvider call(int year) =>
      RetrogradePeriodsProvider._(argument: year, from: this);

  @override
  String toString() => r'retrogradePeriodsProvider';
}

/// Every planet's retrograde periods for this year and the next, as of now.
/// Cheap once `retrogradePeriods` is loaded, so it can follow the clock.

@ProviderFor(retrogradeOverview)
final retrogradeOverviewProvider = RetrogradeOverviewProvider._();

/// Every planet's retrograde periods for this year and the next, as of now.
/// Cheap once `retrogradePeriods` is loaded, so it can follow the clock.

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
  /// Cheap once `retrogradePeriods` is loaded, so it can follow the clock.
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
    r'eda6e991c5b63b4d5789d473b9fb8500f4785e82';
