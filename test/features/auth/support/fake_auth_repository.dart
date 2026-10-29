import 'dart:async';

import 'package:mochi_moon/features/auth/domain/auth_repository.dart';

/// In-memory [AuthRepository] for tests. Signing in succeeds with [account]
/// unless [signInError] is set.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    this.account = const AuthUser(uid: 'uid_1', displayName: 'Mochi'),
    this.signInError,
    AuthUser? signedIn,
  }) : _current = signedIn;

  final AuthUser account;

  /// When set, `signInWithGoogle` throws it.
  final Exception? signInError;

  AuthUser? _current;
  final _changes = StreamController<AuthUser?>.broadcast();
  int signInCalls = 0;

  @override
  AuthUser? get currentUser => _current;

  @override
  Stream<AuthUser?> authStateChanges() async* {
    yield _current;
    yield* _changes.stream;
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    signInCalls++;
    if (signInError case final error?) throw error;
    _current = account;
    _changes.add(account);
    return account;
  }

  @override
  Future<void> signOut() async {
    _current = null;
    _changes.add(null);
  }

  /// When set, `deleteAccount` throws it and keeps the user signed in.
  Exception? deleteError;
  int deleteCalls = 0;

  @override
  Future<void> deleteAccount() async {
    deleteCalls++;
    if (deleteError case final error?) throw error;
    _current = null;
    _changes.add(null);
  }
}
