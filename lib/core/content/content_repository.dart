import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/content/sign_info.dart';

/// Source of bundled content. Widgets never load assets directly.
abstract interface class ContentRepository {
  Future<List<Quote>> loadQuotes();

  Future<List<SignInfo>> loadSigns();
}
