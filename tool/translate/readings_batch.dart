// Translates the bundled fallback readings, one sign at a time
// (assets/content/fallback_readings/en.json -> my.json).
import 'dart:convert';

import 'arb_batch.dart' show parseAnswer;
import 'burmese_check.dart';
import 'openai_chat.dart';
import 'prompts.dart';

const _fields = ['headline', 'body', 'energy', 'love'];
const _avoidCount = 3;

/// The user message for one sign. [problems] is set on a retry.
String readingsUserPrompt(
  String signId,
  List<Object?> variants, {
  List<String> problems = const [],
}) => jsonEncode({
  'task':
      'Translate the daily readings for the sign "$signId". Each variant has '
      'headline, body, energy, love and an "avoid" list of exactly '
      '$_avoidCount short items. Keep the same number of variants and the '
      'same structure. Answer {"variants": [...]}. Keep each body about as '
      'long as the English one.',
  'variants': variants,
  if (problems.isNotEmpty)
    'fix': 'your previous answer had these problems, correct them: $problems',
});

/// What is wrong with [translated] as a translation of [source]; empty when
/// it passes.
List<String> checkVariants(List<Object?> source, Object? translated) {
  if (translated is! List<Object?> || translated.length != source.length) {
    return ['"variants" must be a list of ${source.length} items'];
  }
  final problems = <String>[];
  for (var i = 0; i < source.length; i++) {
    final en = source[i]! as Map<String, Object?>;
    final my = translated[i];
    if (my is! Map<String, Object?>) {
      problems.add('variant $i is not an object');
      continue;
    }
    for (final field in _fields) {
      final value = my[field];
      if (value is! String) {
        problems.add('variant $i: "$field" is missing');
        continue;
      }
      for (final problem in checkBurmese(en[field]! as String, value)) {
        problems.add('variant $i "$field": $problem');
      }
    }
    final avoid = my['avoid'];
    final enAvoid = en['avoid']! as List<Object?>;
    if (avoid is! List<Object?> || avoid.length != _avoidCount) {
      problems.add('variant $i: "avoid" must have $_avoidCount items');
      continue;
    }
    for (var j = 0; j < avoid.length; j++) {
      final item = avoid[j];
      if (item is! String) {
        problems.add('variant $i: avoid item $j is not text');
        continue;
      }
      for (final problem in checkBurmese(enAvoid[j]! as String, item)) {
        problems.add('variant $i avoid $j: $problem');
      }
    }
  }
  return problems;
}

typedef SignResult = ({List<Object?>? variants, List<String> problems});

/// Translates the variants of one sign, retrying once if the checks fail.
Future<SignResult> translateSign({
  required ChatCall chat,
  required String signId,
  required List<Object?> source,
}) async {
  var problems = <String>[];
  for (var attempt = 0; attempt < 2; attempt++) {
    final text = await chat(
      system: systemPrompt,
      user: readingsUserPrompt(signId, source, problems: problems),
    );
    Object? variants;
    try {
      variants = parseAnswer(text)['variants'];
    } on FormatException {
      problems = ['the answer was not a JSON object'];
      continue;
    }
    problems = checkVariants(source, variants);
    if (problems.isEmpty) {
      return (variants: variants! as List<Object?>, problems: const <String>[]);
    }
  }
  return (variants: null, problems: problems);
}

/// The content of `my.json` for the signs translated so far, in the order of
/// [en].
Map<String, Object?> mergeReadings(
  Map<String, Object?> en,
  Map<String, Object?>? my,
  Map<String, List<Object?>> done,
) {
  final enReadings = en['readings']! as Map<String, Object?>;
  final myReadings = my?['readings'] as Map<String, Object?>? ?? const {};
  return {
    'version': en['version'],
    'lang': 'my',
    'readings': {
      for (final id in enReadings.keys)
        if (done[id] != null)
          id: done[id]
        else if (myReadings[id] != null)
          id: myReadings[id],
    },
  };
}

String encodeReadings(Map<String, Object?> json) =>
    '${const JsonEncoder.withIndent('  ').convert(json)}\n';
