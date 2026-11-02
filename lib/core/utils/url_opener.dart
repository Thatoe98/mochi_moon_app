import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens a web link outside the app. Returns false when nothing could open it.
/// A provider so tests can replace it.
typedef UrlOpener = Future<bool> Function(Uri url);

Future<bool> _openExternally(Uri url) async {
  try {
    return await launchUrl(url, mode: LaunchMode.externalApplication);
  } on Object {
    return false;
  }
}

final urlOpenerProvider = Provider<UrlOpener>((ref) => _openExternally);
