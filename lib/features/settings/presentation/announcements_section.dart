import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/settings/application/announcements_providers.dart';

/// The Me-tab switch for rare app news (PRD §6.6). On until switched off.
class AnnouncementsSection extends ConsumerWidget {
  const AnnouncementsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final loaded = ref.watch(announcementsControllerProvider);
    return SwitchListTile(
      secondary: const Icon(Icons.campaign_rounded),
      title: Text(l10n.announcementsTitle),
      subtitle: Text(l10n.announcementsSubtitle),
      value: loaded.value ?? true,
      onChanged: loaded.hasValue
          ? (on) => ref
                .read(announcementsControllerProvider.notifier)
                .set(enabled: on)
          : null,
    );
  }
}
