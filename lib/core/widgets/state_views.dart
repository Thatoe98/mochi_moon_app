import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({
    required this.title,
    this.body,
    this.icon,
    this.action,
    this.illustration,
  });

  final String title;
  final String? body;
  final IconData? icon;
  final Widget? action;

  /// Replaces [icon] when set.
  final Widget? illustration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (illustration != null) ...[
              illustration!,
              const SizedBox(height: AppSpacing.md),
            ] else if (icon != null) ...[
              ExcludeSemantics(
                child: Icon(icon, size: 48, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            Text(
              title,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (body != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                body!,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: AppSpacing.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Semantics(
        label: l10n.stateLoading,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _CenteredMessage(
      icon: Icons.cloud_off_rounded,
      title: l10n.stateErrorTitle,
      body: l10n.stateErrorBody,
      action: FilledButton(onPressed: onRetry, child: Text(l10n.stateRetry)),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    this.body,
    this.illustration,
    this.illustrationLabel,
    this.action,
    super.key,
  }) : assert(
         illustration == null || illustrationLabel != null,
         'Art needs a semantic label',
       );

  final String title;
  final String? body;

  /// Asset path of mascot art shown above the text.
  final String? illustration;
  final String? illustrationLabel;

  /// A button under the text, such as "Try again".
  final Widget? action;

  @override
  Widget build(BuildContext context) => _CenteredMessage(
    icon: Icons.nightlight_round,
    title: title,
    body: body,
    action: action,
    illustration: illustration == null
        ? null
        : ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: ClipRRect(
                borderRadius: AppRadii.cardRadius,
                child: MochiIllustration(
                  asset: illustration!,
                  semanticLabel: illustrationLabel!,
                ),
              ),
            ),
          ),
  );
}

/// Banner shown above cached/fallback content when the device is offline.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      color: theme.colorScheme.primaryContainer,
      child: Text(
        AppLocalizations.of(context).stateOffline,
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}
