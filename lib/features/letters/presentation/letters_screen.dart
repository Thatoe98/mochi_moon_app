import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/letters/application/letter_providers.dart';
import 'package:mochi_moon/features/letters/presentation/weekly_letter_card.dart';

/// Me → Letters to future me (PRD §6.22): the sealed and the opened letters.
/// A sealed letter shows only when it opens, never its text.
class LettersScreen extends ConsumerWidget {
  const LettersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final letters = ref.watch(futureLettersProvider);
    final now = ref.watch(clockProvider)();
    final locale = Localizations.localeOf(context).toString();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.lettersTitle)),
      body: letters.when(
        loading: () => const LoadingView(),
        error: (_, _) =>
            ErrorView(onRetry: () => ref.invalidate(futureLettersProvider)),
        data: (all) => ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            const WeeklyLetterCard(),
            Text(
              l10n.lettersIntro,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: () => context.push('${AppRoutes.letters}/write'),
              icon: const Icon(Icons.edit_rounded),
              label: Text(l10n.lettersWrite),
            ),
            const SizedBox(height: AppSpacing.md),
            if (all.isEmpty)
              EmptyState(
                title: l10n.lettersEmptyTitle,
                body: l10n.lettersEmptyBody,
              ),
            for (final letter in all)
              Card(
                child: ListTile(
                  minTileHeight: AppSpacing.minTouchTarget,
                  leading: Icon(
                    letter.isOpen(now)
                        ? Icons.mark_email_read_rounded
                        : Icons.lock_clock_rounded,
                  ),
                  title: Text(
                    letter.isOpen(now)
                        ? l10n.letterReady
                        : l10n.letterSealedUntil(
                            DateFormat.yMMMd(locale).format(letter.unlockAt),
                          ),
                  ),
                  subtitle: Text(
                    l10n.letterWrittenOn(
                      DateFormat.yMMMd(locale).format(letter.writtenAt),
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push(
                    '${AppRoutes.letters}/${Uri.encodeComponent(letter.id)}',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
