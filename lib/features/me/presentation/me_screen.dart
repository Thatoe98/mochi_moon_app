import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/utils/url_opener.dart';
import 'package:mochi_moon/core/widgets/section_header.dart';
import 'package:mochi_moon/features/auth/presentation/delete_account_section.dart';
import 'package:mochi_moon/features/cosmic/today/presentation/thai_colors_section.dart';
import 'package:mochi_moon/features/me/presentation/widget_theme_section.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:mochi_moon/features/paywall/domain/play_links.dart';
import 'package:mochi_moon/features/settings/presentation/analytics_section.dart';
import 'package:mochi_moon/features/settings/presentation/announcements_section.dart';
import 'package:mochi_moon/features/settings/presentation/reduce_motion_section.dart';
import 'package:mochi_moon/features/settings/presentation/reminder_section.dart';

/// Profile, Premium and settings. The features live on the Explore tab.
class MeScreen extends ConsumerWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final premium = ref.watch(hasPremiumProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.mePlaceholderTitle)),
      body: ListView(
        children: [
          _Group(
            children: [
              ListTile(
                minTileHeight: AppSpacing.minTouchTarget,
                leading: const Icon(Icons.workspace_premium_rounded),
                title: Text(l10n.mePremiumTitle),
                subtitle: Text(
                  premium
                      ? l10n.mePremiumSubtitleActive
                      : l10n.mePremiumSubtitleFree,
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () async {
                  if (!premium) {
                    unawaited(context.push('${AppRoutes.paywall}?source=me'));
                    return;
                  }
                  final messenger = ScaffoldMessenger.of(context);
                  final opened = await ref.read(urlOpenerProvider)(
                    manageSubscriptionUrl,
                  );
                  if (!opened) {
                    messenger.showSnackBar(
                      SnackBar(content: Text(l10n.paywallManageFailed)),
                    );
                  }
                },
              ),
            ],
          ),
          SectionHeader(l10n.meSectionYou),
          _Group(
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
                leading: const Icon(Icons.lightbulb_rounded),
                title: Text(l10n.tourTitle),
                subtitle: Text(l10n.tourMeSubtitle),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push(AppRoutes.tour),
              ),
              ListTile(
                minTileHeight: AppSpacing.minTouchTarget,
                leading: const Icon(Icons.info_rounded),
                title: Text(l10n.aboutTitle),
                subtitle: Text(l10n.meAboutSubtitle),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push(AppRoutes.about),
              ),
            ],
          ),
          SectionHeader(l10n.meSectionLook),
          const _Group(
            children: [
              ReminderSection(),
              ThaiColorsSection(),
              WidgetThemeSection(),
              ReduceMotionSection(),
            ],
          ),
          SectionHeader(l10n.meSectionPrivacy),
          const _Group(children: [AnnouncementsSection(), AnalyticsSection()]),
          const DeleteAccountSection(),
        ],
      ),
    );
  }
}

/// A rounded card holding a few related rows.
class _Group extends StatelessWidget {
  const _Group({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    clipBehavior: Clip.antiAlias,
    child: Column(children: children),
  );
}
