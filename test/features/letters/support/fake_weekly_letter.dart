import 'package:mochi_moon/features/letters/domain/weekly_letter.dart';
import 'package:mochi_moon/features/letters/domain/weekly_letter_notifier.dart';
import 'package:mochi_moon/features/letters/domain/weekly_letter_repository.dart';

/// A quest log that lives in memory.
class FakeQuestDoneLog implements QuestDoneLog {
  FakeQuestDoneLog([Iterable<String> days = const []]) : _days = [...days];

  final List<String> _days;

  @override
  Future<List<String>> days() async => List.of(_days);

  @override
  Future<void> add(String dateKey) async {
    if (!_days.contains(dateKey)) _days.add(dateKey);
  }
}

/// A weekly letter repository that answers from memory.
class FakeWeeklyLetterRepository implements WeeklyLetterRepository {
  FakeWeeklyLetterRepository({this.saved, this.error});

  WeeklyLetter? saved;
  Exception? error;

  /// Every week the server would have been asked about.
  final asked = <WeekAggregates>[];

  @override
  Future<WeeklyLetter?> cached({
    required String lang,
    required String weekStart,
  }) async => saved;

  @override
  Future<WeeklyLetter> letter({
    required WeekAggregates week,
    required String lang,
  }) async {
    asked.add(week);
    final failure = error;
    if (failure != null) throw failure;
    return WeeklyLetter(
      weekStart: weekDateKey(week.weekStart),
      lang: lang,
      version: 1,
      title: 'Server title',
      body: 'Server first line. Server second line.',
    );
  }
}

/// A notification scheduler that remembers what it was asked.
class FakeWeeklyLetterNotifier implements WeeklyLetterNotifier {
  List<DateTime>? at;
  WeeklyLetterTexts? texts;

  @override
  Future<void> schedule(List<DateTime> at, WeeklyLetterTexts texts) async {
    this.at = at;
    this.texts = texts;
  }
}
