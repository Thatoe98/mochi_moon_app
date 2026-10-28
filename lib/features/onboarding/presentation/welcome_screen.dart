import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/onboarding/domain/sample_cards.dart';
import 'package:mochi_moon/features/onboarding/presentation/onboarding_page.dart';

/// First screen for a new user (PRD §6.1): what the app is, then a few cards
/// to try before any account.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: OnboardingPage(
          title: l10n.onboardingWelcomeTitle,
          body: l10n.onboardingWelcomeBody,
          buttonLabel: l10n.onboardingTryCards(sampleCardCount),
          onPressed: () => context.go(AppRoutes.welcomeCards),
        ),
      ),
    );
  }
}
