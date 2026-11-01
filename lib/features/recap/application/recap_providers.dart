import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/journal/application/journal_providers.dart';
import 'package:mochi_moon/features/mood/application/mood_providers.dart';
import 'package:mochi_moon/features/recap/domain/monthly_recap.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recap_providers.g.dart';

/// A recap and the bundled card it names, if any.
class RecapView {
  const RecapView({required this.recap, this.favourite});

  final MonthlyRecap recap;
  final Quote? favourite;
}

/// How many days into a month the recap card shows on Today.
const recapTodayDays = 3;

/// Last month's recap, built on the device from her ritual days, moods and
/// saved cards. Nothing is uploaded.
@riverpod
Future<RecapView> lastMonthRecap(Ref ref) async {
  final now = ref.watch(clockProvider)();
  final ritual = await ref.watch(ritualDaySetProvider.future);
  final moods = await ref.watch(dayMoodsProvider.future);
  final journal = await ref.watch(journalProvider.future);
  final recap = buildMonthlyRecap(
    month: lastMonthOf(now),
    ritualDays: ritual,
    moods: moods,
    saved: [
      for (final item in journal)
        (quoteId: item.quote.id, savedAt: item.savedAt),
    ],
  );
  Quote? favourite;
  for (final item in journal) {
    if (item.quote.id == recap.favouriteQuoteId) favourite = item.quote;
  }
  return RecapView(recap: recap, favourite: favourite);
}
