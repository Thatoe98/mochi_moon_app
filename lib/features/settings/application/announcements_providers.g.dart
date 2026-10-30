// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcements_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(announcementsSettingRepository)
final announcementsSettingRepositoryProvider =
    AnnouncementsSettingRepositoryProvider._();

final class AnnouncementsSettingRepositoryProvider
    extends
        $FunctionalProvider<
          AnnouncementsSettingRepository,
          AnnouncementsSettingRepository,
          AnnouncementsSettingRepository
        >
    with $Provider<AnnouncementsSettingRepository> {
  AnnouncementsSettingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'announcementsSettingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$announcementsSettingRepositoryHash();

  @$internal
  @override
  $ProviderElement<AnnouncementsSettingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AnnouncementsSettingRepository create(Ref ref) {
    return announcementsSettingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnnouncementsSettingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnnouncementsSettingRepository>(
        value,
      ),
    );
  }
}

String _$announcementsSettingRepositoryHash() =>
    r'163d387535f319fdab2164336dcc6f1a7abfddd4';

@ProviderFor(announcementsTopic)
final announcementsTopicProvider = AnnouncementsTopicProvider._();

final class AnnouncementsTopicProvider
    extends
        $FunctionalProvider<
          AnnouncementsTopic,
          AnnouncementsTopic,
          AnnouncementsTopic
        >
    with $Provider<AnnouncementsTopic> {
  AnnouncementsTopicProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'announcementsTopicProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$announcementsTopicHash();

  @$internal
  @override
  $ProviderElement<AnnouncementsTopic> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AnnouncementsTopic create(Ref ref) {
    return announcementsTopic(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnnouncementsTopic value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnnouncementsTopic>(value),
    );
  }
}

String _$announcementsTopicHash() =>
    r'3e0fd882292a8f3b401b4d038227276f401ff028';

/// Whether "App news" is on, kept in sync with the topic subscription.

@ProviderFor(AnnouncementsController)
final announcementsControllerProvider = AnnouncementsControllerProvider._();

/// Whether "App news" is on, kept in sync with the topic subscription.
final class AnnouncementsControllerProvider
    extends $AsyncNotifierProvider<AnnouncementsController, bool> {
  /// Whether "App news" is on, kept in sync with the topic subscription.
  AnnouncementsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'announcementsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$announcementsControllerHash();

  @$internal
  @override
  AnnouncementsController create() => AnnouncementsController();
}

String _$announcementsControllerHash() =>
    r'74b79ffe6d01f46831bc408cf99f6d7f912fa782';

/// Whether "App news" is on, kept in sync with the topic subscription.

abstract class _$AnnouncementsController extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Matches the topic to the saved choice once per app run. Watched from the
/// app root.

@ProviderFor(announcementsSync)
final announcementsSyncProvider = AnnouncementsSyncProvider._();

/// Matches the topic to the saved choice once per app run. Watched from the
/// app root.

final class AnnouncementsSyncProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Matches the topic to the saved choice once per app run. Watched from the
  /// app root.
  AnnouncementsSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'announcementsSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$announcementsSyncHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return announcementsSync(ref);
  }
}

String _$announcementsSyncHash() => r'82088560abefba507b8aafc613a7f7a357aae003';
