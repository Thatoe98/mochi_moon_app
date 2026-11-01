import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/mood/application/mood_providers.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';
import 'package:mochi_moon/features/mood/presentation/mood_calendar.dart';
import 'package:mochi_moon/features/mood/presentation/mood_chips.dart';
import 'package:mochi_moon/features/mood/presentation/mood_insights_card.dart';
import 'package:mochi_moon/features/mood/presentation/mood_labels.dart';

/// Me → Mood: set today's mood and look back over the month (PRD §6.18).
class MoodScreen extends ConsumerStatefulWidget {
  const MoodScreen({super.key});

  @override
  ConsumerState<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends ConsumerState<MoodScreen> {
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final today = ref.watch(clockProvider)();
    final moods = ref.watch(dayMoodsProvider);
    final todays = ref.watch(todayMoodProvider);
    final locale = Localizations.localeOf(context).toString();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moodScreenTitle)),
      body: moods.when(
        loading: () => const LoadingView(),
        error: (_, _) =>
            ErrorView(onRetry: () => ref.invalidate(dayMoodsProvider)),
        data: (entries) {
          final picked = _selected;
          final pickedMood = picked == null
              ? null
              : [
                  for (final entry in entries)
                    if (moodDateKey(entry.day) == moodDateKey(picked))
                      entry.mood,
                ].firstOrNull;
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Semantics(
                header: true,
                child: Text(
                  l10n.moodCheckInTitle,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              MoodChips(
                selected: todays,
                onSelected: (mood) => ref.read(setTodayMoodProvider)(mood),
              ),
              const SizedBox(height: AppSpacing.lg),
              MoodCalendar(
                moods: entries,
                today: today,
                selectedDay: picked,
                onDayTap: (day) => setState(() => _selected = day),
              ),
              if (picked != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  pickedMood == null
                      ? l10n.moodDayNone
                      : l10n.moodDayValue(
                          DateFormat.MMMMd(locale).format(picked),
                          pickedMood.label(l10n),
                        ),
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              const MoodInsightsCard(),
            ],
          );
        },
      ),
    );
  }
}
