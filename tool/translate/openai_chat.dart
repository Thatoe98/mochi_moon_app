// A minimal OpenAI Chat Completions client on dart:io, so the tool adds no
// dependency to the app. The key is never printed or stored.
import 'dart:convert';
import 'dart:io';

/// Posts [body] to [url] and returns the status code and response text.
typedef HttpPost = Future<({int status, String body})> Function(
  Uri url,
  Map<String, String> headers,
  String body,
);

/// Sends one prompt and returns the model's answer text.
typedef ChatCall = Future<String> Function({
  required String system,
  required String user,
});

const _defaultModel = 'gpt-6-luna';
const _defaultEffort = 'high';

class OpenAiSettings {
  const OpenAiSettings({
    required this.apiKey,
    this.model = _defaultModel,
    this.reasoningEffort = _defaultEffort,
  });

  final String apiKey;
  final String model;
  final String reasoningEffort;
}

/// Reads `KEY=value` lines. Blank lines and `#` comments are skipped, and a
/// value may be wrapped in single or double quotes.
Map<String, String> parseDotEnv(String text) {
  final values = <String, String>{};
  for (final raw in text.split('\n')) {
    final line = raw.trim();
    if (line.isEmpty || line.startsWith('#')) continue;
    final eq = line.indexOf('=');
    if (eq <= 0) continue;
    final key = line.substring(0, eq).trim();
    var value = line.substring(eq + 1).trim();
    if (value.length >= 2 &&
        (value.startsWith('"') && value.endsWith('"') ||
            value.startsWith("'") && value.endsWith("'"))) {
      value = value.substring(1, value.length - 1);
    }
    values[key] = value;
  }
  return values;
}

/// Settings from the environment, then from [dotEnv] (the text of a local,
/// gitignored `.env`). Throws a [MissingKeyException] without a key.
OpenAiSettings loadSettings(Map<String, String> env, {String? dotEnv}) {
  final file = dotEnv == null ? const <String, String>{} : parseDotEnv(dotEnv);
  String? pick(String name) {
    final value = env[name] ?? file[name];
    return value == null || value.trim().isEmpty ? null : value.trim();
  }

  final apiKey = pick('OPENAI_API_KEY');
  if (apiKey == null) {
    throw const MissingKeyException(
      'OPENAI_API_KEY is not set. Set it in the environment or in a local '
      '.env file (which is gitignored).',
    );
  }
  return OpenAiSettings(
    apiKey: apiKey,
    model: pick('OPENAI_MODEL') ?? _defaultModel,
    reasoningEffort: pick('OPENAI_REASONING_EFFORT') ?? _defaultEffort,
  );
}

class MissingKeyException implements Exception {
  const MissingKeyException(this.message);

  final String message;

  @override
  String toString() => message;
}

class OpenAiException implements Exception {
  const OpenAiException(this.status, this.message);

  final int status;
  final String message;

  @override
  String toString() => 'OpenAI error $status: $message';
}

/// Removes anything that looks like an API key from [text].
String redactKeys(String text, {String? apiKey}) {
  var out = text.replaceAll(RegExp(r'sk-[A-Za-z0-9_\-]{6,}'), 'sk-***');
  if (apiKey != null && apiKey.isNotEmpty) {
    out = out.replaceAll(apiKey, '***');
  }
  return out;
}

Future<({int status, String body})> _dartIoPost(
  Uri url,
  Map<String, String> headers,
  String body,
) async {
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 30);
  try {
    final request = await client.postUrl(url);
    headers.forEach(request.headers.set);
    request.add(utf8.encode(body));
    // High reasoning effort can take minutes.
    final response = await request.close().timeout(const Duration(minutes: 10));
    final text = await response.transform(utf8.decoder).join();
    return (status: response.statusCode, body: text);
  } finally {
    client.close();
  }
}

class OpenAiChat {
  OpenAiChat(
    this.settings, {
    HttpPost? post,
    Future<void> Function(Duration)? delay,
    this.maxRetries = 2,
  }) : _post = post ?? _dartIoPost,
       _delay = delay ?? Future<void>.delayed;

  static final Uri _url = Uri.parse(
    'https://api.openai.com/v1/chat/completions',
  );

  final OpenAiSettings settings;
  final int maxRetries;
  final HttpPost _post;
  final Future<void> Function(Duration) _delay;

  /// The request body for one prompt. The model is asked for a JSON object.
  String requestBody({required String system, required String user}) =>
      jsonEncode({
        'model': settings.model,
        'reasoning_effort': settings.reasoningEffort,
        'response_format': {'type': 'json_object'},
        'messages': [
          {'role': 'system', 'content': system},
          {'role': 'user', 'content': user},
        ],
      });

  Future<String> complete({
    required String system,
    required String user,
  }) async {
    final body = requestBody(system: system, user: user);
    final headers = {
      'Authorization': 'Bearer ${settings.apiKey}',
      'Content-Type': 'application/json; charset=utf-8',
    };
    for (var attempt = 0; ; attempt++) {
      final response = await _post(_url, headers, body);
      if (response.status == 200) return _content(response.body);
      final retryable = response.status == 429 || response.status >= 500;
      if (retryable && attempt < maxRetries) {
        await _delay(Duration(seconds: 5 * (attempt + 1)));
        continue;
      }
      throw OpenAiException(
        response.status,
        redactKeys(_errorMessage(response.body), apiKey: settings.apiKey),
      );
    }
  }

  String _content(String body) {
    final json = jsonDecode(body) as Map<String, Object?>;
    final choices = json['choices'] as List<Object?>?;
    final first = choices == null || choices.isEmpty
        ? null
        : choices.first as Map<String, Object?>?;
    final message = first?['message'] as Map<String, Object?>?;
    final content = message?['content'];
    if (content is! String || content.isEmpty) {
      throw const OpenAiException(200, 'the answer had no content');
    }
    return content;
  }

  String _errorMessage(String body) {
    try {
      final json = jsonDecode(body) as Map<String, Object?>;
      final error = json['error'];
      if (error is Map<String, Object?> && error['message'] is String) {
        return error['message']! as String;
      }
    } on FormatException {
      // Not JSON; fall through to the raw text.
    }
    return body.length > 300 ? body.substring(0, 300) : body;
  }
}
