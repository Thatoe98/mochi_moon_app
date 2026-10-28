// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_setup.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The profile steps after sign-in. Answers are kept here, not in the step
/// widgets, so going back never loses them.

@ProviderFor(ProfileSetup)
final profileSetupProvider = ProfileSetupProvider._();

/// The profile steps after sign-in. Answers are kept here, not in the step
/// widgets, so going back never loses them.
final class ProfileSetupProvider
    extends $NotifierProvider<ProfileSetup, ProfileSetupState> {
  /// The profile steps after sign-in. Answers are kept here, not in the step
  /// widgets, so going back never loses them.
  ProfileSetupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileSetupProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileSetupHash();

  @$internal
  @override
  ProfileSetup create() => ProfileSetup();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileSetupState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileSetupState>(value),
    );
  }
}

String _$profileSetupHash() => r'79c57e9e13ec4fbdfdad7d0793748b7fb09482cf';

/// The profile steps after sign-in. Answers are kept here, not in the step
/// widgets, so going back never loses them.

abstract class _$ProfileSetup extends $Notifier<ProfileSetupState> {
  ProfileSetupState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ProfileSetupState, ProfileSetupState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProfileSetupState, ProfileSetupState>,
              ProfileSetupState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
