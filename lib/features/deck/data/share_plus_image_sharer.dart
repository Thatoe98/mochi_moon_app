import 'dart:typed_data';

import 'package:mochi_moon/features/deck/domain/image_sharer.dart';
import 'package:share_plus/share_plus.dart';

class SharePlusImageSharer implements ImageSharer {
  const SharePlusImageSharer();

  @override
  Future<void> sharePng(Uint8List png, {required String fileName}) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile.fromData(png, mimeType: 'image/png')],
        // XFile.fromData ignores its own name on Android and iOS.
        fileNameOverrides: [fileName],
      ),
    );
  }
}
