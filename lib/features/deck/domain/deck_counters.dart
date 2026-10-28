import 'package:freezed_annotation/freezed_annotation.dart' show immutable;
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/deck/domain/deck_planner.dart';

/// The streak and today's count, as kept in Firestore under `users/{uid}.deck`
/// (PRD §8.1). They are worked out from the local history, which stays the
/// source of truth; Firestore only holds a copy.
@immutable
class DeckCounters {
  const DeckCounters({
    required this.streak,
    required this.lastCompletedDate,
    required this.todayCount,
    required this.todayDate,
  });

  /// Counters for [history] on the local day of [now].
  factory DeckCounters.from(List<DeckEvent> history, DateTime now) {
    DateTime? last;
    for (final event in history) {
      if (last == null || event.at.isAfter(last)) last = event.at;
    }
    return DeckCounters(
      streak: currentStreak(history, now),
      lastCompletedDate: last == null
          ? null
          : DateTime(last.year, last.month, last.day),
      todayCount: completedOnDay(history, now),
      todayDate: DateTime(now.year, now.month, now.day),
    );
  }

  final int streak;

  /// Local day of the latest completed card, or null before the first one.
  final DateTime? lastCompletedDate;

  final int todayCount;

  /// The local day [todayCount] belongs to.
  final DateTime todayDate;

  @override
  bool operator ==(Object other) =>
      other is DeckCounters &&
      other.streak == streak &&
      other.lastCompletedDate == lastCompletedDate &&
      other.todayCount == todayCount &&
      other.todayDate == todayDate;

  @override
  int get hashCode =>
      Object.hash(streak, lastCompletedDate, todayCount, todayDate);

  @override
  String toString() =>
      'DeckCounters(streak: $streak, last: $lastCompletedDate, '
      'today: $todayCount on $todayDate)';
}

/// Where the counters are copied to (`users/{uid}`, PRD §8.1). Throws an
/// `AppFailure`.
abstract interface class DeckCountersRemote {
  /// Writes [counters], creating `users/{uid}` on first use.
  Future<void> put(String uid, DeckCounters counters);
}
