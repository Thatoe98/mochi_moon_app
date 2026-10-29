import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/app/app_restart.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/auth/application/account_deletion_providers.dart';

/// The Me-tab row that deletes the account and starts the app over.
class DeleteAccountSection extends ConsumerWidget {
  const DeleteAccountSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final danger = Theme.of(context).colorScheme.error;
    final busy = ref.watch(accountDeletionProvider);
    return ListTile(
      minTileHeight: AppSpacing.minTouchTarget,
      leading: busy
          ? const SizedBox.square(
              dimension: AppSpacing.lg,
              child: CircularProgressIndicator(),
            )
          : Icon(Icons.delete_outline_rounded, color: danger),
      title: Text(
        busy ? l10n.accountDeleteDeleting : l10n.accountDeleteTitle,
        style: TextStyle(color: danger),
      ),
      subtitle: busy ? null : Text(l10n.accountDeleteSubtitle),
      enabled: !busy,
      onTap: () => _confirmAndDelete(context, ref),
    );
  }

  Future<void> _confirmAndDelete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context, rootNavigator: true);
    final first = await _ask(
      context,
      title: l10n.accountDeleteConfirmTitle,
      body: l10n.accountDeleteConfirmBody,
      keep: l10n.accountDeleteKeep,
      confirm: l10n.accountDeleteConfirmAction,
    );
    if (!first || !context.mounted) return;
    final sure = await _ask(
      context,
      title: l10n.accountDeleteFinalTitle,
      body: l10n.accountDeleteFinalBody,
      keep: l10n.accountDeleteKeep,
      confirm: l10n.accountDeleteFinalAction,
    );
    if (!sure || !context.mounted) return;

    // Hold the screen still while the account goes, then start over.
    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => PopScope(
          canPop: false,
          child: AlertDialog(
            content: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: Text(l10n.accountDeleteDeleting)),
              ],
            ),
          ),
        ),
      ),
    );
    final outcome = await ref.read(accountDeletionProvider.notifier).delete();
    if (navigator.mounted) navigator.pop();
    switch (outcome) {
      case AccountDeletionOutcome.deleted:
        ref.read(appRestartProvider)();
      case AccountDeletionOutcome.cancelled:
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.accountDeleteCancelled)),
        );
      case AccountDeletionOutcome.offline:
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.accountDeleteOffline)),
        );
      case AccountDeletionOutcome.failed:
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.accountDeleteFailed)),
        );
    }
  }

  /// A destructive yes/no dialog; true only when the user confirms.
  Future<bool> _ask(
    BuildContext context, {
    required String title,
    required String body,
    required String keep,
    required String confirm,
  }) async {
    final scheme = Theme.of(context).colorScheme;
    final answer = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(keep),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: scheme.error,
              foregroundColor: scheme.onError,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirm),
          ),
        ],
      ),
    );
    return answer ?? false;
  }
}
