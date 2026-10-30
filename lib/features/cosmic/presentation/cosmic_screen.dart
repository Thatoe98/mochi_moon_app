import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/utils/english_dates.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/cosmic/moon/presentation/moon_card.dart';
import 'package:mochi_moon/features/cosmic/presentation/sign_picker.dart';
import 'package:mochi_moon/features/cosmic/presentation/zodiac_art.dart';
import 'package:mochi_moon/features/cosmic/presentation/zodiac_labels.dart';
import 'package:mochi_moon/features/cosmic/retrograde/application/retrograde_providers.dart';
import 'package:mochi_moon/features/cosmic/retrograde/presentation/retrograde_button.dart';
import 'package:mochi_moon/features/cosmic/today/application/cosmic_today_providers.dart';
import 'package:mochi_moon/features/cosmic/today/domain/cosmic_today.dart';
import 'package:mochi_moon/features/cosmic/today/presentation/color_swatch_tile.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';

/// The Cosmic tab: today's guidance for the user's sun sign (PRD §6.7).
class CosmicScreen extends ConsumerWidget {
  const CosmicScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final today = ref.watch(cosmicTodayProvider(lang));
    // Start the slow retrograde scan now so the Retrogrades screen is ready by
    // the time the button is tapped.
    ref.watch(retrogradeOverviewProvider);
    final shown = today.value?.sign;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cosmicTitle),
        actions: [
          if (shown != null && ref.watch(hasPremiumProvider))
            SignPickerButton(shown: shown),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: Column(
        children: [
          const RetrogradeButton(),
          Expanded(
            child: today.when(
              // Choosing another sign reloads the page; keep the old one on
              // screen until the new one is ready instead of flashing a loader.
              skipLoadingOnReload: true,
              loading: () => const LoadingView(),
              error: (error, stack) => ErrorView(
                onRetry: () => ref.invalidate(cosmicTodayProvider(lang)),
              ),
              // The Moon needs no birth date, so it shows either way.
              data: (data) => data == null
                  ? ListView(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      children: [
                        const MoonCard(),
                        EmptyState(
                          title: l10n.cosmicNeedsBirthDateTitle,
                          body: l10n.cosmicNeedsBirthDateBody,
                        ),
                      ],
                    )
                  : _TodayView(today: data, lang: lang),
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayView extends ConsumerWidget {
  const _TodayView({required this.today, required this.lang});

  final CosmicToday today;
  final String lang;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final reading = today.reading;
    final showThai = ref.watch(showThaiColorsProvider(lang)).value ?? false;
    final date = englishDates.formatMediumDate(today.date);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        ZodiacArt(sign: today.sign),
        const SizedBox(height: AppSpacing.md),
        Semantics(
          header: true,
          child: Text(
            l10n.cosmicHeader(zodiacSignLabel(l10n, today.sign), date),
            style: theme.textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const MoonCard(),
        _Block(
          children: [
            Text(reading.headline, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(reading.body, style: theme.textTheme.bodyLarge),
          ],
        ),
        _Block(
          title: l10n.cosmicEnergyTitle,
          children: [Text(reading.energy, style: theme.textTheme.bodyLarge)],
        ),
        _Block(
          title: l10n.cosmicLoveTitle,
          children: [Text(reading.love, style: theme.textTheme.bodyLarge)],
        ),
        _Block(
          title: l10n.cosmicLuckyColorsTitle,
          children: [
            ColorSwatchTile(
              name: today.luckyColors.sign.name,
              hex: today.luckyColors.sign.hex,
            ),
            ColorSwatchTile(
              name: today.luckyColors.moon.name,
              hex: today.luckyColors.moon.hex,
            ),
          ],
        ),
        _Block(
          title: l10n.cosmicLuckyNumberTitle,
          children: [
            Text('${today.luckyNumber}', style: theme.textTheme.headlineMedium),
          ],
        ),
        _Block(
          title: l10n.cosmicAvoidTitle,
          children: [
            for (final item in reading.avoid)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Text('• $item', style: theme.textTheme.bodyLarge),
              ),
          ],
        ),
        if (showThai)
          _Block(
            title: l10n.cosmicThaiColorsTitle,
            children: [
              if (today.thaiColors.birthday case final birthday?)
                ColorSwatchTile(
                  caption: l10n.cosmicThaiBirthdayColor,
                  name: birthday.name,
                  hex: birthday.hex,
                ),
              ColorSwatchTile(
                caption: l10n.cosmicThaiTodayColor,
                name: today.thaiColors.today.name,
                hex: today.thaiColors.today.hex,
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Text(
            l10n.cosmicDisclaimer,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

/// A card with an optional heading.
class _Block extends StatelessWidget {
  const _Block({required this.children, this.title});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Semantics(
                  header: true,
                  child: Text(title!, style: theme.textTheme.titleMedium),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
