// Translates missing ARB strings (l10n/app_en.arb -> l10n/app_my.arb).
import 'dart:convert';

import 'burmese_check.dart';
import 'openai_chat.dart';
import 'prompts.dart';

typedef ArbMap = Map<String, Object?>;

/// Keys of [en] that need a translation: not metadata, not yet in [my] (or
/// every key when [force] is set), and matching [only] when given.
List<String> pendingKeys(
  ArbMap en,
  ArbMap my, {
  RegExp? only,
  bool force = false,
}) => [
  for (final entry in en.entries)
    if (!entry.key.startsWith('@') &&
        entry.value is String &&
        (only == null || only.hasMatch(entry.key)) &&
        (force || !my.containsKey(entry.key)))
      entry.key,
];

/// The user message for [keys]: the English text with the designer's note
/// from the `@key` metadata, plus existing translations as a glossary.
String arbUserPrompt({
  required ArbMap en,
  required ArbMap my,
  required List<String> keys,
  Map<String, List<String>> problems = const {},
}) {
  final strings = <String, Object?>{};
  for (final key in keys) {
    final meta = en['@$key'];
    final note = meta is Map<String, Object?> ? meta['description'] : null;
    strings[key] = {
      'en': en[key],
      if (note is String) 'note': note,
      if (problems[key] != null) 'fix': problems[key],
    };
  }
  final glossary = {
    for (final entry in my.entries)
      if (!entry.key.startsWith('@') &&
          entry.value is String &&
          en[entry.key] is String &&
          !keys.contains(entry.key))
        en[entry.key]! as String: entry.value,
  };
  return jsonEncode({
    'task':
        'Translate each "en" text. Answer {"<key>": "<Burmese>", ...} '
        'with exactly the keys given. Where a "fix" list is present, your '
        'previous answer for that key had those problems: correct them.',
    'strings': strings,
    'glossary_of_existing_translations': glossary,
  });
}

/// Decodes the model's answer; throws a [FormatException] if it is not a JSON
/// object. Markdown code fences are tolerated.
Map<String, Object?> parseAnswer(String text) {
  var body = text.trim();
  if (body.startsWith('```')) {
    body = body
        .replaceFirst(RegExp(r'^```[a-zA-Z]*\s*'), '')
        .replaceFirst(RegExp(r'\s*```$'), '');
  }
  final decoded = jsonDecode(body);
  if (decoded is! Map<String, Object?>) {
    throw const FormatException('the answer is not a JSON object');
  }
  return decoded;
}

typedef ArbResult = ({
  Map<String, String> done,
  Map<String, List<String>> failed,
});

/// Translates [keys], retrying the ones that fail the checks once.
Future<ArbResult> translateArb({
  required ChatCall chat,
  required ArbMap en,
  required ArbMap my,
  required List<String> keys,
}) async {
  final done = <String, String>{};
  var failed = <String, List<String>>{};
  var todo = keys;

  for (var attempt = 0; attempt < 2 && todo.isNotEmpty; attempt++) {
    final answer = await _ask(chat, en, my, todo, failed);
    failed = {};
    for (final key in todo) {
      final value = answer[key];
      if (value is! String) {
        failed[key] = ['missing from the answer'];
        continue;
      }
      final problems = checkBurmese(en[key]! as String, value);
      if (problems.isEmpty) {
        done[key] = value;
      } else {
        failed[key] = problems;
      }
    }
    todo = failed.keys.toList();
  }
  return (done: done, failed: failed);
}

Future<Map<String, Object?>> _ask(
  ChatCall chat,
  ArbMap en,
  ArbMap my,
  List<String> keys,
  Map<String, List<String>> problems,
) async {
  final text = await chat(
    system: systemPrompt,
    user: arbUserPrompt(en: en, my: my, keys: keys, problems: problems),
  );
  try {
    return parseAnswer(text);
  } on FormatException {
    return {};
  }
}

/// The new `app_my.arb` content: English key order, existing translations
/// kept, [done] added or replaced.
ArbMap mergeArb(ArbMap en, ArbMap my, Map<String, String> done) {
  final merged = <String, Object?>{'@@locale': 'my'};
  for (final entry in en.entries) {
    final key = entry.key;
    if (key.startsWith('@') || entry.value is! String) continue;
    final value = done[key] ?? my[key];
    if (value != null) merged[key] = value;
  }
  return merged;
}

String encodeArb(ArbMap arb) =>
    '${const JsonEncoder.withIndent('  ').convert(arb)}\n';
