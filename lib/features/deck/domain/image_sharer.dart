import 'dart:typed_data';

/// Hands a rendered image to the system share sheet.
abstract interface class ImageSharer {
  Future<void> sharePng(Uint8List png, {required String fileName});
}
