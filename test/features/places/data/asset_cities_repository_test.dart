import 'package:flutter_test/flutter_test.dart';
import 'package:lat_lng_to_timezone/lat_lng_to_timezone.dart';
import 'package:mochi_moon/features/places/data/asset_cities_repository.dart';
import 'package:mochi_moon/features/places/data/lat_lng_time_zone_resolver.dart';
import 'package:mochi_moon/features/places/domain/city.dart';
import 'package:mochi_moon/features/places/domain/city_index.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('parseCities', () {
    test('reads the columns and looks up the country name', () {
      final cities = AssetCitiesRepository.parseCities(
        'Bangkok\tBangkok\tBangkok\tTH\t13.7540\t100.5014\t5104476\n',
        {'TH': 'Thailand'},
      );

      expect(cities, hasLength(1));
      expect(cities.single.name, 'Bangkok');
      expect(cities.single.asciiName, 'Bangkok');
      expect(cities.single.region, 'Bangkok');
      expect(cities.single.countryName, 'Thailand');
      expect(cities.single.lat, 13.754);
      expect(cities.single.lng, 100.5014);
      expect(cities.single.population, 5104476);
    });

    test('falls back to the code and keeps an empty region', () {
      final city = AssetCitiesRepository.parseCities(
        'Vatican City\tVatican City\t\tVA\t41.9\t12.45\t829\n',
        {},
      ).single;

      expect(city.region, isEmpty);
      expect(city.countryName, 'VA');
      expect(city.label, 'Vatican City, VA');
    });

    test('skips rows that do not fit', () {
      final cities = AssetCitiesRepository.parseCities(
        'short\trow\n'
        '\n'
        'A\tA\tR\tTH\tnorth\t100\t5\n'
        'B\tB\tR\tTH\t1.0\t2.0\t7\n',
        {},
      );

      expect(cities.map((c) => c.name), ['B']);
    });
  });

  group('the bundled list', () {
    late List<City> cities;
    late CityIndex index;

    setUpAll(() async {
      cities = await AssetCitiesRepository().loadCities();
      index = CityIndex(cities);
    });

    test('covers the world, each city with a country name', () {
      expect(cities.length, greaterThan(30000));
      expect(
        cities.where((c) => c.countryName == c.countryCode),
        isEmpty,
        reason: 'every country code has a name',
      );
    });

    test('finds Bangkok and Yangon first', () {
      expect(index.search('bangkok').first.label, 'Bangkok, Bangkok, Thailand');
      expect(index.search('yangon').first.countryName, 'Myanmar');
    });

    test('tells apart cities with the same name', () {
      final labels = index.search('springfield illinois').map((c) => c.label);

      expect(labels.first, 'Springfield, Illinois, United States');
    });

    test('finds a place by its name without accents', () {
      expect(index.search('zurich').first.name, 'Zürich');
    });
  });

  group('time zones', () {
    const resolver = LatLngTimeZoneResolver();

    test('resolves the zone of well-known places', () {
      expect(resolver.resolve(lat: 13.754, lng: 100.5014), 'Asia/Bangkok');
      expect(resolver.resolve(lat: 16.8053, lng: 96.1561), 'Asia/Yangon');
      expect(resolver.resolve(lat: 40.7128, lng: -74.006), 'America/New_York');
      expect(resolver.resolve(lat: 51.5074, lng: -0.1278), 'Europe/London');
      expect(
        resolver.resolve(lat: -33.8688, lng: 151.2093),
        'Australia/Sydney',
      );
    });

    test(
      'every zone found for a bundled city is in the time zone data',
      () async {
        tzdata.initializeTimeZones();
        final cities = await AssetCitiesRepository().loadCities();

        // Every 20th city keeps this quick while still covering the world.
        for (var i = 0; i < cities.length; i += 20) {
          final city = cities[i];
          final id = latLngToTimezoneString(city.lat, city.lng);
          expect(
            () => tz.getLocation(id),
            returnsNormally,
            reason: '$id for ${city.label}',
          );
        }
      },
    );

    test('a 1985 Bangkok birth time converts to UTC', () {
      tzdata.initializeTimeZones();
      final bangkok = tz.getLocation(
        resolver.resolve(lat: 13.754, lng: 100.5014),
      );

      expect(
        tz.TZDateTime(bangkok, 1985, 6, 1, 12).toUtc(),
        DateTime.utc(1985, 6, 1, 5),
      );
    });
  });
}
