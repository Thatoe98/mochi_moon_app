import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';
import 'package:mochi_moon/features/mood/presentation/mood_labels.dart';

/// A month grid with one coloured dot per day that has a mood (PRD §6.18).
/// Days without a mood are simply empty. Tapping a day tells [onDayTap]; the
/// calendar can go back as far as she likes but not past the current month.
class MoodCalendar extends StatefulWidget {
  const MoodCalendar({
    required this.moods,
    required this.today,
    required this.selectedDay,
    required this.onDayTap,
    super.key,
  });

  final List<DayMood> moods;
  final DateTime today;
  final DateTime? selectedDay;
  final ValueChanged<DateTime> onDayTap;

  @override
  State<MoodCalendar> createState() => _MoodCalendarState();
}

class _MoodCalendarState extends State<MoodCalendar> {
  late DateTime _month = DateTime(widget.today.year, widget.today.month);

  bool get _isCurrentMonth =>
      _month.year == widget.today.year && _month.month == widget.today.month;

  void _move(int months) =>
      setState(() => _month = DateTime(_month.year, _month.month + months));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final material = MaterialLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final byDay = {
      for (final entry in widget.moods) moodDateKey(entry.day): entry.mood,
    };

    final first = _month;
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    // Columns start on her locale's first weekday.
    final startColumn =
        (first.weekday % 7 - material.firstDayOfWeekIndex + 7) % 7;
    final weekdays = [
      for (var i = 0; i < 7; i++)
        material.narrowWeekdays[(material.firstDayOfWeekIndex + i) % 7],
    ];

    final cells = <Widget>[
      for (final weekday in weekdays)
        Center(
          child: ExcludeSemantics(
            child: Text(weekday, style: theme.textTheme.labelMedium),
          ),
        ),
      for (var i = 0; i < startColumn; i++) const SizedBox.shrink(),
      for (var day = 1; day <= daysInMonth; day++)
        _DayCell(
          date: DateTime(_month.year, _month.month, day),
          mood: byDay[moodDateKey(DateTime(_month.year, _month.month, day))],
          isToday:
              moodDateKey(DateTime(_month.year, _month.month, day)) ==
              moodDateKey(widget.today),
          isSelected:
              widget.selectedDay != null &&
              moodDateKey(widget.selectedDay!) ==
                  moodDateKey(DateTime(_month.year, _month.month, day)),
          locale: locale,
          onTap: widget.onDayTap,
        ),
    ];

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              tooltip: l10n.moodPreviousMonth,
              icon: const Icon(Icons.chevron_left_rounded),
              onPressed: () => _move(-1),
            ),
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  DateFormat.yMMMM(locale).format(_month),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ),
            IconButton(
              tooltip: l10n.moodNextMonth,
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: _isCurrentMonth ? null : () => _move(1),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: cells,
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.mood,
    required this.isToday,
    required this.isSelected,
    required this.locale,
    required this.onTap,
  });

  final DateTime date;
  final Mood? mood;
  final bool isToday;
  final bool isSelected;
  final String locale;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dateText = DateFormat.MMMMd(locale).format(date);
    final label = switch (mood) {
      final mood? => l10n.moodDaySemantics(dateText, mood.label(l10n)),
      null => l10n.moodDaySemanticsNone(dateText),
    };
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => onTap(date),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: isSelected || isToday
                ? Border.all(
                    color: isSelected ? scheme.primary : scheme.outlineVariant,
                    width: isSelected ? 2 : 1,
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${date.day}', style: theme.textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.xs),
              SizedBox.square(
                dimension: AppSpacing.sm,
                child: mood == null
                    ? null
                    : DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: mood!.color(scheme),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
