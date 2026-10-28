import 'package:freezed_annotation/freezed_annotation.dart' show immutable;

/// A place from the bundled cities list (PRD §8.5).
@immutable
class City {
  const City({
    required this.name,
    required this.asciiName,
    required this.region,
    required this.countryCode,
    required this.countryName,
    required this.lat,
    required this.lng,
    required this.population,
  });

  final String name;
  final String asciiName;

  /// First-level admin region (state, province); empty when there is none.
  final String region;
  final String countryCode;
  final String countryName;
  final double lat;
  final double lng;
  final int population;

  /// "City, Region, Country", leaving out the parts that are empty.
  String get label => placeLabel(name, region, countryName);

  @override
  bool operator ==(Object other) =>
      other is City &&
      other.name == name &&
      other.region == region &&
      other.countryCode == countryCode &&
      other.lat == lat &&
      other.lng == lng;

  @override
  int get hashCode => Object.hash(name, region, countryCode, lat, lng);
}

/// Joins the non-empty parts as "City, Region, Country".
String placeLabel(String name, String region, String country) =>
    [name, region, country].where((part) => part.isNotEmpty).join(', ');
