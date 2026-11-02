import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/network/network_providers.dart';
import 'package:mochi_moon/core/network/readings_api.dart';

import 'fake_http_adapter.dart';

({ReadingsApi api, FakeHttpAdapter adapter}) _api({
  String baseUrl = 'https://api.example.com/v1',
  String? token = 'token-123',
  Future<ResponseBody> Function(RequestOptions)? handler,
}) {
  final dio = createReadingsDio(baseUrl, () async => token);
  final adapter = FakeHttpAdapter(handler ?? (_) async => jsonResponse({}));
  dio.httpClientAdapter = adapter;
  return (api: ReadingsApi(dio), adapter: adapter);
}

void main() {
  test('sends the Firebase ID token as a Bearer header', () async {
    final (:api, :adapter) = _api();

    await api.getJson('daily');

    expect(
      adapter.requests.single.headers['Authorization'],
      'Bearer token-123',
    );
  });

  test('keeps /v1 in the path, with or without a trailing slash', () async {
    for (final base in [
      'https://api.example.com/v1',
      'https://api.example.com/v1/',
    ]) {
      final (:api, :adapter) = _api(baseUrl: base);

      await api.getJson('daily', query: {'sign': 'leo'});

      expect(
        adapter.requests.single.uri.toString(),
        startsWith('https://api.example.com/v1/daily?'),
      );
      expect(adapter.requests.single.uri.queryParameters, {'sign': 'leo'});
    }
  });

  test('sends nothing when signed out', () async {
    final (:api, :adapter) = _api(token: null);

    await expectLater(api.getJson('daily'), throwsA(isA<UnavailableFailure>()));
    expect(adapter.requests, isEmpty);
  });

  test('turns an error answer into a ReadingsApiException', () async {
    final (:api, adapter: _) = _api(
      handler: (_) async => errorResponse(404, 'not_found'),
    );

    await expectLater(
      api.getJson('daily'),
      throwsA(
        isA<ReadingsApiException>()
            .having((e) => e.status, 'status', 404)
            .having((e) => e.code, 'code', 'not_found')
            .having((e) => e.isNotFound, 'isNotFound', isTrue),
      ),
    );
  });

  test('recognizes a 402 premium_required answer', () async {
    final (:api, adapter: _) = _api(
      handler: (_) async => errorResponse(402, 'premium_required'),
    );

    await expectLater(
      api.postJson('letters/weekly', {}),
      throwsA(
        isA<ReadingsApiException>().having(
          (e) => e.isPremiumRequired,
          'isPremiumRequired',
          isTrue,
        ),
      ),
    );
  });

  test('an error answer without the usual body still has its status', () async {
    final (:api, adapter: _) = _api(
      handler: (_) async => ResponseBody.fromString('oops', 502),
    );

    await expectLater(
      api.getJson('daily'),
      throwsA(
        isA<ReadingsApiException>()
            .having((e) => e.status, 'status', 502)
            .having((e) => e.code, 'code', isNull),
      ),
    );
  });

  test('a connection problem is a NetworkFailure', () async {
    final (:api, adapter: _) = _api(
      handler: (options) async => throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline',
      ),
    );

    await expectLater(api.getJson('daily'), throwsA(isA<NetworkFailure>()));
  });

  test('a timeout is a NetworkFailure', () async {
    final (:api, adapter: _) = _api(
      handler: (options) async => throw DioException.receiveTimeout(
        timeout: const Duration(seconds: 15),
        requestOptions: options,
      ),
    );

    await expectLater(api.getJson('daily'), throwsA(isA<NetworkFailure>()));
  });

  test('an answer that is not a JSON object is a FormatException', () async {
    final (:api, adapter: _) = _api(
      handler: (_) async => jsonResponse(['not', 'an', 'object']),
    );

    await expectLater(api.getJson('daily'), throwsA(isA<FormatException>()));
  });

  test('delete sends a DELETE and accepts an empty answer', () async {
    final (:api, :adapter) = _api(
      handler: (_) async => ResponseBody.fromString('', 204),
    );

    await api.delete('account');

    expect(adapter.requests.single.method, 'DELETE');
    expect(adapter.requests.single.path, 'account');
  });

  test('delete turns an error answer into a ReadingsApiException', () async {
    final (:api, adapter: _) = _api(
      handler: (_) async => errorResponse(401, 'unauthenticated'),
    );

    await expectLater(
      api.delete('account'),
      throwsA(isA<ReadingsApiException>().having((e) => e.status, 's', 401)),
    );
  });

  group('readingsApiProvider', () {
    ProviderContainer container({required String baseUrl}) {
      final container = ProviderContainer(
        overrides: [
          readingsApiBaseUrlProvider.overrideWithValue(baseUrl),
          idTokenSourceProvider.overrideWithValue(() async => 'x'),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('is null while the build has no base URL', () {
      expect(container(baseUrl: '').read(readingsApiProvider), isNull);
    });

    test('is a client once there is a base URL', () {
      expect(
        container(baseUrl: 'https://api.example.com/v1')
            .read(readingsApiProvider),
        isNotNull,
      );
    });
  });
}
