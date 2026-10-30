// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(analyticsConsentRepository)
final analyticsConsentRepositoryProvider =
    AnalyticsConsentRepositoryProvider._();

final class AnalyticsConsentRepositoryProvider
    extends
        $FunctionalProvider<
          AnalyticsConsentRepository,
          AnalyticsConsentRepository,
          AnalyticsConsentRepository
        >
    with $Provider<AnalyticsConsentRepository> {
  AnalyticsConsentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsConsentRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsConsentRepositoryHash();

  @$internal
  @override
  $ProviderElement<AnalyticsConsentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AnalyticsConsentRepository create(Ref ref) {
    return analyticsConsentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsConsentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsConsentRepository>(value),
    );
  }
}

String _$analyticsConsentRepositoryHash() =>
    r'588461a955fd953e96a4a959a5e8bf44607d0890';

/// The analytics service. Nothing is attached yet, so nothing is sent.

@ProviderFor(analyticsSink)
final analyticsSinkProvider = AnalyticsSinkProvider._();

/// The analytics service. Nothing is attached yet, so nothing is sent.

final class AnalyticsSinkProvider
    extends $FunctionalProvider<AnalyticsSink, AnalyticsSink, AnalyticsSink>
    with $Provider<AnalyticsSink> {
  /// The analytics service. Nothing is attached yet, so nothing is sent.
  AnalyticsSinkProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsSinkProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsSinkHash();

  @$internal
  @override
  $ProviderElement<AnalyticsSink> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AnalyticsSink create(Ref ref) {
    return analyticsSink(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsSink value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsSink>(value),
    );
  }
}

String _$analyticsSinkHash() => r'86f3bf961cac6d617bffa455aee701ad640a6892';

/// The user's analytics answer: null until they answer, then true or false.

@ProviderFor(AnalyticsConsentController)
final analyticsConsentControllerProvider =
    AnalyticsConsentControllerProvider._();

/// The user's analytics answer: null until they answer, then true or false.
final class AnalyticsConsentControllerProvider
    extends $AsyncNotifierProvider<AnalyticsConsentController, bool?> {
  /// The user's analytics answer: null until they answer, then true or false.
  AnalyticsConsentControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsConsentControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsConsentControllerHash();

  @$internal
  @override
  AnalyticsConsentController create() => AnalyticsConsentController();
}

String _$analyticsConsentControllerHash() =>
    r'6fca7c5a6e3b469b540324d84aedabb3d0573cbf';

/// The user's analytics answer: null until they answer, then true or false.

abstract class _$AnalyticsConsentController extends $AsyncNotifier<bool?> {
  FutureOr<bool?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool?>, bool?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool?>, bool?>,
              AsyncValue<bool?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The one way to log an event; it checks consent on every call.

@ProviderFor(analyticsLogger)
final analyticsLoggerProvider = AnalyticsLoggerProvider._();

/// The one way to log an event; it checks consent on every call.

final class AnalyticsLoggerProvider
    extends
        $FunctionalProvider<AnalyticsLogger, AnalyticsLogger, AnalyticsLogger>
    with $Provider<AnalyticsLogger> {
  /// The one way to log an event; it checks consent on every call.
  AnalyticsLoggerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsLoggerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsLoggerHash();

  @$internal
  @override
  $ProviderElement<AnalyticsLogger> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AnalyticsLogger create(Ref ref) {
    return analyticsLogger(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsLogger value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsLogger>(value),
    );
  }
}

String _$analyticsLoggerHash() => r'd866ea9c58faf4bceb1b5d86f8eda3ffdbe72636';
