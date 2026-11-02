// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_mode_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(themeModeSettingRepository)
final themeModeSettingRepositoryProvider =
    ThemeModeSettingRepositoryProvider._();

final class ThemeModeSettingRepositoryProvider
    extends
        $FunctionalProvider<
          ThemeModeSettingRepository,
          ThemeModeSettingRepository,
          ThemeModeSettingRepository
        >
    with $Provider<ThemeModeSettingRepository> {
  ThemeModeSettingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeSettingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeSettingRepositoryHash();

  @$internal
  @override
  $ProviderElement<ThemeModeSettingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ThemeModeSettingRepository create(Ref ref) {
    return themeModeSettingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeModeSettingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeModeSettingRepository>(value),
    );
  }
}

String _$themeModeSettingRepositoryHash() =>
    r'67eb523c3c690d39693bb932638af8936cd49943';

/// The user's light/dark choice, kept in sync with what is saved.

@ProviderFor(ThemeModeController)
final themeModeControllerProvider = ThemeModeControllerProvider._();

/// The user's light/dark choice, kept in sync with what is saved.
final class ThemeModeControllerProvider
    extends $AsyncNotifierProvider<ThemeModeController, AppThemeChoice> {
  /// The user's light/dark choice, kept in sync with what is saved.
  ThemeModeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeControllerHash();

  @$internal
  @override
  ThemeModeController create() => ThemeModeController();
}

String _$themeModeControllerHash() =>
    r'27861dffad700fa6b4189ffc6f9b80e90ecb1c1c';

/// The user's light/dark choice, kept in sync with what is saved.

abstract class _$ThemeModeController extends $AsyncNotifier<AppThemeChoice> {
  FutureOr<AppThemeChoice> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppThemeChoice>, AppThemeChoice>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppThemeChoice>, AppThemeChoice>,
              AsyncValue<AppThemeChoice>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The choice as Flutter's [ThemeMode] for `MaterialApp`.

@ProviderFor(appThemeMode)
final appThemeModeProvider = AppThemeModeProvider._();

/// The choice as Flutter's [ThemeMode] for `MaterialApp`.

final class AppThemeModeProvider
    extends $FunctionalProvider<ThemeMode, ThemeMode, ThemeMode>
    with $Provider<ThemeMode> {
  /// The choice as Flutter's [ThemeMode] for `MaterialApp`.
  AppThemeModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appThemeModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appThemeModeHash();

  @$internal
  @override
  $ProviderElement<ThemeMode> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeMode create(Ref ref) {
    return appThemeMode(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$appThemeModeHash() => r'9288f7ab942b0a9c7adf87682deeda61e690eafb';
