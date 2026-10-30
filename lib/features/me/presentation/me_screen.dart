import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/auth/presentation/delete_account_section.dart';
import 'package:mochi_moon/features/cosmic/today/presentation/thai_colors_section.dart';
import 'package:mochi_moon/features/settings/presentation/language_section.dart';
import 'package:mochi_moon/features/settings/presentation/reduce_motion_section.dart';
import 'package:mochi_moon/features/settings/presentation/reminder_section.dart';

/// Hub for the journal today; profile, premium and settings join it later
/// (PRD M2/M4).
class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.mePlaceholderTitle)),
      body: ListView(
        children: [
          ListTile(
            minTileHeight: AppSpacing.minTouchTarget,
            leading: const Icon(Icons.person_rounded),
            title: Text(l10n.meProfileTitle),
            subtitle: Text(l10n.meProfileSubtitle),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(AppRoutes.profileEdit),
          ),
          ListTile(
            minTileHeight: AppSpacing.minTouchTarget,
            leading: const Icon(Icons.favorite_rounded),
            title: Text(l10n.journalTitle),
            subtitle: Text(l10n.meJournalSubtitle),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(AppRoutes.journal),
          ),
          ListTile(
            minTileHeight: AppSpacing.minTouchTarget,
            leading: const Icon(Icons.people_alt_rounded),
            title: Text(l10n.partnersTitle),
            subtitle: Text(l10n.mePartnersSubtitle),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(AppRoutes.partners),
          ),
          const LanguageSection(),
          const ReminderSection(),
          const ThaiColorsSection(),
          const ReduceMotionSection(),
          ListTile(
            minTileHeight: AppSpacing.minTouchTarget,
            leading: const Icon(Icons.info_rounded),
            title: Text(l10n.aboutTitle),
            subtitle: Text(l10n.meAboutSubtitle),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(AppRoutes.about),
          ),
          const Divider(),
          const DeleteAccountSection(),
        ],
      ),
    );
  }
}
