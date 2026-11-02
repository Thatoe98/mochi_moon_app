// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_theme_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(widgetThemeRepository)
final widgetThemeRepositoryProvider = WidgetThemeRepositoryProvider._();

final class WidgetThemeRepositoryProvider
    extends
        $FunctionalProvider<
          WidgetThemeRepository,
          WidgetThemeRepository,
          WidgetThemeRepository
        >
    with $Provider<WidgetThemeRepository> {
  WidgetThemeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'widgetThemeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$widgetThemeRepositoryHash();

  @$internal
  @override
  $ProviderElement<WidgetThemeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WidgetThemeRepository create(Ref ref) {
    return widgetThemeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WidgetThemeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WidgetThemeRepository>(value),
    );
  }
}

String _$widgetThemeRepositoryHash() =>
    r'cf7a139aaa2beb7530faba81f82fa3fdb4dc2170';

/// The theme she picked, kept in sync with what is saved. It may be a Premium
/// one she no longer has; see [effectiveWidgetTheme].

@ProviderFor(WidgetThemeController)
final widgetThemeControllerProvider = WidgetThemeControllerProvider._();

/// The theme she picked, kept in sync with what is saved. It may be a Premium
/// one she no longer has; see [effectiveWidgetTheme].
final class WidgetThemeControllerProvider
    extends $AsyncNotifierProvider<WidgetThemeController, WidgetTheme> {
  /// The theme she picked, kept in sync with what is saved. It may be a Premium
  /// one she no longer has; see [effectiveWidgetTheme].
  WidgetThemeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'widgetThemeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$widgetThemeControllerHash();

  @$internal
  @override
  WidgetThemeController create() => WidgetThemeController();
}

String _$widgetThemeControllerHash() =>
    r'bbab767d1ebe4c4d31d3a74a1551b53336fe42b0';

/// The theme she picked, kept in sync with what is saved. It may be a Premium
/// one she no longer has; see [effectiveWidgetTheme].

abstract class _$WidgetThemeController extends $AsyncNotifier<WidgetTheme> {
  FutureOr<WidgetTheme> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<WidgetTheme>, WidgetTheme>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<WidgetTheme>, WidgetTheme>,
              AsyncValue<WidgetTheme>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The theme the widget shows now.

@ProviderFor(effectiveWidgetTheme)
final effectiveWidgetThemeProvider = EffectiveWidgetThemeProvider._();

/// The theme the widget shows now.

final class EffectiveWidgetThemeProvider
    extends $FunctionalProvider<WidgetTheme, WidgetTheme, WidgetTheme>
    with $Provider<WidgetTheme> {
  /// The theme the widget shows now.
  EffectiveWidgetThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'effectiveWidgetThemeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$effectiveWidgetThemeHash();

  @$internal
  @override
  $ProviderElement<WidgetTheme> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WidgetTheme create(Ref ref) {
    return effectiveWidgetTheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WidgetTheme value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WidgetTheme>(value),
    );
  }
}

String _$effectiveWidgetThemeHash() =>
    r'4dae4bc71d4143f56c2f1c1022b21ea72a3ef5ea';
