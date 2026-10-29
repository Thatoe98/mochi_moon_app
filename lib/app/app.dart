import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_theme.dart';
import 'package:mochi_moon/features/cosmic/retrograde/application/retrograde_alert_providers.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/journal/application/journal_providers.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/settings/application/language_providers.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';
import 'package:mochi_moon/features/widget_bridge/application/widget_providers.dart';

class MochiMoonApp extends ConsumerWidget {
  const MochiMoonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Each time the app opens, re-plan the next two weeks of reminders and
    // the coming retrograde alerts, restock the home-screen widget, retry any
    // unsent profile and keep the journal and deck counters in Firestore up to
    // date.
    ref
      ..watch(reminderSyncProvider)
      ..watch(retrogradeAlertSyncProvider)
      ..watch(widgetSyncProvider)
      ..watch(profileSyncProvider)
      ..watch(journalSyncProvider)
      ..watch(deckSyncProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: ref.watch(appLocaleProvider),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
