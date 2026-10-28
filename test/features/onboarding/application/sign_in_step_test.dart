import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/onboarding/application/sign_in_step.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';

import '../../auth/support/fake_auth_repository.dart';
import '../../profile/support/fake_profile.dart';

ProviderContainer _container({
  required FakeAuthRepository auth,
  FakeProfileRepository? local,
  FakeProfileRemote? remote,
}) {
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(auth),
      profileRepositoryProvider.overrideWithValue(
        local ?? FakeProfileRepository(),
      ),
      profileRemoteProvider.overrideWithValue(remote ?? FakeProfileRemote()),
    ],
  );
  addTearDown(container.dispose);
  // The notifier is auto-dispose; keep it for the whole test.
  container.listen(signInStepProvider, (_, _) {});
  return container;
}

Future<SignInOutcome> _signIn(ProviderContainer container) =>
    container.read(signInStepProvider.notifier).signIn();

Future<SignInOutcome> _failingWith(AppFailure failure) =>
    _signIn(_container(auth: FakeAuthRepository(signInError: failure)));

void main() {
  test('a new account goes on to the profile steps', () async {
    final auth = FakeAuthRepository();
    final container = _container(auth: auth);

    expect(await _signIn(container), SignInOutcome.signedIn);
    expect(auth.currentUser?.uid, 'uid_1');
  });

  test('an account that already has a profile is restored', () async {
    final profile = UserProfile(
      displayName: 'Mochi',
      birthDate: DateTime(1998, 2, 4),
    );
    final local = FakeProfileRepository();
    final container = _container(
      auth: FakeAuthRepository(),
      local: local,
      remote: FakeProfileRemote({'uid_1': profile}),
    );

    expect(await _signIn(container), SignInOutcome.restored);
    expect(local.profile, profile);
  });

  test('maps each failure to an outcome', () async {
    expect(
      await _failingWith(const CancelledFailure()),
      SignInOutcome.cancelled,
    );
    expect(
      await _failingWith(const UnavailableFailure()),
      SignInOutcome.unavailable,
    );
    expect(await _failingWith(const NetworkFailure()), SignInOutcome.offline);
    expect(await _failingWith(const UnknownFailure()), SignInOutcome.failed);
  });

  test('is busy only while signing in', () async {
    final container = _container(auth: FakeAuthRepository());
    expect(container.read(signInStepProvider), isFalse);

    final pending = _signIn(container);
    expect(container.read(signInStepProvider), isTrue);

    await pending;
    expect(container.read(signInStepProvider), isFalse);
  });
}
