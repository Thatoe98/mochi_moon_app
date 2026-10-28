// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(imageSharer)
final imageSharerProvider = ImageSharerProvider._();

final class ImageSharerProvider
    extends $FunctionalProvider<ImageSharer, ImageSharer, ImageSharer>
    with $Provider<ImageSharer> {
  ImageSharerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageSharerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageSharerHash();

  @$internal
  @override
  $ProviderElement<ImageSharer> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ImageSharer create(Ref ref) {
    return imageSharer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageSharer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageSharer>(value),
    );
  }
}

String _$imageSharerHash() => r'd0ccda2bf1a9d31b9df4f827c13d46533e2e5d26';

/// Social handle printed on shared images, e.g. `@mochimoon`. Set with
/// `--dart-define=SHARE_HANDLE=...`; the image shows only the wordmark when
/// it is empty.

@ProviderFor(shareHandle)
final shareHandleProvider = ShareHandleProvider._();

/// Social handle printed on shared images, e.g. `@mochimoon`. Set with
/// `--dart-define=SHARE_HANDLE=...`; the image shows only the wordmark when
/// it is empty.

final class ShareHandleProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Social handle printed on shared images, e.g. `@mochimoon`. Set with
  /// `--dart-define=SHARE_HANDLE=...`; the image shows only the wordmark when
  /// it is empty.
  ShareHandleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shareHandleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shareHandleHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return shareHandle(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$shareHandleHash() => r'4bc79521b2319b9717d2833d7d2e9add99064289';
