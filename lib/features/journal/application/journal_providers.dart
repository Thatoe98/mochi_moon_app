import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/journal/data/drift_journal_repository.dart';
import 'package:mochi_moon/features/journal/domain/journal_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'journal_providers.g.dart';

@Riverpod(keepAlive: true)
JournalRepository journalRepository(Ref ref) =>
    DriftJournalRepository(ref.watch(appDatabaseProvider));

/// A saved card together with its quote.
class JournalItem {
  const JournalItem({required this.quote, required this.savedAt});

  final Quote quote;
  final DateTime savedAt;
}

/// Saved cards, newest first. Rebuilds on each visit so it never shows a
/// stale list after the deck saved something.
@riverpod
class Journal extends _$Journal {
  @override
  Future<List<JournalItem>> build() async {
    final entries = await ref.watch(journalRepositoryProvider).entries();
    final quotes = await ref.watch(quotesProvider.future);
    final byId = {for (final q in quotes) q.id: q};
    // A saved id missing from the bundled quotes (e.g. a retired card) is
    // skipped rather than shown blank.
    return [
      for (final entry in entries)
        if (byId[entry.quoteId] case final quote?)
          JournalItem(quote: quote, savedAt: entry.savedAt),
    ];
  }

  Future<void> remove(String quoteId) async {
    await ref.read(journalRepositoryProvider).remove(quoteId);
    final current = state.value;
    if (current == null) return;
    state = AsyncData([
      for (final item in current)
        if (item.quote.id != quoteId) item,
    ]);
  }
}
