import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/letters/application/letter_providers.dart';
import 'package:mochi_moon/features/letters/domain/future_letter.dart';

/// One letter (PRD §6.22). Before its day only the date is shown: the text is
/// not put on the screen at all. A letter can be deleted at any time.
class LetterScreen extends ConsumerWidget {
  const LetterScreen({required this.letterId, super.key});

  final String letterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final letter = ref.watch(futureLetterProvider(letterId));
    return Scaffold(
      appBar: AppBar(),
      body: letter.when(
        loading: () => const LoadingView(),
        error: (_, _) => ErrorView(
          onRetry: () => ref.invalidate(futureLetterProvider(letterId)),
        ),
        data: (letter) => letter == null
            ? EmptyState(title: l10n.letterNotFound)
            : _Body(letter: letter),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.letter});

  final FutureLetter letter;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.letterDeleteTitle),
        content: Text(l10n.letterDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.letterDeleteKeep),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.letterDeleteConfirm),
          ),
        ],
      ),
    );
    if (!(ok ?? false)) return;
    await ref.read(deleteLetterProvider)(letter.id);
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final now = ref.watch(clockProvider)();
    final open = letter.isOpen(now);
    String date(DateTime value) => DateFormat.yMMMd(locale).format(value);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(
          l10n.letterWrittenOn(date(letter.writtenAt)),
          style: theme.textTheme.labelLarge,
        ),
        const SizedBox(height: AppSpacing.md),
        if (open)
          SelectableText(letter.body, style: theme.textTheme.bodyLarge)
        else
          Row(
            children: [
              const Icon(Icons.lock_clock_rounded),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.letterSealedNote(date(letter.unlockAt)),
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        const SizedBox(height: AppSpacing.lg),
        TextButton.icon(
          onPressed: () => _delete(context, ref),
          icon: const Icon(Icons.delete_outline_rounded),
          label: Text(l10n.letterDelete),
        ),
      ],
    );
  }
}
