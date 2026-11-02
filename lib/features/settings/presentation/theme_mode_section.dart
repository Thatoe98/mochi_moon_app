import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/settings/application/theme_mode_providers.dart';
import 'package:mochi_moon/features/settings/domain/theme_mode_setting.dart';

/// The Me-tab control for light, dark or "follow my phone".
class ThemeModeSection extends ConsumerWidget {
  const ThemeModeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final loaded = ref.watch(themeModeControllerProvider);
    final current = loaded.value ?? AppThemeChoice.system;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.brightness_6_rounded),
              const SizedBox(width: AppSpacing.md),
              Text(
                l10n.themeModeTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<AppThemeChoice>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: AppThemeChoice.system,
                  icon: const Icon(Icons.phone_android_rounded),
                  label: Text(l10n.themeModeSystem),
                ),
                ButtonSegment(
                  value: AppThemeChoice.light,
                  icon: const Icon(Icons.light_mode_rounded),
                  label: Text(l10n.themeModeLight),
                ),
                ButtonSegment(
                  value: AppThemeChoice.dark,
                  icon: const Icon(Icons.dark_mode_rounded),
                  label: Text(l10n.themeModeDark),
                ),
              ],
              selected: {current},
              onSelectionChanged: loaded.hasValue
                  ? (picked) => ref
                        .read(themeModeControllerProvider.notifier)
                        .set(picked.first)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
