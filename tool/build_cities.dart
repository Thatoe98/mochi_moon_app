// Builds assets/content/cities/cities.tsv and countries.tsv from GeoNames
// dumps (https://download.geonames.org/export/dump/, CC BY 4.0).
//
// Usage:
//   dart run tool/build_cities.dart <dir with cities15000.txt,
//       admin1CodesASCII.txt and countryInfo.txt>
//
// cities.tsv columns: name, ascii name, region, country code, lat, lng,
// population. Rows are sorted by name. countries.tsv: code, country name.
import 'dart:io';

void main(List<String> args) {
  if (args.length != 1) {
    stderr.writeln('usage: dart run tool/build_cities.dart <geonames dir>');
    exit(64);
  }
  final dir = args.single;

  final regions = <String, String>{};
  for (final line in File('$dir/admin1CodesASCII.txt').readAsLinesSync()) {
    final cols = line.split('\t');
    if (cols.length >= 3) regions[cols[0]] = cols[2];
  }

  final countries = <String, String>{};
  for (final line in File('$dir/countryInfo.txt').readAsLinesSync()) {
    if (line.startsWith('#') || line.trim().isEmpty) continue;
    final cols = line.split('\t');
    if (cols.length > 4) countries[cols[0]] = cols[4];
  }

  final rows = <List<String>>[];
  for (final line in File('$dir/cities15000.txt').readAsLinesSync()) {
    final c = line.split('\t');
    if (c.length < 15) continue;
    final countryCode = c[8];
    final region = regions['$countryCode.${c[10]}'] ?? '';
    rows.add([
      c[1], // name
      c[2], // ascii name
      region,
      countryCode,
      double.parse(c[4]).toStringAsFixed(4), // lat
      double.parse(c[5]).toStringAsFixed(4), // lng
      c[14], // population
    ]);
  }
  rows.sort((a, b) => a[0].compareTo(b[0]));

  final out = Directory('assets/content/cities')..createSync(recursive: true);
  File('${out.path}/cities.tsv')
      .writeAsStringSync('${rows.map((r) => r.join('\t')).join('\n')}\n');
  final used = {for (final r in rows) r[3]};
  File('${out.path}/countries.tsv').writeAsStringSync(
    '${[for (final code in used.toList()..sort()) '$code\t${countries[code] ?? code}'].join('\n')}\n',
  );
  stdout.writeln('${rows.length} cities, ${used.length} countries');
}
