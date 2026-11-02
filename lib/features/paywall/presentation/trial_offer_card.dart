import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/paywall/application/trial_offer_providers.dart';

/// The one-time trial offer on Today (PRD §6.13), shown right after the ritual
/// on her 2nd or 3rd active day. Dismissing it costs nothing, and it never
/// comes back. It takes no space when it is not due.
class TrialOfferCard extends ConsumerStatefulWidget {
  const TrialOfferCard({super.key});

  @override
  ConsumerState<TrialOfferCard> createState() => _TrialOfferCardState();
}

class _TrialOfferCardState extends ConsumerState<TrialOfferCard> {
  bool _reported = false;

  @override
  Widget build(BuildContext context) {
    final due = ref.watch(trialOfferProvider).value ?? false;
    if (!due) return const SizedBox.shrink();
    if (!_reported) {
      _reported = true;
      // After this frame, so building the card never changes state.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(ref.read(trialOfferProvider.notifier).shown());
      });
    }
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.all(AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(
                l10n.trialOfferTitle,
                style: theme.textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.trialOfferBody, style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.sm),
            // A wrap, so large text puts the buttons on two lines.
            Wrap(
              alignment: WrapAlignment.end,
              spacing: AppSpacing.sm,
              children: [
                TextButton(
                  onPressed: ref.read(trialOfferProvider.notifier).dismiss,
                  child: Text(l10n.trialOfferDismiss),
                ),
                FilledButton(
                  onPressed: () {
                    ref.read(trialOfferProvider.notifier).opened();
                    unawaited(
                      context.push('${AppRoutes.paywall}?source=trial_offer'),
                    );
                  },
                  child: Text(l10n.trialOfferOpen),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
