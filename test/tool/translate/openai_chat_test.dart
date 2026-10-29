import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../../../tool/translate/openai_chat.dart';

const _key = 'sk-test-1234567890abcdef';

class _FakePost {
  _FakePost(this.responses);

  final List<({int status, String body})> responses;
  final requests = <({Uri url, Map<String, String> headers, String body})>[];

  Future<({int status, String body})> call(
    Uri url,
    Map<String, String> headers,
    String body,
  ) async {
    requests.add((url: url, headers: headers, body: body));
    return responses[requests.length - 1];
  }
}

String _answer(String content) => jsonEncode({
  'choices': [
    {
      'message': {'content': content},
    },
  ],
});

OpenAiChat _chat(_FakePost post, {List<Duration>? delays}) => OpenAiChat(
  const OpenAiSettings(apiKey: _key),
  post: post.call,
  delay: (d) async => delays?.add(d),
);

void main() {
  group('parseDotEnv', () {
    test('reads values, quotes and comments', () {
      final values = parseDotEnv('''
# a comment
OPENAI_API_KEY=abc
OPENAI_MODEL = "m-1"
EMPTY=
SINGLE='x y'
no equals here
''');
      expect(values['OPENAI_API_KEY'], 'abc');
      expect(values['OPENAI_MODEL'], 'm-1');
      expect(values['EMPTY'], '');
      expect(values['SINGLE'], 'x y');
      expect(values, hasLength(4));
    });
  });

  group('loadSettings', () {
    test('defaults to gpt-6-luna with high reasoning', () {
      final settings = loadSettings({'OPENAI_API_KEY': 'k'});
      expect(settings.model, 'gpt-6-luna');
      expect(settings.reasoningEffort, 'high');
    });

    test('prefers the environment over the .env file', () {
      final settings = loadSettings({
        'OPENAI_MODEL': 'from-env',
      }, dotEnv: 'OPENAI_API_KEY=file-key\nOPENAI_MODEL=from-file');
      expect(settings.apiKey, 'file-key');
      expect(settings.model, 'from-env');
    });

    test('needs a key and says where to put it', () {
      expect(
        () => loadSettings({}, dotEnv: 'OPENAI_API_KEY=  '),
        throwsA(
          isA<MissingKeyException>().having(
            (e) => e.message,
            'message',
            contains('.env'),
          ),
        ),
      );
    });
  });

  group('redactKeys', () {
    test('hides keys in error text', () {
      expect(
        redactKeys('Incorrect API key provided: sk-proj-abcdef123456.'),
        'Incorrect API key provided: sk-***.',
      );
      expect(redactKeys('bad abc123', apiKey: 'abc123'), 'bad ***');
    });
  });

  group('OpenAiChat', () {
    test(
      'sends model, reasoning effort, JSON mode and both messages',
      () async {
        final post = _FakePost([(status: 200, body: _answer('{"a":"b"}'))]);
        final text = await _chat(post).complete(system: 'sys', user: 'usr');

        expect(text, '{"a":"b"}');
        final request = post.requests.single;
        expect(
          request.url.toString(),
          'https://api.openai.com/v1/chat/completions',
        );
        expect(request.headers['Authorization'], 'Bearer $_key');
        final body = jsonDecode(request.body) as Map<String, Object?>;
        expect(body['model'], 'gpt-6-luna');
        expect(body['reasoning_effort'], 'high');
        expect(body['response_format'], {'type': 'json_object'});
        expect(body['messages'], [
          {'role': 'system', 'content': 'sys'},
          {'role': 'user', 'content': 'usr'},
        ]);
      },
    );

    test('retries a rate limit and then succeeds', () async {
      final post = _FakePost([
        (status: 429, body: '{"error":{"message":"slow down"}}'),
        (status: 200, body: _answer('ok')),
      ]);
      final delays = <Duration>[];
      expect(
        await _chat(post, delays: delays).complete(system: '', user: ''),
        'ok',
      );
      expect(post.requests, hasLength(2));
      expect(delays, hasLength(1));
    });

    test('gives up after the retries on a server error', () async {
      final post = _FakePost(List.filled(3, (status: 503, body: 'down')));
      await expectLater(
        _chat(post).complete(system: '', user: ''),
        throwsA(isA<OpenAiException>().having((e) => e.status, 'status', 503)),
      );
      expect(post.requests, hasLength(3));
    });

    test('does not retry a rejected model and never leaks the key', () async {
      final post = _FakePost([
        (
          status: 404,
          body: jsonEncode({
            'error': {
              'message': 'The model `gpt-6-luna` does not exist ($_key).',
            },
          }),
        ),
      ]);
      await expectLater(
        _chat(post).complete(system: '', user: ''),
        throwsA(
          isA<OpenAiException>()
              .having((e) => e.message, 'message', contains('gpt-6-luna'))
              .having((e) => e.message, 'message', isNot(contains(_key))),
        ),
      );
      expect(post.requests, hasLength(1));
    });

    test('fails on an answer with no content', () async {
      final post = _FakePost([(status: 200, body: '{"choices":[]}')]);
      await expectLater(
        _chat(post).complete(system: '', user: ''),
        throwsA(isA<OpenAiException>()),
      );
    });
  });
}
