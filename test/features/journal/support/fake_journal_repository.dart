import 'package:mochi_moon/features/journal/domain/journal_repository.dart';

/// In-memory [JournalRepository] for tests.
class FakeJournalRepository implements JournalRepository {
  FakeJournalRepository([List<JournalEntry> seed = const []])
    : saved = [...seed];

  final List<JournalEntry> saved;

  @override
  Future<List<JournalEntry>> entries() async => [
    ...saved..sort((a, b) => b.savedAt.compareTo(a.savedAt)),
  ];

  @override
  Future<void> remove(String quoteId) async =>
      saved.removeWhere((e) => e.quoteId == quoteId);
}
