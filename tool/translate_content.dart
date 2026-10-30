// Translates app copy from English into Burmese with an OpenAI model
// (CLAUDE.md §7, PRD §7.1a). Run from the project root:
//
//   dart run tool/translate_content.dart --dry-run
//   dart run tool/translate_content.dart --arb --only "^(cosmic|thaiColors)"
//   dart run tool/translate_content.dart --readings
//
// Options:
//   --arb          translate missing strings of l10n/app_en.arb
//   --readings     translate assets/content/fallback_readings/en.json
//   --quotes       add a Burmese text to assets/content/quotes/quotes.json
//                  (with none of the three flags above, all three run)
//   --web          translate the account deletion web page of the sibling
//                  mochi-moon-api repo (app/web_strings/en.json -> my.json);
//                  only runs when asked for
//   --only REGEX   only ARB keys (or quote ids) that match REGEX
//   --force        translate again even if a translation exists
//   --batch-size N ARB strings per request (default 25)
//   --dry-run      show what would be sent; make no request, write nothing
//
// The key is read from OPENAI_API_KEY (environment, or a local .env that is
// gitignored). The model is gpt-6-luna with high reasoning effort unless
// OPENAI_MODEL or OPENAI_REASONING_EFFORT say otherwise. Only the English app
// copy is sent; nothing about users.
//
// The output is unreviewed machine translation. Thai is not generated.
import 'dart:convert';
import 'dart:io';

import 'translate/arb_batch.dart';
import 'translate/openai_chat.dart';
import 'translate/quotes_batch.dart';
import 'translate/readings_batch.dart';

const _enArb = 'l10n/app_en.arb';
const _myArb = 'l10n/app_my.arb';
const _enReadings = 'assets/content/fallback_readings/en.json';
const _myReadings = 'assets/content/fallback_readings/my.json';
const _quotes = 'assets/content/quotes/quotes.json';
const _enWeb = '../mochi-moon-api/app/web_strings/en.json';
const _myWeb = '../mochi-moon-api/app/web_strings/my.json';

Future<void> main(List<String> args) async {
  final options = _Options.parse(args);
  if (options == null) {
    stderr.writeln(
      'usage: dart run tool/translate_content.dart [--arb] [--readings] [--quotes] '
      '[--web] [--only REGEX] [--force] [--batch-size N] [--dry-run]',
    );
    exit(64);
  }

  ChatCall? chat;
  OpenAiSettings? settings;
  if (!options.dryRun) {
    try {
      final envFile = File('.env');
      settings = loadSettings(
        Platform.environment,
        dotEnv: envFile.existsSync() ? envFile.readAsStringSync() : null,
      );
    } on MissingKeyException catch (e) {
      stderr.writeln(e.message);
      exit(64);
    }
    chat = OpenAiChat(settings).complete;
    stdout.writeln(
      'Model ${settings.model}, reasoning ${settings.reasoningEffort}.',
    );
  }

  var failures = 0;
  try {
    if (options.arb) failures += await _runArb(options, chat);
    if (options.readings) failures += await _runReadings(options, chat);
    if (options.quotes) failures += await _runQuotes(options, chat);
    if (options.web) failures += await _runWeb(options, chat);
  } on OpenAiException catch (e) {
    stderr.writeln(e);
    exit(1);
  }
  if (failures > 0) {
    stderr.writeln('$failures item(s) failed the checks and were not written.');
    exit(1);
  }
}

Future<int> _runArb(_Options options, ChatCall? chat) async {
  final en = _readJson(_enArb)!;
  final my = _readJson(_myArb) ?? <String, Object?>{'@@locale': 'my'};
  final keys = pendingKeys(
    en,
    my,
    only: options.only == null ? null : RegExp(options.only!),
    force: options.force,
  );
  stdout.writeln('ARB: ${keys.length} string(s) to translate.');
  if (keys.isEmpty) return 0;

  final batches = [
    for (var i = 0; i < keys.length; i += options.batchSize)
      keys.sublist(i, (i + options.batchSize).clamp(0, keys.length)),
  ];
  if (chat == null) {
    for (final batch in batches) {
      stdout.writeln('  would send ${batch.length}: ${batch.join(', ')}');
    }
    return 0;
  }

  var current = my;
  var failures = 0;
  for (final (index, batch) in batches.indexed) {
    stdout.writeln('  batch ${index + 1}/${batches.length} (${batch.length})…');
    final result = await translateArb(
      chat: chat,
      en: en,
      my: current,
      keys: batch,
    );
    current = mergeArb(en, current, result.done);
    File(_myArb).writeAsStringSync(encodeArb(current));
    stdout.writeln('    wrote ${result.done.length}');
    for (final entry in result.failed.entries) {
      failures++;
      stderr.writeln('    FAILED ${entry.key}: ${entry.value.join('; ')}');
    }
  }
  return failures;
}

Future<int> _runReadings(_Options options, ChatCall? chat) async {
  final en = _readJson(_enReadings)!;
  final my = _readJson(_myReadings);
  final enReadings = en['readings']! as Map<String, Object?>;
  final myReadings = my?['readings'] as Map<String, Object?>? ?? const {};
  final ids = [
    for (final id in enReadings.keys)
      if (options.force || !myReadings.containsKey(id)) id,
  ];
  stdout.writeln('Readings: ${ids.length} sign(s) to translate.');
  if (chat == null) {
    if (ids.isNotEmpty) stdout.writeln('  would send: ${ids.join(', ')}');
    return 0;
  }

  final done = <String, List<Object?>>{};
  var failures = 0;
  for (final (index, id) in ids.indexed) {
    stdout.writeln('  ${index + 1}/${ids.length} $id…');
    final result = await translateSign(
      chat: chat,
      signId: id,
      source: enReadings[id]! as List<Object?>,
    );
    final variants = result.variants;
    if (variants == null) {
      failures++;
      stderr.writeln('    FAILED $id: ${result.problems.join('; ')}');
      continue;
    }
    done[id] = variants;
    File(_myReadings)
        .writeAsStringSync(encodeReadings(mergeReadings(en, my, done)));
  }
  return failures;
}

Future<int> _runQuotes(_Options options, ChatCall? chat) async {
  final json = _readJson(_quotes)!;
  final quotes = json['quotes']! as List<Object?>;
  final ids = pendingQuotes(
    quotes,
    only: options.only == null ? null : RegExp(options.only!),
    force: options.force,
  );
  stdout.writeln('Quotes: ${ids.length} quote(s) to translate.');
  if (ids.isEmpty) return 0;
  if (chat == null) {
    stdout.writeln('  would send: ${ids.join(', ')}');
    return 0;
  }

  final source = quoteSource(quotes);
  final done = <String, String>{};
  var failures = 0;
  for (var i = 0; i < ids.length; i += options.batchSize) {
    final batch = ids.sublist(i, (i + options.batchSize).clamp(0, ids.length));
    stdout.writeln('  ${batch.length} quote(s)…');
    final result = await translateArb(
      chat: chat,
      en: source,
      my: const {},
      keys: batch,
    );
    done.addAll(result.done);
    File(_quotes)
        .writeAsStringSync(encodeQuotes(json, mergeQuotes(quotes, done)));
    for (final entry in result.failed.entries) {
      failures++;
      stderr.writeln('    FAILED ${entry.key}: ${entry.value.join('; ')}');
    }
  }
  return failures;
}

Future<int> _runWeb(_Options options, ChatCall? chat) async {
  final en = _readJson(_enWeb);
  if (en == null) {
    stderr.writeln(
      'Web: $_enWeb not found (is mochi-moon-api next to this repo?).',
    );
    return 1;
  }
  final my = _readJson(_myWeb) ?? <String, Object?>{};
  final keys = pendingKeys(
    en,
    my,
    only: options.only == null ? null : RegExp(options.only!),
    force: options.force,
  );
  stdout.writeln('Web page: ${keys.length} string(s) to translate.');
  if (keys.isEmpty) return 0;
  if (chat == null) {
    stdout.writeln('  would send: ${keys.join(', ')}');
    return 0;
  }

  final result = await translateArb(chat: chat, en: en, my: my, keys: keys);
  // Same key order as English; the file has no `@@locale` entry.
  final merged = <String, Object?>{
    for (final key in en.keys) key: ?(result.done[key] ?? my[key]),
  };
  File(_myWeb).writeAsStringSync(encodeArb(merged));
  stdout.writeln('    wrote ${result.done.length}');
  for (final entry in result.failed.entries) {
    stderr.writeln('    FAILED ${entry.key}: ${entry.value.join('; ')}');
  }
  return result.failed.length;
}

Map<String, Object?>? _readJson(String path) {
  final file = File(path);
  if (!file.existsSync()) return null;
  return jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
}

class _Options {
  _Options({
    required this.arb,
    required this.readings,
    required this.quotes,
    required this.web,
    required this.only,
    required this.force,
    required this.batchSize,
    required this.dryRun,
  });

  final bool arb;
  final bool readings;
  final bool quotes;
  final bool web;
  final String? only;
  final bool force;
  final int batchSize;
  final bool dryRun;

  static _Options? parse(List<String> args) {
    var arb = false;
    var readings = false;
    var quotes = false;
    var web = false;
    var force = false;
    var dryRun = false;
    String? only;
    var batchSize = 25;
    for (var i = 0; i < args.length; i++) {
      switch (args[i]) {
        case '--arb':
          arb = true;
        case '--readings':
          readings = true;
        case '--quotes':
          quotes = true;
        case '--web':
          web = true;
        case '--force':
          force = true;
        case '--dry-run':
          dryRun = true;
        case '--only':
          if (++i >= args.length) return null;
          only = args[i];
        case '--batch-size':
          if (++i >= args.length) return null;
          final n = int.tryParse(args[i]);
          if (n == null || n < 1) return null;
          batchSize = n;
        default:
          return null;
      }
    }
    if (!arb && !readings && !quotes && !web) {
      arb = true;
      readings = true;
      quotes = true;
    }
    return _Options(
      arb: arb,
      readings: readings,
      quotes: quotes,
      web: web,
      only: only,
      force: force,
      batchSize: batchSize,
      dryRun: dryRun,
    );
  }
}
