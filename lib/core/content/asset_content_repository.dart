import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mochi_moon/core/content/content_repository.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/content/sign_info.dart';

class AssetContentRepository implements ContentRepository {
  AssetContentRepository({AssetBundle? bundle})
    : _bundle = bundle ?? rootBundle;

  static const quotesPath = 'assets/content/quotes/quotes.json';
  static const signsPath = 'assets/content/signs/signs.json';

  final AssetBundle _bundle;

  Future<Map<String, dynamic>> _loadJson(String path) async {
    final raw = await _bundle.loadString(path);
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  @override
  Future<List<Quote>> loadQuotes() async {
    final json = await _loadJson(quotesPath);
    return (json['quotes'] as List<dynamic>)
        .map((e) => Quote.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  @override
  Future<List<SignInfo>> loadSigns() async {
    final json = await _loadJson(signsPath);
    return (json['signs'] as List<dynamic>)
        .map((e) => SignInfo.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }
}
