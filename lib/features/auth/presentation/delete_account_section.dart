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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.accountDeleteConfirmTitle),
        content: Text(l10n.accountDeleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.accountDeleteKeep),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.accountDeleteConfirmAction),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final outcome = await ref.read(accountDeletionProvider.notifier).delete();
    switch (outcome) {
      case AccountDeletionOutcome.deleted:
        ref.read(appRestartProvider)();
      case AccountDeletionOutcome.cancelled:
        break;
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
}
