import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_step.g.dart';

/// How the Google sign-in button ended.
enum SignInOutcome {
  /// Signed in; the profile steps come next.
  signedIn,

  /// Signed in and this account already has a profile, so the steps are done.
  restored,

  /// The user closed the account picker.
  cancelled,

  /// This build has no Firebase config.
  unavailable,
  offline,
  failed,
}

/// The "continue with Google" button on the save-your-cards screen. The state
/// is true while a sign-in is running.
@riverpod
class SignInStep extends _$SignInStep {
  @override
  bool build() => false;

  Future<SignInOutcome> signIn() async {
    if (state) return SignInOutcome.cancelled;
    state = true;
    try {
      final user = await ref.read(authRepositoryProvider).signInWithGoogle();
      final profile = await ref
          .read(profileControllerProvider.notifier)
          .reconcile(user.uid);
      return profile != null && profile.isComplete
          ? SignInOutcome.restored
          : SignInOutcome.signedIn;
    } on AppFailure catch (failure) {
      return switch (failure) {
        CancelledFailure() => SignInOutcome.cancelled,
        UnavailableFailure() => SignInOutcome.unavailable,
        NetworkFailure() => SignInOutcome.offline,
        UnknownFailure() => SignInOutcome.failed,
      };
    } finally {
      state = false;
    }
  }
}
