import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/auth/domain/auth_repository.dart';

/// Google sign-in through Firebase Auth. The Android web client id comes from
/// `google-services.json` (`default_web_client_id`), so none is passed here.
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
    : _auth = auth ?? FirebaseAuth.instance,
      _google = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth _auth;
  final GoogleSignIn _google;
  Future<void>? _googleReady;

  @override
  AuthUser? get currentUser => _toUser(_auth.currentUser);

  @override
  Stream<AuthUser?> authStateChanges() => _auth.authStateChanges().map(_toUser);

  @override
  Future<AuthUser> signInWithGoogle() async {
    try {
      await (_googleReady ??= _google.initialize());
      final account = await _google.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const UnknownFailure('Google sent no id token');
      }
      final credential = await _auth.signInWithCredential(
        GoogleAuthProvider.credential(idToken: idToken),
      );
      final user = _toUser(credential.user);
      if (user == null) throw const UnknownFailure('Firebase returned no user');
      return user;
    } on GoogleSignInException catch (error) {
      throw switch (error.code) {
        GoogleSignInExceptionCode.canceled ||
        GoogleSignInExceptionCode.interrupted => const CancelledFailure(),
        _ => UnknownFailure(error),
      };
    } on FirebaseAuthException catch (error) {
      throw error.code == 'network-request-failed'
          ? const NetworkFailure()
          : UnknownFailure(error);
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    try {
      await (_googleReady ??= _google.initialize());
      await _google.signOut();
    } on GoogleSignInException {
      // Firebase is already signed out; a stale Google session is harmless.
    }
  }

  /// Re-checks the signed-in Google account, but only when the phone can do it
  /// silently. Without a silent account (or with a different one on the
  /// phone) it does nothing: a picker here only confuses, and choosing the
  /// wrong account makes Firebase reject the check. The two confirmation
  /// dialogs already guard against accidents.
  @override
  Future<void> confirmIdentity() async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      await (_googleReady ??= _google.initialize());
      final account = await _google.attemptLightweightAuthentication();
      final idToken = account?.authentication.idToken;
      if (idToken == null) return;
      await user.reauthenticateWithCredential(
        GoogleAuthProvider.credential(idToken: idToken),
      );
    } on GoogleSignInException {
      // No silent account; carry on.
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'network-request-failed':
          throw const NetworkFailure();
        case 'user-mismatch':
        case 'invalid-credential':
        case 'user-not-found':
          // Another Google account is on the phone; nothing to confirm.
          return;
        default:
          throw UnknownFailure(error);
      }
    }
  }

  @override
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      try {
        await user.delete();
      } on FirebaseAuthException catch (error) {
        if (error.code != 'requires-recent-login') rethrow;
        await user.reauthenticateWithCredential(await _googleCredential());
        await user.delete();
      }
    } on GoogleSignInException catch (error) {
      throw switch (error.code) {
        GoogleSignInExceptionCode.canceled ||
        GoogleSignInExceptionCode.interrupted => const CancelledFailure(),
        _ => UnknownFailure(error),
      };
    } on FirebaseAuthException catch (error) {
      throw error.code == 'network-request-failed'
          ? const NetworkFailure()
          : UnknownFailure(error);
    }
    // The Auth user is gone; clear the Google session so the account picker
    // shows again on the next sign-in.
    try {
      await (_googleReady ??= _google.initialize());
      await _google.signOut();
    } on GoogleSignInException {
      // Nothing left to protect; a stale Google session is harmless.
    }
  }

  /// Shows the Google account picker. Only used when Firebase insists on a
  /// recent sign-in before deleting the Auth user itself.
  Future<AuthCredential> _googleCredential() async {
    await (_googleReady ??= _google.initialize());
    final account = await _google.authenticate();
    final idToken = account.authentication.idToken;
    if (idToken == null) throw const UnknownFailure('Google sent no id token');
    return GoogleAuthProvider.credential(idToken: idToken);
  }

  static AuthUser? _toUser(User? user) => user == null
      ? null
      : AuthUser(uid: user.uid, displayName: user.displayName);
}
