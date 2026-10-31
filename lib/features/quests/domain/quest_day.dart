import 'package:flutter/foundation.dart';

/// What she did with the quest of one local day (PRD §6.20). Only the latest
/// day is kept: the file is `users/{uid}/state/quest`.
@immutable
class QuestDay {
  const QuestDay({
    required this.date,
    required this.questId,
    this.done = false,
    this.swapped = false,
  });

  /// Local day, `YYYY-MM-DD`.
  final String date;

  /// The quest she is shown that day (after a swap, the swapped-to quest).
  final String questId;
  final bool done;
  final bool swapped;

  QuestDay copyWith({String? questId, bool? done, bool? swapped}) => QuestDay(
    date: date,
    questId: questId ?? this.questId,
    done: done ?? this.done,
    swapped: swapped ?? this.swapped,
  );

  @override
  bool operator ==(Object other) =>
      other is QuestDay &&
      other.date == date &&
      other.questId == questId &&
      other.done == done &&
      other.swapped == swapped;

  @override
  int get hashCode => Object.hash(date, questId, done, swapped);
}

/// `YYYY-MM-DD` of the local day of [day].
String questDateKey(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-'
    '${day.month.toString().padLeft(2, '0')}-'
    '${day.day.toString().padLeft(2, '0')}';
