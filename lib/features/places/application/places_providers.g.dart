// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'places_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(citiesRepository)
final citiesRepositoryProvider = CitiesRepositoryProvider._();

final class CitiesRepositoryProvider
    extends
        $FunctionalProvider<
          CitiesRepository,
          CitiesRepository,
          CitiesRepository
        >
    with $Provider<CitiesRepository> {
  CitiesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'citiesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$citiesRepositoryHash();

  @$internal
  @override
  $ProviderElement<CitiesRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CitiesRepository create(Ref ref) {
    return citiesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CitiesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CitiesRepository>(value),
    );
  }
}

String _$citiesRepositoryHash() => r'2cba60bf72270bd59cc273115169e8fe73891e51';

@ProviderFor(timeZoneResolver)
final timeZoneResolverProvider = TimeZoneResolverProvider._();

final class TimeZoneResolverProvider
    extends
        $FunctionalProvider<
          TimeZoneResolver,
          TimeZoneResolver,
          TimeZoneResolver
        >
    with $Provider<TimeZoneResolver> {
  TimeZoneResolverProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timeZoneResolverProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timeZoneResolverHash();

  @$internal
  @override
  $ProviderElement<TimeZoneResolver> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TimeZoneResolver create(Ref ref) {
    return timeZoneResolver(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimeZoneResolver value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimeZoneResolver>(value),
    );
  }
}

String _$timeZoneResolverHash() => r'414c6b904332da9b779fef737459ddedd3e45db3';

/// The searchable cities list, built once on first use.

@ProviderFor(cityIndex)
final cityIndexProvider = CityIndexProvider._();

/// The searchable cities list, built once on first use.

final class CityIndexProvider
    extends
        $FunctionalProvider<
          AsyncValue<CityIndex>,
          CityIndex,
          FutureOr<CityIndex>
        >
    with $FutureModifier<CityIndex>, $FutureProvider<CityIndex> {
  /// The searchable cities list, built once on first use.
  CityIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cityIndexProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cityIndexHash();

  @$internal
  @override
  $FutureProviderElement<CityIndex> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<CityIndex> create(Ref ref) {
    return cityIndex(ref);
  }
}

String _$cityIndexHash() => r'6bef06fd7d1ace27d2241969da9cb4f3987e26e4';

/// Country names by code, for showing a saved place in full.

@ProviderFor(countryNames)
final countryNamesProvider = CountryNamesProvider._();

/// Country names by code, for showing a saved place in full.

final class CountryNamesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, String>>,
          Map<String, String>,
          FutureOr<Map<String, String>>
        >
    with
        $FutureModifier<Map<String, String>>,
        $FutureProvider<Map<String, String>> {
  /// Country names by code, for showing a saved place in full.
  CountryNamesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'countryNamesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$countryNamesHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, String>> create(Ref ref) {
    return countryNames(ref);
  }
}

String _$countryNamesHash() => r'36e0df4473ea059f1f09a7ec2fc67a1ab9666f54';
