import 'package:mochi_moon/features/places/data/asset_cities_repository.dart';
import 'package:mochi_moon/features/places/data/lat_lng_time_zone_resolver.dart';
import 'package:mochi_moon/features/places/domain/cities_repository.dart';
import 'package:mochi_moon/features/places/domain/city_index.dart';
import 'package:mochi_moon/features/places/domain/time_zone_resolver.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'places_providers.g.dart';

@Riverpod(keepAlive: true)
CitiesRepository citiesRepository(Ref ref) => AssetCitiesRepository();

@Riverpod(keepAlive: true)
TimeZoneResolver timeZoneResolver(Ref ref) => const LatLngTimeZoneResolver();

/// The searchable cities list, built once on first use.
@Riverpod(keepAlive: true)
Future<CityIndex> cityIndex(Ref ref) async =>
    CityIndex(await ref.watch(citiesRepositoryProvider).loadCities());

/// Country names by code, for showing a saved place in full.
@Riverpod(keepAlive: true)
Future<Map<String, String>> countryNames(Ref ref) async {
  final index = await ref.watch(cityIndexProvider.future);
  return {for (final c in index.cities) c.countryCode: c.countryName};
}
