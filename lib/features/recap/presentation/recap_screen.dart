import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/deck/presentation/share_card_image.dart';
import 'package:mochi_moon/features/recap/application/recap_providers.dart';
import 'package:mochi_moon/features/recap/presentation/recap_content.dart';
import 'package:mochi_moon/features/recap/presentation/share_recap.dart';

/// Me → Monthly glow: last month's recap and a share button (PRD §6.25).
class RecapScreen extends ConsumerWidget {
  const RecapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final recap = ref.watch(lastMonthRecapProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.recapTitle)),
      body: recap.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.shareFailed)),
        data: (view) {
          final month = recapMonthName(context, view.recap.month);
          final days = view.recap.daysShownUp;
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Center(
                child: Semantics(
                  label: view.recap.isWelcomeBack
                      ? l10n.recapWelcomeBackBody
                      : '${l10n.recapHeadline(month)}, '
                            '$days ${l10n.recapDays(days)}',
                  excludeSemantics: true,
                  child: FittedBox(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: SizedBox.fromSize(
                        size: shareImageSize,
                        child: buildRecapImage(context, view),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (!view.recap.isWelcomeBack)
                FilledButton.icon(
                  onPressed: () => shareRecap(context, ref, view),
                  icon: const Icon(Icons.ios_share_rounded),
                  label: Text(l10n.recapShare),
                ),
            ],
          );
        },
      ),
    );
  }
}
