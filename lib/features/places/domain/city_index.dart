import 'package:mochi_moon/features/places/domain/city.dart';

/// Offline search over the cities list (PRD §6.1).
///
/// Case and accents do not matter ("zurich" finds Zürich). Cities whose name
/// starts with the query come first, then names with a word that does, then
/// matches on the region or country as well ("springfield illinois"). Within
/// each group bigger cities come first.
class CityIndex {
  CityIndex(this.cities)
    : _names = [for (final c in cities) fold(c.name)],
      _asciiNames = [for (final c in cities) fold(c.asciiName)],
      _words = [
        for (final c in cities)
          fold('${c.asciiName} ${c.region} ${c.countryName}'),
      ];

  /// Fewest characters before anything is searched.
  static const minQueryLength = 2;

  final List<City> cities;
  // GeoNames spells some ASCII names differently from the accent-stripped
  // name (Zürich is "Zuerich"), so a query can match either.
  final List<String> _names;
  final List<String> _asciiNames;
  final List<String> _words;

  List<City> search(String query, {int limit = 20}) {
    final q = fold(query).trim();
    if (q.length < minQueryLength) return const [];
    final tokens = q
        .split(RegExp(r'[\s,]+'))
        .where((t) => t.isNotEmpty)
        .toList();

    final hits = <(int, int)>[]; // (rank, index)
    for (var i = 0; i < cities.length; i++) {
      final rank = _rank(_names[i], q) ?? _rank(_asciiNames[i], q);
      if (rank != null) {
        hits.add((rank, i));
      } else if (tokens.length > 1 &&
          tokens.every((t) => _hasWord(_words[i], t))) {
        hits.add((2, i));
      }
    }
    hits.sort((a, b) {
      final byRank = a.$1.compareTo(b.$1);
      if (byRank != 0) return byRank;
      final byPopulation = cities[b.$2].population.compareTo(
        cities[a.$2].population,
      );
      return byPopulation != 0 ? byPopulation : a.$2.compareTo(b.$2);
    });
    return [for (final hit in hits.take(limit)) cities[hit.$2]];
  }

  /// 0 when [name] starts with [q], 1 when one of its words does.
  static int? _rank(String name, String q) {
    if (name.startsWith(q)) return 0;
    return name.contains(' $q') || name.contains('-$q') ? 1 : null;
  }

  static bool _hasWord(String text, String prefix) =>
      text.startsWith(prefix) ||
      text.contains(' $prefix') ||
      text.contains('-$prefix');

  /// Lower case with the common Latin accents removed.
  static String fold(String text) {
    final out = StringBuffer();
    for (final rune in text.toLowerCase().runes) {
      final char = String.fromCharCode(rune);
      out.write(_accents[char] ?? char);
    }
    return out.toString();
  }

  static final Map<String, String> _accents = {
    for (final entry in const {
      'a': 'àáâãäåāăą',
      'c': 'çćčĉċ',
      'd': 'ďđ',
      'e': 'èéêëēĕėęě',
      'g': 'ĝğġģ',
      'h': 'ĥħ',
      'i': 'ìíîïĩīĭįı',
      'j': 'ĵ',
      'k': 'ķ',
      'l': 'ĺļľŀł',
      'n': 'ñńņňŉ',
      'o': 'òóôõöøōŏő',
      'r': 'ŕŗř',
      's': 'śŝşšș',
      't': 'ţťŧț',
      'u': 'ùúûüũūŭůűų',
      'w': 'ŵ',
      'y': 'ýÿŷ',
      'z': 'źżž',
    }.entries)
      for (final char in entry.value.split('')) char: entry.key,
  };
}
