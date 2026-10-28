import 'package:mochi_moon/features/deck/data/share_plus_image_sharer.dart';
import 'package:mochi_moon/features/deck/domain/image_sharer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'share_providers.g.dart';

@Riverpod(keepAlive: true)
ImageSharer imageSharer(Ref ref) => const SharePlusImageSharer();

/// Social handle printed on shared images, e.g. `@mochimoon`. Set with
/// `--dart-define=SHARE_HANDLE=...`; the image shows only the wordmark when
/// it is empty.
@Riverpod(keepAlive: true)
String? shareHandle(Ref ref) {
  const handle = String.fromEnvironment('SHARE_HANDLE');
  return handle.isEmpty ? null : handle;
}
