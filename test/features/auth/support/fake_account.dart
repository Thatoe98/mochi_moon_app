import 'package:mochi_moon/features/auth/domain/auth_repository.dart';

/// Records the uids whose cloud data was deleted; throws [error] when set.
class FakeAccountRemote implements AccountRemote {
  FakeAccountRemote({this.removesAuthUser = false});

  @override
  final bool removesAuthUser;

  Exception? error;
  final deleted = <String>[];

  @override
  Future<void> deleteUserData(String uid) async {
    if (error case final failure?) throw failure;
    deleted.add(uid);
  }
}

/// Counts how many times the local data was wiped.
class FakeLocalDataEraser implements LocalDataEraser {
  int erased = 0;

  @override
  Future<void> eraseAll() async => erased++;
}
