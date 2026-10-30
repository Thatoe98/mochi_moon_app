import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/network/readings_api.dart';
import 'package:mochi_moon/features/auth/domain/auth_repository.dart';

/// Deletes the account through the Readings API (`DELETE /v1/account`, PRD
/// §6.14). The server removes the Firestore data, the reports only it can
/// reach, and the Auth user; the caller is identified by the ID token.
class ServerAccountRemote implements AccountRemote {
  ServerAccountRemote(this._api, [this.timeout = const Duration(seconds: 60)]);

  final ReadingsApi _api;

  /// The server deletes before it answers, which takes longer than a reading.
  final Duration timeout;

  @override
  bool get removesAuthUser => true;

  @override
  Future<void> deleteUserData(String uid) async {
    try {
      await _api.delete('account', receiveTimeout: timeout);
    } on ReadingsApiException catch (error) {
      throw UnknownFailure(error);
    }
  }
}
