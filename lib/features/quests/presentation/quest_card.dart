import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:mochi_moon/features/quests/application/quest_providers.dart';

/// Today's tiny kindness quest (PRD §6.20): the task, a button to mark it done
/// and one swap a day, which is Premium: a free user sees the button with a
/// small lock and one tap opens the paywall. Shows nothing while the quests load or if there are
/// none.
class QuestCard extends ConsumerWidget {
  const QuestCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayQuestProvider);
    if (today == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                header: true,
                child: Text(
                  l10n.questCardTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(today.quest.textFor(lang), style: theme.textTheme.bodyLarge),
              const SizedBox(height: AppSpacing.sm),
              if (today.done)
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: Text(l10n.questDoneNote)),
                  ],
                )
              else
                Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    FilledButton(
                      onPressed: () => ref.read(completeQuestProvider)(),
                      child: Text(l10n.questMarkDone),
                    ),
                    if (today.canSwap)
                      if (ref.watch(hasPremiumProvider))
                        TextButton(
                          onPressed: () => ref.read(swapQuestProvider)(),
                          child: Text(l10n.questSwap),
                        )
                      else
                        TextButton.icon(
                          onPressed: () => unawaited(
                            context.push(
                              '${AppRoutes.paywall}?source=quest_swap',
                            ),
                          ),
                          icon: const Icon(Icons.lock_rounded, size: 16),
                          label: Text(l10n.questSwap),
                        ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
