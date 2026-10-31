import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/cosmic/unlock/application/cosmic_unlock.dart';
import 'package:mochi_moon/features/cosmic/unlock/domain/unlock_state.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/onboarding/presentation/birth_place_field.dart';
import 'package:mochi_moon/features/onboarding/presentation/profile_steps.dart';

/// "Unlock your cosmic side" (PRD §6.1): birth date, birth time, birthplace.
/// She can leave at any step; nothing is saved until the last one, so Cosmic
/// stays locked and every self-love feature keeps working.
class UnlockScreen extends ConsumerWidget {
  const UnlockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final unlock = ref.watch(cosmicUnlockProvider);
    final notifier = ref.read(cosmicUnlockProvider.notifier);
    final today = ref.watch(clockProvider)();
    final stepCount = UnlockStep.values.length;
    final progress = l10n.profileStepProgress(unlock.step.index + 1, stepCount);

    Future<void> finish() async {
      final messenger = ScaffoldMessenger.of(context);
      final router = GoRouter.of(context);
      try {
        await notifier.finish();
        router.go(AppRoutes.cosmic);
      } on Object {
        messenger.showSnackBar(SnackBar(content: Text(l10n.profileSaveFailed)));
      }
    }

    return PopScope(
      // Back steps through the flow; only the first step leaves it.
      canPop: unlock.isFirstStep,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) notifier.back();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.cosmicUnlockTitle)),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Semantics(
                  label: progress,
                  child: ExcludeSemantics(
                    child: LinearProgressIndicator(
                      value: (unlock.step.index + 1) / stepCount,
                      borderRadius: AppRadii.chipRadius,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: SingleChildScrollView(
                    child: _StepBody(
                      unlock: unlock,
                      notifier: notifier,
                      today: today,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: unlock.saving || !unlock.canContinue(today)
                        ? null
                        : (unlock.isLastStep
                              ? () => unawaited(finish())
                              : notifier.next),
                    child: unlock.saving
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            unlock.isLastStep
                                ? l10n.cosmicUnlockFinish
                                : l10n.onboardingContinue,
                          ),
                  ),
                ),
                if (!unlock.isFirstStep)
                  TextButton(
                    onPressed: unlock.saving ? null : notifier.back,
                    child: Text(l10n.profileBack),
                  ),
                Text(
                  l10n.cosmicUnlockPrivacy,
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepBody extends StatelessWidget {
  const _StepBody({
    required this.unlock,
    required this.notifier,
    required this.today,
  });

  final UnlockState unlock;
  final CosmicUnlock notifier;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final String title;
    final String body;
    final Widget child;
    switch (unlock.step) {
      case UnlockStep.birthDate:
        title = l10n.profileBirthDateTitle;
        body = l10n.profileBirthDateBody;
        child = BirthDatePicker(
          chosen: unlock.birthDate,
          today: today,
          onChanged: notifier.setBirthDate,
        );
      case UnlockStep.birthTime:
        title = l10n.profileBirthTimeTitle;
        body = l10n.profileBirthTimeBody;
        child = BirthTimePicker(
          minutes: unlock.birthMinutes,
          onChanged: notifier.setBirthMinutes,
        );
      case UnlockStep.birthPlace:
        title = l10n.profileBirthPlaceTitle;
        body = unlock.birthMinutes == null
            ? l10n.profileBirthPlaceBodyOptional
            : l10n.profileBirthPlaceBodyRequired;
        child = BirthPlaceField(
          chosen: unlock.birthPlace,
          onChosen: notifier.setBirthCity,
        );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: theme.textTheme.headlineMedium),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(body, style: theme.textTheme.bodyLarge),
        const SizedBox(height: AppSpacing.lg),
        child,
      ],
    );
  }
}
