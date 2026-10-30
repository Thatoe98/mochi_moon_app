// Checks on machine-translated Burmese before it is written to the repo.
// They catch broken output, not bad translations: a Burmese reviewer still
// has to read everything (PRD §7.1a).

final _placeholder = RegExp(r'\{(\w+)[,}]');
final _myanmar = RegExp('[က-႟]');
final _asciiLetter = RegExp('[A-Za-z]');
final _burmeseDigit = RegExp('[၀-၉]');

/// Names of the ICU placeholders in [text], for example `count` in
/// `{count, plural, other{{count} days}}`.
Set<String> placeholderNames(String text) => {
  for (final match in _placeholder.allMatches(text)) match.group(1)!,
};

bool _isConsonant(int r) =>
    (r >= 0x1000 && r <= 0x1021) || (r >= 0x1023 && r <= 0x102A) || r == 0x103F;

bool _isMedial(int r) => r >= 0x103B && r <= 0x103E;

/// Whether [text] looks like Zawgyi instead of Unicode Burmese.
///
/// Zawgyi stores the vowel sign "ေ" and the medials before the consonant
/// they belong to, and uses extra code points in U+1060–U+1097. Unicode
/// always puts them after the consonant. This is a heuristic: it can miss
/// Zawgyi text with no such sign, but it does not flag valid Unicode.
bool looksLikeZawgyi(String text) {
  final runes = text.runes.toList();
  for (var i = 0; i < runes.length; i++) {
    final r = runes[i];
    if (r >= 0x1060 && r <= 0x1097) return true;
    final isVowelE = r == 0x1031;
    if (isVowelE || _isMedial(r)) {
      final previous = i == 0 ? null : runes[i - 1];
      final ok =
          previous != null && (_isConsonant(previous) || _isMedial(previous));
      if (!ok) return true;
    }
  }
  return false;
}

int _braceBalance(String text) {
  var depth = 0;
  for (final unit in text.codeUnits) {
    if (unit == 0x7B) depth++;
    if (unit == 0x7D) depth--;
    if (depth < 0) return depth;
  }
  return depth;
}

/// What is wrong with [my] as a translation of [en]; empty when it passes.
List<String> checkBurmese(String en, String my) {
  final problems = <String>[];
  if (my.trim().isEmpty) return ['empty'];

  // A one or two word label may stay in English: zodiac signs, planets and
  // "Retrogrades" are written that way in Burmese too.
  final isShortLabel = en.trim().split(RegExp(r'\s+')).length <= 2;
  if (!isShortLabel && _asciiLetter.hasMatch(en) && !_myanmar.hasMatch(my)) {
    problems.add('has no Burmese characters');
  }
  if (_burmeseDigit.hasMatch(my)) {
    problems.add('uses Burmese digits; write 0-9');
  }
  if (looksLikeZawgyi(my)) {
    problems.add('looks like Zawgyi, not Unicode');
  }

  final wanted = placeholderNames(en);
  final found = placeholderNames(my);
  if (wanted.difference(found).isNotEmpty ||
      found.difference(wanted).isNotEmpty) {
    problems.add(
      'placeholders must be exactly ${wanted.toList()..sort()}, '
      'found ${found.toList()..sort()}',
    );
  }
  if (_braceBalance(my) != 0) problems.add('unbalanced braces');

  // Burmese has no spaces between words, so word counts mean nothing; a
  // character ratio still catches an empty or runaway answer.
  if (en.length >= 20) {
    final ratio = my.length / en.length;
    if (ratio < 0.2 || ratio > 4) {
      problems.add(
        'length is out of proportion (${ratio.toStringAsFixed(1)}x)',
      );
    }
  }
  return problems;
}
