import 'dart:typed_data';

import 'package:mochi_moon/features/deck/domain/image_sharer.dart';

/// Records what would have gone to the share sheet.
class FakeImageSharer implements ImageSharer {
  FakeImageSharer({this.error});

  /// Thrown from [sharePng] when set.
  final Exception? error;

  final List<({Uint8List png, String fileName})> shared = [];

  @override
  Future<void> sharePng(Uint8List png, {required String fileName}) async {
    if (error case final error?) throw error;
    shared.add((png: png, fileName: fileName));
  }
}
