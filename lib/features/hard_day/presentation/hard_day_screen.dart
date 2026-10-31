import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/analytics/analytics_event.dart';
import 'package:mochi_moon/core/analytics/analytics_providers.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/deck/presentation/quote_card.dart';
import 'package:mochi_moon/features/hard_day/application/hard_day_providers.dart';
import 'package:mochi_moon/features/settings/application/language_providers.dart';

/// The calm "Hard day?" button on Today and the Deck (PRD §6.26).
class HardDayButton extends StatelessWidget {
  const HardDayButton({required this.source, super.key});

  /// Where it sits ("today" or "deck"), for the one event the kit logs.
  final String source;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: () => context.push('${AppRoutes.hardDay}?source=$source'),
    child: Text(AppLocalizations.of(context).hardDayButton),
  );
}

/// A gentle kit for a hard day: breathing, three comforting cards, the wins
/// jar and a Help section. It works offline and signed out, and asks for
/// nothing: no mood, no text, no location.
class HardDayScreen extends ConsumerStatefulWidget {
  const HardDayScreen({this.source = '', super.key});

  final String source;

  @override
  ConsumerState<HardDayScreen> createState() => _HardDayScreenState();
}

class _HardDayScreenState extends ConsumerState<HardDayScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(
      ref
          .read(analyticsLoggerProvider)
          .log(AnalyticsEvent.hardDayOpened, params: {'source': widget.source}),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cards = ref.watch(comfortCardsTodayProvider);
    final lang = ref.watch(effectiveLanguageProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.hardDayTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(l10n.hardDayIntro, style: theme.textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: ListTile(
              minTileHeight: AppSpacing.minTouchTarget,
              leading: const Icon(Icons.self_improvement_rounded),
              title: Text(l10n.breatheTitle),
              subtitle: Text(l10n.hardDayBreatheSub),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push(AppRoutes.breathe),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Semantics(
            header: true,
            child: Text(
              l10n.hardDayCardsTitle,
              style: theme.textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (cards.value case final list? when list.isNotEmpty)
            SizedBox(
              height: 360,
              child: PageView(
                controller: PageController(viewportFraction: 0.9),
                children: [
                  for (final quote in list)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                      ),
                      child: QuoteCard(
                        text: quote.textFor(lang),
                        category: quote.category,
                        illustrationId: quote.illustrationId,
                      ),
                    ),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: ListTile(
              minTileHeight: AppSpacing.minTouchTarget,
              leading: const Icon(Icons.local_florist_rounded),
              title: Text(l10n.gratitudeTitle),
              subtitle: Text(l10n.hardDayJarSub),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push(AppRoutes.gratitude),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Helpline names and numbers stay out until the owner verifies them
          // (TODO_CONTENT, PRD §6.26); this shows only the note.
          Semantics(
            header: true,
            child: Text(
              l10n.hardDayHelpTitle,
              style: theme.textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.hardDayHelpNote, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.hardDayHelpFind, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
