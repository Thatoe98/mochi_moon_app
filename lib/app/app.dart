import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_theme.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';
import 'package:mochi_moon/features/widget_bridge/application/widget_providers.dart';

class MochiMoonApp extends ConsumerWidget {
  const MochiMoonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Each time the app opens, re-plan the next two weeks of reminders,
    // restock the home-screen widget and retry any unsent profile.
    ref
      ..watch(reminderSyncProvider)
      ..watch(widgetSyncProvider)
      ..watch(profileSyncProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
