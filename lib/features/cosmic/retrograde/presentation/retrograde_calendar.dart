import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/retrograde/domain/retrograde_status.dart';
import 'package:mochi_moon/features/cosmic/retrograde/presentation/retrograde_labels.dart';

/// One color per planet, from the theme, shared by the calendar and its key.
Color retrogradePlanetColor(ColorScheme scheme, Body body) => switch (body) {
  Body.mercury => scheme.primary,
  Body.venus => scheme.tertiary,
  Body.mars => scheme.error,
  Body.jupiter => scheme.secondary,
  Body.saturn => scheme.outline,
  _ => throw ArgumentError.value(body, 'body', 'has no retrograde'),
};

/// A month grid that colors the days a planet is retrograde (PRD §6.8). It
/// opens on the current month and pages through this year and the next, the
/// span the overview covers.
class RetrogradeCalendar extends StatefulWidget {
  const RetrogradeCalendar({required this.overview, super.key});

  final RetrogradeOverview overview;

  @override
  State<RetrogradeCalendar> createState() => _RetrogradeCalendarState();
}

class _RetrogradeCalendarState extends State<RetrogradeCalendar> {
  static const double _dayHeight = 44;

  late DateTime _month = DateTime(
    widget.overview.now.year,
    widget.overview.now.month,
  );

  DateTime get _first => DateTime(widget.overview.now.year);
  DateTime get _last => DateTime(widget.overview.now.year + 1, 12);

  void _move(int months) =>
      setState(() => _month = DateTime(_month.year, _month.month + months));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final dates = MaterialLocalizations.of(context);
    final canGoBack = _month.isAfter(_first);
    final canGoForward = _month.isBefore(_last);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.retroCalendarTitle,
            style: theme.textTheme.titleMedium,
          ),
        ),
        Text(l10n.retroCalendarSubtitle, style: theme.textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            IconButton(
              tooltip: l10n.retroCalendarPrevious,
              onPressed: canGoBack ? () => _move(-1) : null,
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            Expanded(
              child: Semantics(
                liveRegion: true,
                child: Text(
                  dates.formatMonthYear(_month),
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            IconButton(
              tooltip: l10n.retroCalendarNext,
              onPressed: canGoForward ? () => _move(1) : null,
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
        _WeekdayRow(dates: dates),
        for (final week in _weeks(dates))
          Row(
            children: [
              for (final day in week)
                Expanded(
                  child: day == null
                      ? const SizedBox(height: _dayHeight)
                      : _DayCell(
                          day: day,
                          planets: widget.overview.retrogradeOn(day),
                          isToday: _sameDay(day, widget.overview.now),
                          height: _dayHeight,
                        ),
                ),
            ],
          ),
        const SizedBox(height: AppSpacing.sm),
        const _PlanetKey(),
      ],
    );
  }

  /// The month as rows of seven, with null for the blanks around it.
  List<List<DateTime?>> _weeks(MaterialLocalizations dates) {
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final lead = (_month.weekday % 7 - dates.firstDayOfWeekIndex + 7) % 7;
    final cells = <DateTime?>[
      for (var i = 0; i < lead; i++) null,
      for (var d = 1; d <= daysInMonth; d++)
        DateTime(_month.year, _month.month, d),
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }
    return [for (var i = 0; i < cells.length; i += 7) cells.sublist(i, i + 7)];
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _WeekdayRow extends StatelessWidget {
  const _WeekdayRow({required this.dates});

  final MaterialLocalizations dates;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium;
    final first = dates.firstDayOfWeekIndex;
    return ExcludeSemantics(
      child: Row(
        children: [
          for (var i = 0; i < 7; i++)
            Expanded(
              child: Text(
                dates.narrowWeekdays[(first + i) % 7],
                style: style,
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.planets,
    required this.isToday,
    required this.height,
  });

  final DateTime day;
  final List<Body> planets;
  final bool isToday;
  final double height;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dates = MaterialLocalizations.of(context);
    final colors = [
      for (final body in planets) retrogradePlanetColor(scheme, body),
    ];
    final date = dates.formatFullDate(day);
    final label = planets.isEmpty
        ? date
        : l10n.retroCalendarDay(
            date,
            planets.map((body) => retrogradePlanetLabel(l10n, body)).join(', '),
          );

    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs / 2),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.isEmpty ? null : colors.first.withValues(alpha: 0.4),
            borderRadius: AppRadii.chipRadius,
            border: isToday
                ? Border.all(color: scheme.onSurface, width: 2)
                : null,
          ),
          child: SizedBox(
            height: height - AppSpacing.xs,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${day.day}', style: theme.textTheme.bodyMedium),
                if (colors.length > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final color in colors)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                            child: const SizedBox.square(dimension: 5),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Which color is which planet.
class _PlanetKey extends StatelessWidget {
  const _PlanetKey();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xs,
      children: [
        for (final body in retrogradeBodies)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: retrogradePlanetColor(theme.colorScheme, body),
                    borderRadius: AppRadii.chipRadius,
                  ),
                  child: const SizedBox.square(dimension: AppSpacing.md),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                retrogradePlanetLabel(l10n, body),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
      ],
    );
  }
}
