// Adds an `embedding` (base64 int8, 128 dims) to every quote in quotes.json
// and the six mood centroids (PRD §7.2). Dev-time only; the app just reads
// the result. Only the English quote texts are sent to OpenAI: no user data.
//
//   dart run tool/embed_quotes.dart [--force] [--dry-run]
//
// The key is read from OPENAI_API_KEY (environment, or the local gitignored
// .env) and is never printed.
import 'dart:convert';
import 'dart:io';

import 'embed/embeddings.dart';
import 'translate/openai_chat.dart';

const _path = 'assets/content/quotes/quotes.json';
const _batch = 100;
const _moods = ['happy', 'calm', 'tired', 'sad', 'anxious', 'in_love'];

Future<void> main(List<String> args) async {
  final force = args.contains('--force');
  final dryRun = args.contains('--dry-run');
  final file = File(_path);
  final root = jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
  final quotes = [
    for (final q in root['quotes']! as List<Object?>)
      q! as Map<String, Object?>,
  ];
  final todo = [
    for (final q in quotes)
      if (force || q['embedding'] is! String) q,
  ];
  stdout.writeln('${quotes.length} quotes, ${todo.length} to embed.');
  if (dryRun) return;

  if (todo.isNotEmpty) {
    final OpenAiSettings settings;
    try {
      final env = File('.env');
      settings = loadSettings(
        Platform.environment,
        dotEnv: env.existsSync() ? env.readAsStringSync() : null,
      );
    } on MissingKeyException catch (e) {
      stderr.writeln(e.message);
      exit(64);
    }
    final client = OpenAiEmbeddings(settings);
    try {
      for (var i = 0; i < todo.length; i += _batch) {
        final slice = todo.skip(i).take(_batch).toList();
        final texts = [
          for (final q in slice)
            (q['text']! as Map<String, Object?>)['en']! as String,
        ];
        final vectors = await client.embed(texts);
        for (var j = 0; j < slice.length; j++) {
          slice[j]['embedding'] = quantize(vectors[j]);
        }
        stdout.writeln('Embedded ${i + slice.length}/${todo.length}.');
      }
    } on OpenAiException catch (e) {
      stderr.writeln(e);
      exit(1);
    }
  }

  final centroids = <String, String>{};
  for (final mood in _moods) {
    final vectors = [
      for (final q in quotes)
        if ((q['moods']! as List<Object?>).contains(mood))
          dequantize(q['embedding']! as String),
    ];
    if (vectors.isEmpty) {
      stderr.writeln('No quote is tagged "$mood".');
      exit(1);
    }
    centroids[mood] = centroid(vectors);
  }
  root['moodCentroids'] = centroids;
  final json = const JsonEncoder.withIndent('  ').convert(root);
  file.writeAsStringSync('$json\n');
  stdout.writeln(
    'Wrote ${quotes.length} embeddings and ${centroids.length} mood centroids.',
  );
}
