import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';

/// What a Cosmic screen shows while there is no birth date: a friendly note
/// and one button into the unlock flow (PRD §6.1).
class CosmicLockedView extends StatelessWidget {
  const CosmicLockedView({required this.title, required this.body, super.key});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyState(
      title: title,
      body: body,
      illustration: AppIllustrations.onboardingWelcome,
      illustrationLabel: l10n.cosmicLockedArtLabel,
      action: FilledButton(
        onPressed: () => context.push(AppRoutes.cosmicUnlock),
        child: Text(l10n.cosmicUnlockButton),
      ),
    );
  }
}
