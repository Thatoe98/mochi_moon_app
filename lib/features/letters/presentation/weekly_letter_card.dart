import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/analytics/analytics_event.dart';
import 'package:mochi_moon/core/analytics/analytics_providers.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/letters/application/weekly_letter_providers.dart';
import 'package:mochi_moon/features/letters/domain/weekly_letter.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';

/// The weekly letter from Mochi (PRD §6.24) on Today and in Me → Letters.
/// Premium opens the letter; a free user sees a teaser and an invitation.
/// It shows on Sunday and stays until the next one, so the letter is easy to
/// find all week.
class WeeklyLetterCard extends ConsumerWidget {
  const WeeklyLetterCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final premium = ref.watch(hasPremiumProvider);

    if (!premium) {
      // The invitation shows on Sunday only, so it never nags.
      if (ref.watch(clockProvider)().weekday != DateTime.sunday) {
        return const SizedBox.shrink();
      }
      return _Shell(
        title: l10n.weeklyLetterPremiumTitle,
        children: [
          Text(l10n.weeklyLetterTeaser, style: theme.textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.weeklyLetterPremiumBody, style: theme.textTheme.bodyMedium),
        ],
      );
    }

    final letter = ref.watch(weeklyLetterProvider);
    return letter.when(
      loading: () => _Shell(
        title: l10n.weeklyLetterTitle,
        children: [Text(l10n.weeklyLetterLoading)],
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (view) {
        if (view == null) return const SizedBox.shrink();
        return _Shell(
          title: l10n.weeklyLetterTitle,
          children: [
            Text(view.letter.firstLine, style: theme.textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: () => _open(context, ref, view),
                child: Text(l10n.weeklyLetterOpen),
              ),
            ),
          ],
        );
      },
    );
  }

  void _open(BuildContext context, WidgetRef ref, WeeklyLetterView view) {
    unawaited(
      ref.read(analyticsLoggerProvider).log(AnalyticsEvent.weeklyLetterViewed),
    );
    final l10n = AppLocalizations.of(context);
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(view.letter.title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(view.letter.body),
                if (view.isFallback) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.weeklyLetterOfflineNote,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.entertainmentNote,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.weeklyLetterClose),
            ),
          ],
        ),
      ),
    );
  }
}

class _Shell extends StatelessWidget {
  const _Shell({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.all(AppSpacing.md),
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...children,
        ],
      ),
    ),
  );
}
