import 'package:mochi_moon/core/content/quest.dart';

/// Today's quest (PRD §6.20): chosen from the free quests that suit her focus
/// areas, by the local date alone, so it is the same all day whatever the
/// time, the language or the order of the file.
///
/// With no focus areas, or no quest that matches them, every free quest is a
/// candidate. [swapped] gives the one other quest she may trade to; for two
/// or more candidates it always differs from the default pick. Returns null
/// when there is no free quest.
Quest? dailyQuest(
  List<Quest> quests,
  DateTime date, {
  List<String> focusAreas = const [],
  bool swapped = false,
}) {
  final free = [
    for (final quest in quests)
      if (!quest.premium) quest,
  ]..sort((a, b) => a.id.compareTo(b.id));
  if (free.isEmpty) return null;

  final matching = [
    for (final quest in free)
      if (quest.focusAreas.any(focusAreas.contains)) quest,
  ];
  final pool = matching.isEmpty ? free : matching;

  final dayNumber = DateTime.utc(
    date.year,
    date.month,
    date.day,
  ).difference(DateTime.utc(1970)).inDays;
  final base = dayNumber % pool.length;
  if (!swapped || pool.length == 1) return pool[base];
  // Skip 1 to n-1 places on, so the swap is never the same quest.
  final skip = 1 + dayNumber % (pool.length - 1);
  return pool[(base + skip) % pool.length];
}
