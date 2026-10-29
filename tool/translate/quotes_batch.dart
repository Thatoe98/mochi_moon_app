// Adds a Burmese text to each quote of assets/content/quotes/quotes.json.
// Quotes keep every language in their `text` map (PRD §8.3), so the result
// goes back into the same file.
import 'dart:convert';

import 'arb_batch.dart';

const _lang = 'my';

Map<String, Object?> _text(Object? quote) =>
    (quote! as Map<String, Object?>)['text']! as Map<String, Object?>;

/// The English quote texts keyed by quote id, shaped like an ARB map so the
/// ARB batch prompts and checks can be reused.
ArbMap quoteSource(List<Object?> quotes) => {
  for (final quote in quotes)
    (quote! as Map<String, Object?>)['id']! as String:
        _text(quote)['en']! as String,
};

/// Ids of the quotes that have no Burmese text yet (or all, with [force]),
/// matching [only] when given.
List<String> pendingQuotes(
  List<Object?> quotes, {
  RegExp? only,
  bool force = false,
}) => [
  for (final quote in quotes)
    if ((only == null ||
            only.hasMatch((quote! as Map<String, Object?>)['id']! as String)) &&
        (force || !_text(quote).containsKey(_lang)))
      (quote! as Map<String, Object?>)['id']! as String,
];

/// A copy of [quotes] with the Burmese texts in [done] added.
List<Object?> mergeQuotes(List<Object?> quotes, Map<String, String> done) => [
  for (final quote in quotes)
    {
      ...(quote! as Map<String, Object?>),
      'text': {
        ..._text(quote),
        if (done[(quote as Map<String, Object?>)['id']] != null)
          _lang: done[quote['id']],
      },
    },
];

/// The content of `quotes.json` with [quotes] in place of the old list.
String encodeQuotes(Map<String, Object?> json, List<Object?> quotes) =>
    '${const JsonEncoder.withIndent('  ').convert({...json, 'quotes': quotes})}\n';
