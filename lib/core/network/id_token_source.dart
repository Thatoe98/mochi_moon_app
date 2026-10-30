import 'package:dio/dio.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';

/// The current user's Firebase ID token, or null when signed out or when the
/// build has no Firebase.
typedef IdTokenSource = Future<String?> Function();

/// Adds `Authorization: Bearer <Firebase ID token>` to every request (PRD
/// §8.2). Without a token nothing is sent: the request fails with an
/// [UnavailableFailure] instead of going out unauthenticated.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._idToken);

  final IdTokenSource _idToken;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _idToken();
    if (token == null) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: const UnavailableFailure(),
        ),
      );
      return;
    }
    options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }
}
