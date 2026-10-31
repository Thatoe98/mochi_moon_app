import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/cosmic/today/application/cosmic_today_providers.dart';
import 'package:mochi_moon/features/cosmic/today/presentation/color_swatch_tile.dart';

/// The ritual's last reward (PRD §6.15): today's energy line and lucky color
/// when she has given her birth date, otherwise an invitation to unlock the
/// cosmic side. It never blocks finishing: while it loads, or if it fails, it
/// shows nothing.
class CosmicRewardCard extends ConsumerWidget {
  const CosmicRewardCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = Localizations.localeOf(context).languageCode;
    final today = ref.watch(cosmicTodayProvider(lang));
    return today.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (data) => data == null
          ? const _UnlockPrompt()
          : _EnergyCard(
              energy: data.reading.energy,
              colorName: data.luckyColors.sign.name,
              colorHex: data.luckyColors.sign.hex,
            ),
    );
  }
}

class _RewardShell extends StatelessWidget {
  const _RewardShell({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class _EnergyCard extends StatelessWidget {
  const _EnergyCard({
    required this.energy,
    required this.colorName,
    required this.colorHex,
  });

  final String energy;
  final String colorName;
  final String colorHex;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return _RewardShell(
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.cosmicEnergyTitle,
            style: theme.textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(energy, style: theme.textTheme.bodyLarge),
        const SizedBox(height: AppSpacing.sm),
        Text(l10n.cosmicLuckyColorsTitle, style: theme.textTheme.labelLarge),
        ColorSwatchTile(name: colorName, hex: colorHex),
        const SizedBox(height: AppSpacing.xs),
        Text(l10n.cosmicDisclaimer, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

class _UnlockPrompt extends StatelessWidget {
  const _UnlockPrompt();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return _RewardShell(
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.cosmicNeedsBirthDateTitle,
            style: theme.textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(l10n.cosmicNeedsBirthDateBody, style: theme.textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.md),
        FilledButton(
          onPressed: () => context.push(AppRoutes.cosmicUnlock),
          child: Text(l10n.cosmicUnlockButton),
        ),
      ],
    );
  }
}
