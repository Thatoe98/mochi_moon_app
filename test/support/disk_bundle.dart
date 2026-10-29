import 'dart:io';

import 'package:flutter/services.dart';

/// Serves the real asset files from disk so the shipped JSON is validated.
///
/// Reads synchronously so widget tests, whose fake clock never completes real
/// file I/O, can load content too.
class DiskBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    final bytes = File(key).readAsBytesSync();
    return ByteData.sublistView(bytes);
  }
}
