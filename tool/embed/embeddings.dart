// Embeddings for the For You deck (PRD §7.2): a small OpenAI embedding model,
// reduced to 128 dimensions and quantized to int8. Only quote texts are sent.
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import '../translate/openai_chat.dart';

const embeddingModel = 'text-embedding-3-small';
const embeddingDims = 128;

/// [v] scaled to length 1. A zero vector stays zero.
List<double> unitVector(List<double> v) {
  var sum = 0.0;
  for (final x in v) {
    sum += x * x;
  }
  if (sum == 0) return List<double>.of(v);
  final length = math.sqrt(sum);
  return [for (final x in v) x / length];
}

/// [v] scaled to length 1, as int8 (each value times 127), base64.
String quantize(List<double> v) {
  final unit = unitVector(v);
  final bytes = Int8List(unit.length);
  for (var i = 0; i < unit.length; i++) {
    bytes[i] = (unit[i] * 127).round().clamp(-127, 127);
  }
  return base64Encode(bytes.buffer.asUint8List());
}

/// The inverse of [quantize], as a length-1 vector.
List<double> dequantize(String encoded) {
  final bytes = base64Decode(encoded).buffer.asInt8List();
  return unitVector([for (final b in bytes) b / 127]);
}

/// The normalized mean direction of [vectors], quantized.
String centroid(List<List<double>> vectors) {
  final sum = List<double>.filled(vectors.first.length, 0);
  for (final v in vectors) {
    final unit = unitVector(v);
    for (var i = 0; i < sum.length; i++) {
      sum[i] += unit[i];
    }
  }
  return quantize(sum);
}

class OpenAiEmbeddings {
  OpenAiEmbeddings(
    this.settings, {
    HttpPost? post,
    Future<void> Function(Duration)? delay,
    this.maxRetries = 2,
  }) : _post = post ?? dartIoPost,
       _delay = delay ?? Future<void>.delayed;

  static final Uri _url = Uri.parse('https://api.openai.com/v1/embeddings');

  final OpenAiSettings settings;
  final int maxRetries;
  final HttpPost _post;
  final Future<void> Function(Duration) _delay;

  String requestBody(List<String> texts) => jsonEncode({
    'model': embeddingModel,
    'input': texts,
    'dimensions': embeddingDims,
    'encoding_format': 'float',
  });

  /// One vector per text, in the same order.
  Future<List<List<double>>> embed(List<String> texts) async {
    final headers = {
      'Authorization': 'Bearer ${settings.apiKey}',
      'Content-Type': 'application/json; charset=utf-8',
    };
    final body = requestBody(texts);
    for (var attempt = 0; ; attempt++) {
      final response = await _post(_url, headers, body);
      if (response.status == 200) {
        return parseResponse(response.body, texts.length);
      }
      final retryable = response.status == 429 || response.status >= 500;
      if (retryable && attempt < maxRetries) {
        await _delay(Duration(seconds: 5 * (attempt + 1)));
        continue;
      }
      final text = response.body.length > 300
          ? response.body.substring(0, 300)
          : response.body;
      throw OpenAiException(
        response.status,
        redactKeys(text, apiKey: settings.apiKey),
      );
    }
  }

  /// Reads the `data` list, ordered by `index`; checks the count and size.
  List<List<double>> parseResponse(String body, int expected) {
    final json = jsonDecode(body) as Map<String, Object?>;
    final data = (json['data'] as List<Object?>?) ?? const [];
    if (data.length != expected) {
      throw OpenAiException(
        200,
        'expected $expected vectors, got ${data.length}',
      );
    }
    final rows = [for (final d in data) d! as Map<String, Object?>]
      ..sort((a, b) => (a['index']! as int).compareTo(b['index']! as int));
    final vectors = [
      for (final row in rows)
        [
          for (final x in row['embedding']! as List<Object?>)
            (x! as num).toDouble(),
        ],
    ];
    if (vectors.any((v) => v.length != embeddingDims)) {
      throw const OpenAiException(200, 'a vector had the wrong size');
    }
    return vectors;
  }
}
