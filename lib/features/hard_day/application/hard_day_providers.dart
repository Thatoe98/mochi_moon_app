import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/hard_day/domain/comfort_cards.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hard_day_providers.g.dart';

/// Today's comforting cards for the hard-day kit: bundled cards only, so the
/// kit works offline and signed out.
@riverpod
Future<List<Quote>> comfortCardsToday(Ref ref) async {
  final now = ref.read(clockProvider)();
  final quotes = await ref.watch(quotesProvider.future);
  return comfortCards(quotes, now);
}
