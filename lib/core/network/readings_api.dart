import 'package:dio/dio.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';

/// An error answer from the Readings API (PRD §8.2):
/// `{ "error": { "code": "...", "message": "..." } }` with an HTTP status.
class ReadingsApiException implements Exception {
  const ReadingsApiException({required this.status, this.code, this.message});

  final int status;
  final String? code;
  final String? message;

  bool get isNotFound => status == 404;

  @override
  String toString() => 'ReadingsApiException($status, $code)';
}

/// JSON calls to the Readings API. Transport problems come out as a
/// [NetworkFailure], error answers as a [ReadingsApiException], and a
/// missing sign-in as an [UnavailableFailure].
class ReadingsApi {
  ReadingsApi(this._dio);

  final Dio _dio;

  Future<Map<String, Object?>> getJson(
    String path, {
    Map<String, Object?>? query,
  }) async {
    try {
      final response = await _dio.get<Object?>(path, queryParameters: query);
      final data = response.data;
      if (data is Map<String, Object?>) return data;
      throw const FormatException(
        'The Readings API sent something else than a JSON object.',
      );
    } on DioException catch (error) {
      throw _translate(error);
    }
  }

  /// A JSON `POST` that answers with a JSON object (200 or 202).
  Future<Map<String, Object?>> postJson(
    String path,
    Map<String, Object?> body,
  ) async {
    try {
      final response = await _dio.post<Object?>(path, data: body);
      final data = response.data;
      if (data is Map<String, Object?>) return data;
      throw const FormatException(
        'The Readings API sent something else than a JSON object.',
      );
    } on DioException catch (error) {
      throw _translate(error);
    }
  }

  /// A `DELETE` that answers with no body. [receiveTimeout] is for calls that
  /// do real work on the server before they answer.
  Future<void> delete(String path, {Duration? receiveTimeout}) async {
    try {
      await _dio.delete<Object?>(
        path,
        options: Options(receiveTimeout: receiveTimeout),
      );
    } on DioException catch (error) {
      throw _translate(error);
    }
  }

  Exception _translate(DioException error) {
    if (error.error is AppFailure) return error.error! as AppFailure;
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.badResponse:
        final response = error.response;
        final body = response?.data;
        final detail = body is Map<String, Object?> ? body['error'] : null;
        return ReadingsApiException(
          status: response?.statusCode ?? 0,
          code: detail is Map<String, Object?>
              ? detail['code'] as String?
              : null,
          message: detail is Map<String, Object?>
              ? detail['message'] as String?
              : null,
        );
      case DioExceptionType.transformTimeout:
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return UnknownFailure(error.type);
    }
  }
}
