import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_theme.dart';
import 'package:mochi_moon/features/cosmic/retrograde/application/retrograde_alert_providers.dart';
import 'package:mochi_moon/features/custom_cards/application/own_card_providers.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/gratitude/application/gratitude_providers.dart';
import 'package:mochi_moon/features/journal/application/journal_providers.dart';
import 'package:mochi_moon/features/journeys/application/journey_providers.dart';
import 'package:mochi_moon/features/letters/application/letter_providers.dart';
import 'package:mochi_moon/features/mascot/application/mascot_providers.dart';
import 'package:mochi_moon/features/mood/application/mood_providers.dart';
import 'package:mochi_moon/features/partners/application/partner_providers.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/quests/application/quest_providers.dart';
import 'package:mochi_moon/features/settings/application/announcements_providers.dart';
import 'package:mochi_moon/features/settings/application/language_providers.dart';
import 'package:mochi_moon/features/settings/application/reduce_motion_providers.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';
import 'package:mochi_moon/features/widget_bridge/application/widget_providers.dart';

class MochiMoonApp extends ConsumerWidget {
  const MochiMoonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Each time the app opens, re-plan the next two weeks of reminders and
    // the coming retrograde alerts, restock the home-screen widget, retry any
    // unsent profile, match the app-news topic to its switch and keep the journal, partners and deck counters in
    // Firestore up to date.
    ref
      ..watch(reminderSyncProvider)
      ..watch(retrogradeAlertSyncProvider)
      ..watch(announcementsSyncProvider)
      ..watch(widgetSyncProvider)
      ..watch(profileSyncProvider)
      ..watch(journalSyncProvider)
      ..watch(moodSyncProvider)
      ..watch(gratitudeSyncProvider)
      ..watch(ownCardSyncProvider)
      ..watch(questSyncProvider)
      ..watch(journeySyncProvider)
      ..watch(letterSyncProvider)
      ..watch(letterNotificationsSyncProvider)
      ..watch(mascotEarnerProvider)
      ..watch(mascotSyncProvider)
      ..watch(partnerSyncProvider)
      ..watch(deckSyncProvider);
    final reduceMotion =
        ref.watch(reduceMotionControllerProvider).value ?? false;
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: ref.watch(appLocaleProvider),
      routerConfig: ref.watch(routerProvider),
      // The in-app switch speaks to every screen the way the system's
      // "remove animations" setting does, which the widgets already respect.
      builder: (context, child) {
        if (!reduceMotion) return child!;
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: child!,
        );
      },
    );
  }
}
