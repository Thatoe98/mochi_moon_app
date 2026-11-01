import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/recap/application/recap_providers.dart';
import 'package:mochi_moon/features/recap/domain/monthly_recap.dart';
import 'package:mochi_moon/features/recap/presentation/recap_content.dart';

/// On the first days of a month Today offers last month's recap (PRD §6.25).
/// It shows nothing after that, and nothing to someone with no history, so a
/// new user never sees an empty recap.
class RecapTodayCard extends ConsumerWidget {
  const RecapTodayCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(clockProvider)();
    if (now.day > recapTodayDays) return const SizedBox.shrink();
    final view = ref.watch(lastMonthRecapProvider).value;
    if (view == null || view.recap.isWelcomeBack) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);
    final month = recapMonthName(context, lastMonthOf(now));
    return Card(
      margin: const EdgeInsets.all(AppSpacing.md),
      child: ListTile(
        minTileHeight: AppSpacing.minTouchTarget,
        leading: const Icon(Icons.auto_awesome_rounded),
        title: Text(l10n.recapTodayTitle(month)),
        trailing: Text(l10n.recapTodayOpen),
        onTap: () => context.push(AppRoutes.recap),
      ),
    );
  }
}
