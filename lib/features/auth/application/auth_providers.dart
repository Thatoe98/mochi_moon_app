import 'package:mochi_moon/features/auth/data/firebase_auth_repository.dart';
import 'package:mochi_moon/features/auth/data/unavailable_auth_repository.dart';
import 'package:mochi_moon/features/auth/domain/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

/// Whether Firebase started. `bootstrap` overrides it once it has tried to
/// initialize; tests override it too.
@Riverpod(keepAlive: true)
bool firebaseReady(Ref ref) =>
    throw UnimplementedError('firebaseReady must be overridden');

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => ref.watch(firebaseReadyProvider)
    ? FirebaseAuthRepository()
    : const UnavailableAuthRepository();

/// The signed-in account, or null.
@Riverpod(keepAlive: true)
Stream<AuthUser?> authUser(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges();
}
