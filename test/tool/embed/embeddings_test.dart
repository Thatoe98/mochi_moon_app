import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

import '../../../tool/embed/embeddings.dart';
import '../../../tool/translate/openai_chat.dart';

double _dot(List<double> a, List<double> b) {
  var s = 0.0;
  for (var i = 0; i < a.length; i++) {
    s += a[i] * b[i];
  }
  return s;
}

List<double> _vec(int seed) {
  final r = math.Random(seed);
  return [for (var i = 0; i < embeddingDims; i++) r.nextDouble() - 0.5];
}

void main() {
  test('a vector matches itself after the quantize round trip', () {
    final v = _vec(1);
    final back = dequantize(quantize(v));
    expect(_dot(unitVector(v), back), greaterThan(0.999));
    expect(base64Decode(quantize(v)), hasLength(embeddingDims));
  });

  test('different vectors stay different', () {
    final a = dequantize(quantize(_vec(1)));
    final b = dequantize(quantize(_vec(2)));
    expect(_dot(a, b), lessThan(0.5));
  });

  test('a centroid points between its vectors', () {
    final a = _vec(1);
    final b = _vec(2);
    final c = dequantize(centroid([a, b]));
    expect(_dot(c, unitVector(a)), greaterThan(0.5));
    expect(_dot(c, unitVector(b)), greaterThan(0.5));
  });

  group('OpenAiEmbeddings', () {
    const settings = OpenAiSettings(apiKey: 'sk-test-key-123456');

    String answer(List<List<double>> rows) => jsonEncode({
      'data': [
        // Out of order on purpose.
        for (var i = rows.length - 1; i >= 0; i--)
          {'index': i, 'embedding': rows[i]},
      ],
    });

    test('sends the model, size and texts, and orders the answer', () async {
      String? sent;
      final client = OpenAiEmbeddings(
        settings,
        post: (url, headers, body) async {
          sent = body;
          return (status: 200, body: answer([_vec(1), _vec(2)]));
        },
      );
      final out = await client.embed(['one', 'two']);
      final request = jsonDecode(sent!) as Map<String, Object?>;
      expect(request['model'], embeddingModel);
      expect(request['dimensions'], embeddingDims);
      expect(request['input'], ['one', 'two']);
      expect(out[0], _vec(1));
      expect(out[1], _vec(2));
    });

    test('retries a rate limit, then fails with a redacted error', () async {
      var calls = 0;
      final client = OpenAiEmbeddings(
        settings,
        delay: (_) async {},
        post: (url, headers, body) async {
          calls++;
          return (status: 429, body: 'slow down sk-test-key-123456');
        },
      );
      await expectLater(
        client.embed(['x']),
        throwsA(
          isA<OpenAiException>().having(
            (e) => e.message,
            'message',
            isNot(contains('sk-test')),
          ),
        ),
      );
      expect(calls, 3);
    });

    test('a wrong count or size is refused', () async {
      final client = OpenAiEmbeddings(
        settings,
        post: (url, headers, body) async =>
            (status: 200, body: answer([_vec(1)])),
      );
      await expectLater(
        client.embed(['a', 'b']),
        throwsA(isA<OpenAiException>()),
      );
      final short = OpenAiEmbeddings(
        settings,
        post: (url, headers, body) async => (
          status: 200,
          body: answer([
            <double>[1, 2],
          ]),
        ),
      );
      await expectLater(short.embed(['a']), throwsA(isA<OpenAiException>()));
    });
  });
}
