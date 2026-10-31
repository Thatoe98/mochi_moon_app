import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';

/// The home tab (PRD §5): the daily ritual lives here. For now it shows the
/// streak and sends her to the deck; the ritual flow itself arrives with the
/// ritual task (PRD §6.15).
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final streak = ref.watch(deckProvider.select((d) => d.value?.streak)) ?? 0;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.todayTitle)),
      body: EmptyState(
        title: streak > 0 ? l10n.todayStreak(streak) : l10n.todayNoStreak,
        body: l10n.todayBody,
        illustration: AppIllustrations.emptyDeck,
        illustrationLabel: l10n.illustrationEmptyDeck,
        action: FilledButton(
          onPressed: () => context.go(AppRoutes.deck),
          child: Text(l10n.todayStart),
        ),
      ),
    );
  }
}
