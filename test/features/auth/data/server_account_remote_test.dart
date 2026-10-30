import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/network/network_providers.dart';
import 'package:mochi_moon/core/network/readings_api.dart';
import 'package:mochi_moon/features/auth/data/server_account_remote.dart';

import '../../../core/network/fake_http_adapter.dart';

({ServerAccountRemote remote, FakeHttpAdapter adapter}) _remote(
  Future<ResponseBody> Function(RequestOptions) handler,
) {
  final dio = createReadingsDio('https://api.example.com/v1', () async => 't');
  final adapter = FakeHttpAdapter(handler);
  dio.httpClientAdapter = adapter;
  return (remote: ServerAccountRemote(ReadingsApi(dio)), adapter: adapter);
}

void main() {
  test('sends DELETE /v1/account with the ID token', () async {
    final (:remote, :adapter) = _remote(
      (_) async => ResponseBody.fromString('', 204),
    );

    await remote.deleteUserData('uid_1');

    final request = adapter.requests.single;
    expect(request.method, 'DELETE');
    expect(request.uri.toString(), 'https://api.example.com/v1/account');
    expect(request.headers['Authorization'], 'Bearer t');
  });

  test('says the server also removes the Auth user', () {
    final (:remote, adapter: _) = _remote(
      (_) async => ResponseBody.fromString('', 204),
    );

    expect(remote.removesAuthUser, isTrue);
  });

  test('an error answer is an UnknownFailure', () async {
    final (:remote, adapter: _) = _remote(
      (_) async => errorResponse(500, 'internal'),
    );

    await expectLater(
      remote.deleteUserData('uid_1'),
      throwsA(isA<UnknownFailure>()),
    );
  });

  test('no connection is a NetworkFailure', () async {
    final (:remote, adapter: _) = _remote(
      (options) async => throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline',
      ),
    );

    await expectLater(
      remote.deleteUserData('uid_1'),
      throwsA(isA<NetworkFailure>()),
    );
  });
}
