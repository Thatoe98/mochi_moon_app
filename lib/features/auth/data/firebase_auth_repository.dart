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

  static AuthUser? _toUser(User? user) => user == null
      ? null
      : AuthUser(uid: user.uid, displayName: user.displayName);
}
