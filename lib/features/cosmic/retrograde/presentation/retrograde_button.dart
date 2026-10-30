import 'package:flutter/material.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/cosmic/presentation/cosmic_link_banner.dart';

/// The banner at the top of the Cosmic tab that leads to the Retrogrades screen
/// (PRD §6.8).
class RetrogradeButton extends StatelessWidget {
  const RetrogradeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CosmicLinkBanner(
      icon: Icons.published_with_changes_rounded,
      title: l10n.retroTitle,
      hint: l10n.retroCardHint,
      route: AppRoutes.retrogrades,
    );
  }
}
