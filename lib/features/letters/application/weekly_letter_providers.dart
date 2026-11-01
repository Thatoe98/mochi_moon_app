import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/network/network_providers.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/journeys/application/journey_providers.dart';
import 'package:mochi_moon/features/journeys/domain/journey_progress.dart';
import 'package:mochi_moon/features/letters/data/api_weekly_letter_repository.dart';
import 'package:mochi_moon/features/letters/data/drift_weekly_letter_cache.dart';
import 'package:mochi_moon/features/letters/data/local_notifications_weekly_letter_notifier.dart';
import 'package:mochi_moon/features/letters/data/prefs_quest_done_log.dart';
import 'package:mochi_moon/features/letters/domain/weekly_letter.dart';
import 'package:mochi_moon/features/letters/domain/weekly_letter_notifier.dart';
import 'package:mochi_moon/features/letters/domain/weekly_letter_repository.dart';
import 'package:mochi_moon/features/mood/application/mood_providers.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';
import 'package:mochi_moon/features/settings/application/language_providers.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'weekly_letter_providers.g.dart';

/// The Readings API with the device cache in front; without a server only a
/// saved letter can be shown.
@Riverpod(keepAlive: true)
WeeklyLetterRepository weeklyLetterRepository(Ref ref) {
  final cache = DriftWeeklyLetterCache(ref.watch(appDatabaseProvider));
  final api = ref.watch(readingsApiProvider);
  if (api == null) return UnavailableWeeklyLetterRepository(cache);
  return ApiWeeklyLetterRepository(api: api, cache: cache);
}

@Riverpod(keepAlive: true)
QuestDoneLog questDoneLog(Ref ref) =>
    PrefsQuestDoneLog(SharedPreferencesAsync());

@Riverpod(keepAlive: true)
WeeklyLetterNotifier weeklyLetterScheduler(Ref ref) =>
    LocalNotificationsWeeklyLetterNotifier();

/// The days she finished a quest, from the device log.
@riverpod
Future<List<String>> questDoneDays(Ref ref) =>
    ref.watch(questDoneLogProvider).days();

/// The Monday of the week the letter is about right now.
@riverpod
DateTime weeklyLetterWeek(Ref ref) =>
    letterWeekStart(ref.watch(clockProvider)());

/// This week's counts, or null while her data loads. Counts and ids only.
@riverpod
WeekAggregates? weekAggregates(Ref ref) {
  final moods = ref.watch(dayMoodsProvider).value;
  final ritual = ref.watch(ritualDaySetProvider).value;
  final quests = ref.watch(questDoneDaysProvider).value;
  if (moods == null || ritual == null || quests == null) return null;
  final journey = activeJourney(
    ref.watch(journeyProgressListProvider).value ?? const [],
  );
  final profile = ref.watch(profileControllerProvider).value;
  return buildWeekAggregates(
    weekStart: ref.watch(weeklyLetterWeekProvider),
    moods: moods,
    ritualDays: ritual,
    questDoneDays: quests,
    journeyId: journey?.journeyId,
    journeyDay: journey?.currentDay,
    focusAreas: [
      for (final area in profile?.focusAreas ?? const <FocusArea>[]) area.id,
    ],
  );
}

/// The bundled letter used when the server cannot be reached.
WeeklyLetter fallbackWeeklyLetter(AppLocalizations l10n, DateTime week) =>
    WeeklyLetter(
      weekStart: weekDateKey(week),
      lang: 'en',
      version: 0,
      title: l10n.weeklyLetterFallbackTitle,
      body: l10n.weeklyLetterFallbackBody,
    );

/// The letter to show: a saved one, otherwise the server's, otherwise the
/// bundled fallback. Null for a free user (she sees the teaser), while her
/// week loads, or when the week had nothing in it (no call is made then).
@riverpod
Future<WeeklyLetterView?> weeklyLetter(Ref ref) async {
  if (!ref.watch(hasPremiumProvider)) return null;
  final week = ref.watch(weeklyLetterWeekProvider);
  final aggregates = ref.watch(weekAggregatesProvider);
  if (aggregates == null) return null;
  final lang = ref.watch(effectiveLanguageProvider);
  final repository = ref.watch(weeklyLetterRepositoryProvider);
  final l10n = lookupAppLocalizations(Locale(lang));

  final saved = await repository.cached(
    lang: lang,
    weekStart: weekDateKey(week),
  );
  if (saved != null) return WeeklyLetterView(letter: saved);
  // Nothing happened that week, so there is nothing to write about.
  if (aggregates.isEmpty) return null;
  try {
    return WeeklyLetterView(
      letter: await repository.letter(week: aggregates, lang: lang),
    );
  } on Object catch (error) {
    debugPrint('Could not get the weekly letter: $error');
    return WeeklyLetterView(
      letter: fallbackWeeklyLetter(l10n, week),
      isFallback: true,
    );
  }
}

/// Plans the Sunday notification for the next few weeks while she is Premium
/// and has allowed notifications; cancels it otherwise. The text only says a
/// letter is ready. Re-planned when Premium or the language changes and once
/// per app run. Watched from the app root.
@Riverpod(keepAlive: true)
Future<void> weeklyLetterNotificationsSync(Ref ref) async {
  final premium = ref.watch(hasPremiumProvider);
  final lang = ref.watch(reminderLanguageProvider);
  final notifier = ref.watch(weeklyLetterSchedulerProvider);
  final scheduler = ref.watch(reminderSchedulerProvider);
  final now = ref.watch(clockProvider)();
  final l10n = lookupAppLocalizations(Locale(lang));
  try {
    final allowed = premium && await scheduler.hasPermission();
    await notifier.schedule(
      allowed ? upcomingLetterSundays(now) : const [],
      WeeklyLetterTexts(
        title: l10n.weeklyLetterNotificationTitle,
        body: l10n.weeklyLetterNotificationBody,
        channelName: l10n.weeklyLetterChannelName,
        channelDescription: l10n.weeklyLetterChannelDescription,
      ),
    );
  } on Object catch (error) {
    debugPrint('Could not schedule the weekly letter notification: $error');
  }
}
