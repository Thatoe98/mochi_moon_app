import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/retrograde/application/retrograde_alert_providers.dart';
import 'package:mochi_moon/features/cosmic/retrograde/domain/retrograde_alerts.dart';
import 'package:mochi_moon/features/cosmic/retrograde/presentation/retrograde_labels.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';

/// One switch per planet for the retrograde heads-ups (PRD §6.6).
class RetrogradeAlertsSection extends ConsumerWidget {
  const RetrogradeAlertsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final loaded = ref.watch(retrogradeAlertControllerProvider);
    final planets = loaded.value ?? defaultRetrogradeAlertPlanets;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xs,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  l10n.retroAlertsTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Text(l10n.retroAlertsSubtitle, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        for (final body in retrogradeAlertBodies)
          SwitchListTile(
            secondary: const Icon(Icons.nightlight_round),
            title: Text(retrogradePlanetLabel(l10n, body)),
            value: planets.contains(body),
            onChanged: loaded.hasValue
                ? (on) => _toggle(context, ref, body, on: on)
                : null,
          ),
      ],
    );
  }

  Future<void> _toggle(
    BuildContext context,
    WidgetRef ref,
    Body body, {
    required bool on,
  }) async {
    final controller = ref.read(retrogradeAlertControllerProvider.notifier);
    if (!on) {
      await controller.setEnabled(body, on: false);
      return;
    }

    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final scheduler = ref.read(reminderSchedulerProvider);
    // Explain before the system prompt, but only when it is about to appear.
    if (!await scheduler.hasPermission()) {
      if (!context.mounted) return;
      final agreed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.retroAlertsPrePromptTitle),
          content: Text(l10n.retroAlertsPrePromptBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.reminderPrePromptLater),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.reminderPrePromptAllow),
            ),
          ],
        ),
      );
      if (agreed != true) return;
    }
    if (!await controller.setEnabled(body, on: true)) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.reminderPermissionDenied)),
      );
    }
  }
}
