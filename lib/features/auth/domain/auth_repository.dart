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

  /// Confirms the Google account again, so the deletion that follows is not
  /// refused for an old sign-in. It reuses the account on the phone without a
  /// picker when it can. Run it before anything is erased. Does nothing when
  /// signed out.
  ///
  /// Throws a `CancelledFailure` if they back out, a `NetworkFailure` when
  /// offline, and another `AppFailure` otherwise.
  Future<void> confirmIdentity();

  /// Deletes the signed-in Auth user and signs out. Does nothing when signed
  /// out.
  ///
  /// May ask the user to confirm their Google account again when the sign-in
  /// is too old; throws a `CancelledFailure` if they back out, a
  /// `NetworkFailure` when offline, and another `AppFailure` otherwise.
  Future<void> deleteAccount();
}

/// Removes a user's data from the Mochi Moon service (Firestore).
abstract interface class AccountRemote {
  /// Deletes everything stored under [uid], profile last so a failed run can
  /// be retried. Throws a `NetworkFailure` when offline.
  Future<void> deleteUserData(String uid);
}

/// Wipes everything this phone stores about the user: the local database and
/// the small preference flags.
abstract interface class LocalDataEraser {
  Future<void> eraseAll();
}
