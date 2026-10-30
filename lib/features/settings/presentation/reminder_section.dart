import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/utils/english_dates.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';
import 'package:mochi_moon/features/settings/domain/reminder.dart';

/// The daily-reminder switch and, while it is on, the time row.
class ReminderSection extends ConsumerWidget {
  const ReminderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final loaded = ref.watch(reminderControllerProvider);
    final settings = loaded.value ?? const ReminderSettings();
    final time = TimeOfDay(
      hour: settings.time.hour,
      minute: settings.time.minute,
    );

    return Column(
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.notifications_rounded),
          title: Text(l10n.reminderTitle),
          subtitle: Text(l10n.reminderSubtitle),
          value: settings.enabled,
          onChanged: loaded.hasValue
              ? (on) => _toggle(context, ref, on: on)
              : null,
        ),
        if (settings.enabled)
          ListTile(
            minTileHeight: AppSpacing.minTouchTarget,
            leading: const Icon(Icons.schedule_rounded),
            title: Text(l10n.reminderTimeLabel),
            trailing: Text(
              englishDates.formatTimeOfDay(time),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () => _pickTime(context, ref, time),
          ),
      ],
    );
  }

  Future<void> _toggle(
    BuildContext context,
    WidgetRef ref, {
    required bool on,
  }) async {
    final controller = ref.read(reminderControllerProvider.notifier);
    if (!on) return await controller.disable();

    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final agreed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.reminderPrePromptTitle),
        content: Text(l10n.reminderPrePromptBody),
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
    if (!await controller.enable()) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.reminderPermissionDenied)),
      );
    }
  }

  Future<void> _pickTime(
    BuildContext context,
    WidgetRef ref,
    TimeOfDay initial,
  ) async {
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;
    await ref
        .read(reminderControllerProvider.notifier)
        .setTime(ReminderTime(picked.hour, picked.minute));
  }
}
