import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/onboarding/application/profile_setup.dart';
import 'package:mochi_moon/features/onboarding/domain/profile_setup_state.dart';
import 'package:mochi_moon/features/onboarding/presentation/profile_steps.dart';

/// The profile steps after sign-in (PRD §6.1): name, focus areas, reminder. One screen, so back moves between steps and keeps
/// every answer; finishing ends the first-run flow and the router takes over.
class ProfileSetupScreen extends ConsumerWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final setup = ref.watch(profileSetupProvider);
    final notifier = ref.read(profileSetupProvider.notifier);
    final stepCount = ProfileStep.values.length;

    return PopScope(
      // Back steps through the flow; only the first step leaves it.
      canPop: setup.isFirstStep,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) notifier.back();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                _Header(
                  setup: setup,
                  stepCount: stepCount,
                  onBack: notifier.back,
                ),
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: SingleChildScrollView(
                    child: ProfileStepBody(setup: setup, notifier: notifier),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ..._buttons(context, ref, setup, l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// The reminder step has its own pair of choices; every other step has one
  /// button that moves on.
  List<Widget> _buttons(
    BuildContext context,
    WidgetRef ref,
    ProfileSetupState setup,
    AppLocalizations l10n,
  ) {
    final notifier = ref.read(profileSetupProvider.notifier);

    Future<void> finish() async {
      final messenger = ScaffoldMessenger.of(context);
      try {
        await notifier.finish();
      } on Object {
        messenger.showSnackBar(SnackBar(content: Text(l10n.profileSaveFailed)));
      }
    }

    // The reminder is the last step: both choices finish the flow.
    void finishWith({required bool remind}) {
      notifier.setReminderEnabled(enabled: remind);
      unawaited(finish());
    }

    if (setup.step == ProfileStep.reminder) {
      return [
        _WideButton(
          label: l10n.profileReminderOn,
          busy: setup.saving,
          onPressed: () => finishWith(remind: true),
        ),
        TextButton(
          onPressed: setup.saving ? null : () => finishWith(remind: false),
          child: Text(l10n.profileReminderSkip),
        ),
      ];
    }
    return [
      _WideButton(
        label: l10n.onboardingContinue,
        onPressed: setup.canContinue ? notifier.next : null,
      ),
    ];
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.setup,
    required this.stepCount,
    required this.onBack,
  });

  final ProfileSetupState setup;
  final int stepCount;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = l10n.profileStepProgress(setup.step.index + 1, stepCount);
    return Row(
      children: [
        // Keeps the progress bar from jumping when the back arrow appears.
        SizedBox.square(
          dimension: AppSpacing.minTouchTarget,
          child: setup.isFirstStep
              ? null
              : IconButton(
                  tooltip: l10n.profileBack,
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: onBack,
                ),
        ),
        Expanded(
          child: Semantics(
            label: progress,
            child: ExcludeSemantics(
              child: LinearProgressIndicator(
                value: (setup.step.index + 1) / stepCount,
                borderRadius: AppRadii.chipRadius,
              ),
            ),
          ),
        ),
        const SizedBox.square(dimension: AppSpacing.minTouchTarget),
      ],
    );
  }
}

class _WideButton extends StatelessWidget {
  const _WideButton({
    required this.label,
    required this.onPressed,
    this.busy = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool busy;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: FilledButton(
      onPressed: busy ? null : onPressed,
      child: busy
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(label),
    ),
  );
}
