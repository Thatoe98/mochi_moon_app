import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/theme/widget_theme_colors.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:mochi_moon/features/widget_bridge/application/widget_theme_providers.dart';
import 'package:mochi_moon/features/widget_bridge/domain/widget_theme.dart';

/// The Me-tab picker for the home-screen widget's look (PRD §6.5). Cream is
/// free; the others show a lock for free users and open the paywall
/// (`widget_theme`).
class WidgetThemeSection extends ConsumerWidget {
  const WidgetThemeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final premium = ref.watch(hasPremiumProvider);
    final selected = ref.watch(effectiveWidgetThemeProvider);
    return ListTile(
      leading: const Icon(Icons.widgets_rounded),
      title: Text(l10n.widgetThemeTitle),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xs),
        child: Wrap(
          spacing: AppSpacing.sm,
          children: [
            for (final theme in WidgetTheme.values)
              ChoiceChip(
                avatar: premium || !theme.premium
                    ? CircleAvatar(backgroundColor: _color(theme))
                    : const Icon(Icons.lock_outline_rounded),
                label: Text(_name(l10n, theme)),
                selected: selected == theme,
                showCheckmark: false,
                onSelected: (_) {
                  if (theme.premium && !premium) {
                    unawaited(
                      context.push('${AppRoutes.paywall}?source=widget_theme'),
                    );
                    return;
                  }
                  unawaited(
                    ref.read(widgetThemeControllerProvider.notifier).set(theme),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  static Color _color(WidgetTheme theme) => switch (theme) {
    WidgetTheme.cream => WidgetThemeColors.cream,
    WidgetTheme.lavender => WidgetThemeColors.lavender,
    WidgetTheme.peach => WidgetThemeColors.peach,
    WidgetTheme.midnight => WidgetThemeColors.midnight,
  };

  static String _name(AppLocalizations l10n, WidgetTheme theme) =>
      switch (theme) {
        WidgetTheme.cream => l10n.widgetThemeCream,
        WidgetTheme.lavender => l10n.widgetThemeLavender,
        WidgetTheme.peach => l10n.widgetThemePeach,
        WidgetTheme.midnight => l10n.widgetThemeMidnight,
      };
}
