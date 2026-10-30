import 'package:flutter/material.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/cosmic/presentation/cosmic_link_banner.dart';

/// The banner on the Cosmic tab that leads to the birth chart (PRD §6.11).
class BirthChartButton extends StatelessWidget {
  const BirthChartButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CosmicLinkBanner(
      icon: Icons.brightness_2_outlined,
      title: l10n.chartTitle,
      hint: l10n.chartButtonHint,
      route: AppRoutes.chart,
    );
  }
}
