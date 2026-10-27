import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({
    required this.title,
    this.body,
    this.icon,
    this.action,
  });

  final String title;
  final String? body;
  final IconData? icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
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
  const EmptyState({required this.title, this.body, super.key});

  final String title;
  final String? body;

  @override
  Widget build(BuildContext context) =>
      _CenteredMessage(icon: Icons.nightlight_round, title: title, body: body);
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
