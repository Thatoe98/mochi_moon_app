// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_step.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The "continue with Google" button on the save-your-cards screen. The state
/// is true while a sign-in is running.

@ProviderFor(SignInStep)
final signInStepProvider = SignInStepProvider._();

/// The "continue with Google" button on the save-your-cards screen. The state
/// is true while a sign-in is running.
final class SignInStepProvider extends $NotifierProvider<SignInStep, bool> {
  /// The "continue with Google" button on the save-your-cards screen. The state
  /// is true while a sign-in is running.
  SignInStepProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInStepProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInStepHash();

  @$internal
  @override
  SignInStep create() => SignInStep();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$signInStepHash() => r'0da809026539165597b89e14855cc6383219148d';

/// The "continue with Google" button on the save-your-cards screen. The state
/// is true while a sign-in is running.

abstract class _$SignInStep extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
