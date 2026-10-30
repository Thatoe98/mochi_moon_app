import 'package:dio/dio.dart';
import 'package:mochi_moon/core/network/firebase_id_token_source.dart';
import 'package:mochi_moon/core/network/id_token_source.dart';
import 'package:mochi_moon/core/network/readings_api.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_providers.g.dart';

/// The Readings API base URL from the flavor config; empty when the build has
/// none. `bootstrap` overrides it.
@Riverpod(keepAlive: true)
String readingsApiBaseUrl(Ref ref) => '';

/// The signed-in user's ID token for the Readings API. Always null without
/// Firebase.
@Riverpod(keepAlive: true)
IdTokenSource idTokenSource(Ref ref) => ref.watch(firebaseReadyProvider)
    ? firebaseIdTokenSource()
    : () async => null;

/// The Readings API client, or null while the build has no base URL.
@Riverpod(keepAlive: true)
ReadingsApi? readingsApi(Ref ref) {
  final baseUrl = ref.watch(readingsApiBaseUrlProvider);
  if (baseUrl.isEmpty) return null;
  final dio = createReadingsDio(baseUrl, ref.watch(idTokenSourceProvider));
  ref.onDispose(dio.close);
  return ReadingsApi(dio);
}

/// A [Dio] for the Readings API at [baseUrl] that signs every request with
/// the user's ID token.
Dio createReadingsDio(String baseUrl, IdTokenSource idToken) => Dio(
  BaseOptions(
    // A trailing slash keeps `/v1` when a relative path is added to it.
    baseUrl: baseUrl.endsWith('/') ? baseUrl : '$baseUrl/',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Accept': 'application/json'},
  ),
)..interceptors.add(AuthInterceptor(idToken));
