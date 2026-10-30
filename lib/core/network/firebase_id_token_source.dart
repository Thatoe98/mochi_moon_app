import 'package:firebase_auth/firebase_auth.dart';
import 'package:mochi_moon/core/network/id_token_source.dart';

/// The signed-in user's ID token; Firebase refreshes it when it is old.
IdTokenSource firebaseIdTokenSource() => () async {
  final user = FirebaseAuth.instance.currentUser;
  return user == null ? null : await user.getIdToken();
};
