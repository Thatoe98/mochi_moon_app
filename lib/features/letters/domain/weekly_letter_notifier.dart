/// What the Sunday "your letter is ready" notification says. It never carries
/// the letter, which is why the scheduler is not given one.
class WeeklyLetterTexts {
  const WeeklyLetterTexts({
    required this.title,
    required this.body,
    required this.channelName,
    required this.channelDescription,
  });

  final String title;
  final String body;
  final String channelName;
  final String channelDescription;
}

/// The hour of the day (local) the Sunday notification fires.
const weeklyLetterHour = 18;

/// How many Sundays are planned ahead; the plan is renewed on every app run.
const weeklyLetterSundaysAhead = 4;

/// The next [weeklyLetterSundaysAhead] Sundays at [weeklyLetterHour] after
/// [now], local time.
List<DateTime> upcomingLetterSundays(DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  var sunday = DateTime(
    today.year,
    today.month,
    today.day + (DateTime.sunday - today.weekday),
    weeklyLetterHour,
  );
  if (!sunday.isAfter(now)) {
    sunday = DateTime(
      sunday.year,
      sunday.month,
      sunday.day + 7,
      weeklyLetterHour,
    );
  }
  return [
    for (var i = 0; i < weeklyLetterSundaysAhead; i++)
      DateTime(sunday.year, sunday.month, sunday.day + 7 * i, weeklyLetterHour),
  ];
}

/// Schedules the Sunday notification.
abstract interface class WeeklyLetterNotifier {
  /// Replaces every weekly-letter notification with one per moment in [at].
  /// An empty list just cancels them.
  Future<void> schedule(List<DateTime> at, WeeklyLetterTexts texts);
}
