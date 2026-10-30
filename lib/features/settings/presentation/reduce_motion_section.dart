import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/settings/application/reduce_motion_providers.dart';

/// The Me-tab switch that calms the app's animations (PRD §6.14).
class ReduceMotionSection extends ConsumerWidget {
  const ReduceMotionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final loaded = ref.watch(reduceMotionControllerProvider);
    return SwitchListTile(
      secondary: const Icon(Icons.motion_photos_off_rounded),
      title: Text(l10n.reduceMotionTitle),
      subtitle: Text(l10n.reduceMotionSubtitle),
      value: loaded.value ?? false,
      onChanged: loaded.hasValue
          ? (on) => ref
                .read(reduceMotionControllerProvider.notifier)
                .set(enabled: on)
          : null,
    );
  }
}
