import 'package:flutter/services.dart';
import 'package:mochi_moon/features/places/domain/cities_repository.dart';
import 'package:mochi_moon/features/places/domain/city.dart';

/// Reads the GeoNames-derived files built by `tool/build_cities.dart`.
class AssetCitiesRepository implements CitiesRepository {
  AssetCitiesRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  static const citiesPath = 'assets/content/cities/cities.tsv';
  static const countriesPath = 'assets/content/cities/countries.tsv';

  final AssetBundle _bundle;

  @override
  Future<List<City>> loadCities() async {
    final countries = parseCountries(await _bundle.loadString(countriesPath));
    return parseCities(await _bundle.loadString(citiesPath), countries);
  }

  /// Columns: country code, country name.
  static Map<String, String> parseCountries(String tsv) => {
    for (final line in tsv.split('\n'))
      if (line.split('\t') case [final code, final name]) code: name,
  };

  /// Columns: name, ASCII name, region, country code, lat, lng, population.
  /// Lines that do not fit are skipped, so one bad row cannot lose the list.
  static List<City> parseCities(String tsv, Map<String, String> countries) {
    final cities = <City>[];
    for (final line in tsv.split('\n')) {
      final cols = line.split('\t');
      if (cols.length != 7) continue;
      final lat = double.tryParse(cols[4]);
      final lng = double.tryParse(cols[5]);
      final population = int.tryParse(cols[6]);
      if (lat == null || lng == null || population == null) continue;
      cities.add(
        City(
          name: cols[0],
          asciiName: cols[1],
          region: cols[2],
          countryCode: cols[3],
          countryName: countries[cols[3]] ?? cols[3],
          lat: lat,
          lng: lng,
          population: population,
        ),
      );
    }
    return cities;
  }
}
