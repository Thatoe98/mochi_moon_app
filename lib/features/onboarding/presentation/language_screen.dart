import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';
import 'package:mochi_moon/features/settings/application/language_providers.dart';
import 'package:mochi_moon/features/settings/domain/app_language.dart';
import 'package:mochi_moon/features/settings/presentation/language_names.dart';

/// The very first screen (PRD §6.1): the language comes before anything is
/// read. A choice is saved and applied at once.
class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final loaded = ref.watch(languageControllerProvider);
    final current = loaded.value ?? AppLanguage.system;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: AppRadii.cardRadius,
                  child: SizedBox.expand(
                    child: MochiIllustration(
                      asset: AppIllustrations.onboardingWelcome,
                      semanticLabel: l10n.languageFirstTitle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.languageFirstTitle,
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.languageFirstBody,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              RadioGroup<AppLanguage>(
                groupValue: current,
                onChanged: (language) {
                  if (language != null) {
                    unawaited(
                      ref
                          .read(languageControllerProvider.notifier)
                          .select(language),
                    );
                  }
                },
                child: Column(
                  children: [
                    for (final language in AppLanguage.values)
                      RadioListTile<AppLanguage>(
                        value: language,
                        title: Text(languageName(language, l10n)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: loaded.hasValue
                      ? () => context.go(AppRoutes.welcomeHello)
                      : null,
                  child: Text(l10n.languageFirstContinue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
