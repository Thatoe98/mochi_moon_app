// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appLanguageRepository)
final appLanguageRepositoryProvider = AppLanguageRepositoryProvider._();

final class AppLanguageRepositoryProvider
    extends
        $FunctionalProvider<
          AppLanguageRepository,
          AppLanguageRepository,
          AppLanguageRepository
        >
    with $Provider<AppLanguageRepository> {
  AppLanguageRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLanguageRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLanguageRepositoryHash();

  @$internal
  @override
  $ProviderElement<AppLanguageRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppLanguageRepository create(Ref ref) {
    return appLanguageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLanguageRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLanguageRepository>(value),
    );
  }
}

String _$appLanguageRepositoryHash() =>
    r'68344451c3c02ae2879d7308c25cc1397085a147';

/// The user's language choice, kept in sync with what is saved.

@ProviderFor(LanguageController)
final languageControllerProvider = LanguageControllerProvider._();

/// The user's language choice, kept in sync with what is saved.
final class LanguageControllerProvider
    extends $AsyncNotifierProvider<LanguageController, AppLanguage> {
  /// The user's language choice, kept in sync with what is saved.
  LanguageControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'languageControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$languageControllerHash();

  @$internal
  @override
  LanguageController create() => LanguageController();
}

String _$languageControllerHash() =>
    r'b98c4746e01e9c9431ac5c333507ab66954f4f24';

/// The user's language choice, kept in sync with what is saved.

abstract class _$LanguageController extends $AsyncNotifier<AppLanguage> {
  FutureOr<AppLanguage> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppLanguage>, AppLanguage>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppLanguage>, AppLanguage>,
              AsyncValue<AppLanguage>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The locale the app is forced into, or null to follow the device.

@ProviderFor(appLocale)
final appLocaleProvider = AppLocaleProvider._();

/// The locale the app is forced into, or null to follow the device.

final class AppLocaleProvider
    extends $FunctionalProvider<Locale?, Locale?, Locale?>
    with $Provider<Locale?> {
  /// The locale the app is forced into, or null to follow the device.
  AppLocaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLocaleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLocaleHash();

  @$internal
  @override
  $ProviderElement<Locale?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Locale? create(Ref ref) {
    return appLocale(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale?>(value),
    );
  }
}

String _$appLocaleHash() => r'611f20f52e294d138334bcbb7f9739c3f9152ed8';

/// The language code content and notifications use: the user's choice, else
/// Burmese when the device uses it, else English.

@ProviderFor(effectiveLanguage)
final effectiveLanguageProvider = EffectiveLanguageProvider._();

/// The language code content and notifications use: the user's choice, else
/// Burmese when the device uses it, else English.

final class EffectiveLanguageProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// The language code content and notifications use: the user's choice, else
  /// Burmese when the device uses it, else English.
  EffectiveLanguageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'effectiveLanguageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$effectiveLanguageHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return effectiveLanguage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$effectiveLanguageHash() => r'3596091a8ea377f9ecccf6f4c24c09a58608ef11';
