/// The signed-in account. Only what the app needs; never a token.
class AuthUser {
  const AuthUser({required this.uid, this.displayName});

  final String uid;
  final String? displayName;
}

abstract interface class AuthRepository {
  /// The current account now, or null when signed out.
  AuthUser? get currentUser;

  /// Emits whenever the user signs in or out; starts with the current state.
  Stream<AuthUser?> authStateChanges();

  /// Opens the Google account picker and signs in.
  ///
  /// Throws a `CancelledFailure` when the user backs out, an
  /// `UnavailableFailure` when the build has no Firebase config, and another
  /// `AppFailure` otherwise.
  Future<AuthUser> signInWithGoogle();

  Future<void> signOut();
}
