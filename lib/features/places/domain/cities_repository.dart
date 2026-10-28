import 'package:mochi_moon/features/places/domain/city.dart';

/// Source of the bundled cities list. Widgets never load assets directly.
abstract interface class CitiesRepository {
  Future<List<City>> loadCities();
}
