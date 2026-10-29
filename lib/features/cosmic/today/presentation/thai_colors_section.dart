import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/cosmic/today/application/cosmic_today_providers.dart';

/// The switch that shows the Thai birthday and day colors on Cosmic you.
class ThaiColorsSection extends ConsumerWidget {
  const ThaiColorsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final loaded = ref.watch(showThaiColorsProvider(lang));
    return SwitchListTile(
      secondary: const Icon(Icons.palette_rounded),
      title: Text(l10n.thaiColorsSettingTitle),
      subtitle: Text(l10n.thaiColorsSettingSubtitle),
      value: loaded.value ?? false,
      onChanged: loaded.hasValue
          ? (on) => ref
                .read(showThaiColorsProvider(lang).notifier)
                .set(enabled: on)
          : null,
    );
  }
}
