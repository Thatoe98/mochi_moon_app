import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/auth/domain/auth_repository.dart';

/// Stands in when Firebase did not start (no `google-services.json` yet, as in
/// early dev builds). The rest of the app keeps working signed out.
class UnavailableAuthRepository implements AuthRepository {
  const UnavailableAuthRepository();

  @override
  AuthUser? get currentUser => null;

  @override
  Stream<AuthUser?> authStateChanges() => Stream.value(null);

  @override
  Future<AuthUser> signInWithGoogle() =>
      Future.error(const UnavailableFailure());

  @override
  Future<void> signOut() async {}

  @override
  Future<void> confirmIdentity() async {}

  @override
  Future<void> deleteAccount() async {}
}
