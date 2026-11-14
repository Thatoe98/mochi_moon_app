import 'package:mochi_moon/features/mood/domain/mood.dart';

/// When she was last asked to rate the app, and how often so far.
class ReviewHistory {
  const ReviewHistory({this.lastAsked, this.timesAsked = 0});

  final DateTime? lastAsked;
  final int timesAsked;
}

/// Fewest days of streak before the first ask: she has come back a few times.
const reviewMinStreak = 3;

/// Gap between two asks.
const reviewMinGap = Duration(days: 120);

/// We never ask more than this many times in total.
const reviewMaxAsks = 3;

/// Moods on which we never ask; a review prompt is for a good moment.
const Set<Mood> _lowMoods = {Mood.sad, Mood.anxious, Mood.tired};

/// Whether now is a kind moment to ask for a rating: right after a finished
/// ritual, on a streak, never on a low-mood day and not too often. Google Play
/// applies its own quota on top of this.
bool shouldAskForReview({
  required int streak,
  required Mood? todayMood,
  required ReviewHistory history,
  required DateTime now,
}) {
  if (streak < reviewMinStreak) return false;
  if (todayMood != null && _lowMoods.contains(todayMood)) return false;
  if (history.timesAsked >= reviewMaxAsks) return false;
  final last = history.lastAsked;
  if (last != null && now.difference(last) < reviewMinGap) return false;
  return true;
}
