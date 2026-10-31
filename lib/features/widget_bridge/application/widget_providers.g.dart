// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(widgetPublisher)
final widgetPublisherProvider = WidgetPublisherProvider._();

final class WidgetPublisherProvider
    extends
        $FunctionalProvider<WidgetPublisher, WidgetPublisher, WidgetPublisher>
    with $Provider<WidgetPublisher> {
  WidgetPublisherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'widgetPublisherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$widgetPublisherHash();

  @$internal
  @override
  $ProviderElement<WidgetPublisher> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WidgetPublisher create(Ref ref) {
    return widgetPublisher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WidgetPublisher value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WidgetPublisher>(value),
    );
  }
}

String _$widgetPublisherHash() => r'55bfc253596adf27f1a43e3c970ffdd178e36fa7';

/// Restocks the home-screen widget with the next two weeks of cards. Watched
/// from the app root, so it runs each time the app opens. The widget is a
/// bonus: a failure here is logged and never reaches the user.

@ProviderFor(widgetSync)
final widgetSyncProvider = WidgetSyncProvider._();

/// Restocks the home-screen widget with the next two weeks of cards. Watched
/// from the app root, so it runs each time the app opens. The widget is a
/// bonus: a failure here is logged and never reaches the user.

final class WidgetSyncProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Restocks the home-screen widget with the next two weeks of cards. Watched
  /// from the app root, so it runs each time the app opens. The widget is a
  /// bonus: a failure here is logged and never reaches the user.
  WidgetSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'widgetSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$widgetSyncHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return widgetSync(ref);
  }
}

String _$widgetSyncHash() => r'77b0de899192e6494b780af62d412bfc3651c445';
