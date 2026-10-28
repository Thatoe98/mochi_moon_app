import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/places/domain/city.dart';
import 'package:mochi_moon/features/places/domain/city_index.dart';

City _city(
  String name, {
  String region = '',
  String country = 'Testland',
  int population = 1000,
  String? ascii,
}) => City(
  name: name,
  asciiName: ascii ?? name,
  region: region,
  countryCode: 'TL',
  countryName: country,
  lat: 0,
  lng: 0,
  population: population,
);

void main() {
  final index = CityIndex([
    _city('Springfield', region: 'Illinois', population: 116000),
    _city('Springfield', region: 'Massachusetts', population: 154000),
    _city('Springfield', region: 'Missouri', population: 169000),
    _city('Bangkok', population: 5100000),
    _city('Bang Pa-in', population: 20000),
    _city('Zürich', ascii: 'Zuerich', population: 341000),
    _city('New York City', region: 'New York', population: 8000000),
    _city('York', region: 'England', population: 150000),
  ]);

  test('needs at least two characters', () {
    expect(index.search(''), isEmpty);
    expect(index.search('b'), isEmpty);
    expect(index.search(' b '), isEmpty);
    expect(index.search('ba'), isNotEmpty);
  });

  test('ignores case and accents in both directions', () {
    expect(index.search('ZURICH').single.name, 'Zürich');
    expect(index.search('zürich').single.name, 'Zürich');
    expect(index.search('zuerich').single.name, 'Zürich');
  });

  test('bigger cities come first among the same kind of match', () {
    expect(index.search('bang').map((c) => c.name), ['Bangkok', 'Bang Pa-in']);
    expect(index.search('spring').map((c) => c.region), [
      'Missouri',
      'Massachusetts',
      'Illinois',
    ]);
  });

  test('a name that starts with the query beats one with a later word', () {
    expect(index.search('york').map((c) => c.name), ['York', 'New York City']);
  });

  test('can narrow by region or country', () {
    expect(index.search('springfield illinois').single.region, 'Illinois');
    expect(index.search('springfield, mass').single.region, 'Massachusetts');
    expect(index.search('bangkok testland').single.name, 'Bangkok');
    expect(index.search('bangkok france'), isEmpty);
  });

  test('stops at the limit', () {
    expect(index.search('spring', limit: 2), hasLength(2));
  });

  test('finds nothing for nonsense', () {
    expect(index.search('qqqq'), isEmpty);
  });

  test('label leaves out empty parts', () {
    expect(_city('Bangkok').label, 'Bangkok, Testland');
    expect(
      _city('Springfield', region: 'Illinois').label,
      'Springfield, Illinois, Testland',
    );
  });
}
