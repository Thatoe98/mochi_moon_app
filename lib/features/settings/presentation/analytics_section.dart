import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/analytics/analytics_providers.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';

/// The Me-tab switch for anonymous usage counts (PRD §6.14). Off until the
/// user says yes.
class AnalyticsSection extends ConsumerWidget {
  const AnalyticsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final loaded = ref.watch(analyticsConsentControllerProvider);
    return SwitchListTile(
      secondary: const Icon(Icons.insights_rounded),
      title: Text(l10n.analyticsSettingTitle),
      subtitle: Text(l10n.analyticsSettingSubtitle),
      value: loaded.value ?? false,
      onChanged: loaded.hasValue
          ? (on) => ref
                .read(analyticsConsentControllerProvider.notifier)
                .set(granted: on)
          : null,
    );
  }
}
