import 'package:mochi_moon/core/content/quote.dart';

/// Where today's ritual stands (PRD §6.15). The four steps are the mood, the
/// three cards, the gratitude line and the celebration.
enum RitualPhase {
  notStarted,
  mood,
  cards,
  gratitude,
  finished;

  /// The number shown as "step n of 4", or null before the ritual starts.
  int? get stepNumber => this == notStarted ? null : index;

  /// The phase saved under [name], or null for an unknown name.
  static RitualPhase? fromName(String name) =>
      values.where((phase) => phase.name == name).firstOrNull;
}

/// Steps in the ritual, for "step n of [ritualStepCount]".
const int ritualStepCount = 4;

/// Cards in a full ritual.
const int ritualCardCount = 3;

/// A ritual saved on this device so it resumes after the app is closed.
class SavedRitual {
  const SavedRitual({
    required this.day,
    required this.phase,
    required this.quoteIds,
  });

  /// The local day (at midnight) the ritual belongs to.
  final DateTime day;
  final RitualPhase phase;

  /// The cards dealt for the ritual, in order. Fewer than three when the
  /// free limit left less.
  final List<String> quoteIds;
}

/// The ritual as the Today tab shows it.
class RitualState {
  const RitualState({
    required this.phase,
    this.cards = const [],
    this.position = 0,
  });

  final RitualPhase phase;

  /// The cards dealt for today's ritual.
  final List<Quote> cards;

  /// How many of [cards] are done.
  final int position;

  bool get isFinished => phase == RitualPhase.finished;
}

/// Local store of the ritual in progress.
abstract interface class RitualProgressRepository {
  /// The saved ritual for [day], or null when none was started.
  Future<SavedRitual?> load(DateTime day);

  /// Saves [ritual], replacing any earlier one for the same day.
  Future<void> save(SavedRitual ritual);
}
