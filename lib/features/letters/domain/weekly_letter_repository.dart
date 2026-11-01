import 'package:mochi_moon/features/letters/domain/weekly_letter.dart';

/// Where the weekly letter comes from: the device first, then the server.
abstract interface class WeeklyLetterRepository {
  /// The letter saved on the device for that week and language, or null.
  Future<WeeklyLetter?> cached({
    required String lang,
    required String weekStart,
  });

  /// The letter for [week]: the saved one when there is one, otherwise it is
  /// written by the server from [week]'s counts and then saved. Throws an
  /// `AppFailure` or a `ReadingsApiException` when it cannot be got.
  Future<WeeklyLetter> letter({
    required WeekAggregates week,
    required String lang,
  });
}

/// Which days she finished a quest, kept on the device. The quest record
/// holds only the latest day, so the weekly letter's count needs its own log.
abstract interface class QuestDoneLog {
  /// Local dates (`YYYY-MM-DD`) she finished a quest, recent ones only.
  Future<List<String>> days();

  Future<void> add(String dateKey);
}
