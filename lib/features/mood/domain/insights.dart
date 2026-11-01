import 'package:mochi_moon/features/mood/domain/mood.dart';

/// Fewest logged days before any insight is shown (PRD §6.18).
const int minInsightDays = 14;

/// Fewest days a mood needs to lead before it counts as "most often".
const int _minLeadDays = 3;

/// Fewest days on each side (ritual and no ritual) before they are compared.
const int _minGroupDays = 4;

/// How much higher (as a share of days) the ritual days must be.
const double _minLift = 0.15;

/// The moods that feel good, for the ritual comparison.
const Set<Mood> _gentleMoods = {Mood.happy, Mood.calm, Mood.inLove};

enum MoodInsightKind {
  /// One mood showed up on more days than any other.
  mostOften,

  /// Good moods were logged on more of the days she finished the ritual.
  ritualLift,
}

/// One gentle statement. The wording lives in the ARB files; this holds only
/// the numbers it needs.
class MoodInsight {
  const MoodInsight({
    required this.kind,
    this.mood,
    this.count = 0,
    this.total = 0,
  });

  final MoodInsightKind kind;

  /// The leading mood for [MoodInsightKind.mostOften].
  final Mood? mood;

  /// Days with [mood] (mostOften).
  final int count;

  /// Logged days the statement is about.
  final int total;
}

/// What the insights say, or that there is not enough data yet.
class MoodInsights {
  const MoodInsights({required this.loggedDays, required this.insights});

  final int loggedDays;
  final List<MoodInsight> insights;

  bool get enoughData => loggedDays >= minInsightDays;

  /// Logged days still needed.
  int get daysToGo => enoughData ? 0 : minInsightDays - loggedDays;
}

/// Insights computed from her own moods and ritual days only. Nothing here is
/// a claim about health: it counts and compares days.
MoodInsights computeMoodInsights(
  List<DayMood> moods,
  Set<DateTime> ritualDays,
) {
  final ritual = {for (final day in ritualDays) moodDateKey(day)};
  final logged = moods.length;
  if (logged < minInsightDays) {
    return MoodInsights(loggedDays: logged, insights: const []);
  }
  final insights = <MoodInsight>[];

  final counts = <Mood, int>{};
  for (final entry in moods) {
    counts[entry.mood] = (counts[entry.mood] ?? 0) + 1;
  }
  final ranked = counts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  if (ranked.first.value >= _minLeadDays &&
      (ranked.length == 1 || ranked.first.value > ranked[1].value)) {
    insights.add(
      MoodInsight(
        kind: MoodInsightKind.mostOften,
        mood: ranked.first.key,
        count: ranked.first.value,
        total: logged,
      ),
    );
  }

  final withRitual = moods
      .where((e) => ritual.contains(moodDateKey(e.day)))
      .toList();
  final without = moods
      .where((e) => !ritual.contains(moodDateKey(e.day)))
      .toList();
  if (withRitual.length >= _minGroupDays && without.length >= _minGroupDays) {
    double share(List<DayMood> days) =>
        days.where((e) => _gentleMoods.contains(e.mood)).length / days.length;
    if (share(withRitual) - share(without) >= _minLift) {
      insights.add(
        MoodInsight(kind: MoodInsightKind.ritualLift, total: logged),
      );
    }
  }
  return MoodInsights(loggedDays: logged, insights: insights);
}
