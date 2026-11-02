import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/deck/presentation/gated_card_deck.dart';
import 'package:mochi_moon/features/journeys/application/journey_providers.dart';
import 'package:mochi_moon/features/journeys/domain/journey_progress.dart';

const _reflectionMaxLength = 300;

/// Today's day of a journey (PRD §6.21): its cards behind the read-aloud
/// timer, then the tiny quest and a private reflection, then "finish".
class JourneyDayScreen extends ConsumerWidget {
  const JourneyDayScreen({required this.journeyId, super.key});

  final String journeyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final runs = ref.watch(journeyProgressListProvider);
    final journey = ref.watch(journeyByIdProvider(journeyId));
    return Scaffold(
      appBar: AppBar(),
      body: runs.when(
        loading: () => const LoadingView(),
        error: (_, _) => ErrorView(
          onRetry: () => ref.invalidate(journeyProgressListProvider),
        ),
        data: (all) {
          JourneyProgress? run;
          for (final candidate in all) {
            if (candidate.journeyId == journeyId) run = candidate;
          }
          final total = journey.value?.days;
          if (run == null || total == null) {
            return EmptyState(title: l10n.journeyNotFound);
          }
          return _Day(journeyId: journeyId, day: run.currentDay, total: total);
        },
      ),
    );
  }
}

class _Day extends ConsumerStatefulWidget {
  const _Day({required this.journeyId, required this.day, required this.total});

  final String journeyId;
  final int day;
  final int total;

  @override
  ConsumerState<_Day> createState() => _DayState();
}

class _DayState extends ConsumerState<_Day> {
  final _read = <String>{};
  final _controller = TextEditingController();
  int _position = 0;
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onAction(DeckAction action, Quote quote) async {
    await ref
        .read(deckRepositoryProvider)
        .record(
          quote.id,
          action,
          ref.read(clockProvider)(),
          source: DeckSource.journey,
        );
    // The card counts toward the streak and the day's limit.
    ref.invalidate(deckProvider);
    if (mounted) setState(() => _position++);
  }

  Future<void> _finish() async {
    setState(() => _saving = true);
    await ref.read(completeJourneyDayProvider)(
      widget.journeyId,
      reflection: _controller.text,
    );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final resolved = ref.watch(
      journeyDayProvider(widget.journeyId, widget.day),
    );
    return resolved.when(
      loading: () => const LoadingView(),
      error: (_, _) =>
          ErrorView(onRetry: () => ref.invalidate(journeyDayProvider)),
      data: (day) {
        if (day == null) return EmptyState(title: l10n.journeyNotFound);
        if (_position < day.quotes.length) {
          return GatedCardDeck(
            cards: day.quotes,
            position: _position,
            canUndo: false,
            caption: l10n.journeyCardsCaption(widget.day),
            readIds: _read,
            onRead: (id) => setState(() => _read.add(id)),
            onAction: _onAction,
            onUndo: () async {},
            allowShare: false,
          );
        }
        final quest = day.quest;
        final prompt = day.reflection[lang] ?? day.reflection['en'] ?? '';
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            if (quest != null) ...[
              Text(l10n.journeyQuestHeader, style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(quest.textFor(lang), style: theme.textTheme.bodyLarge),
              const SizedBox(height: AppSpacing.lg),
            ],
            Text(
              l10n.journeyReflectionHeader,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(prompt, style: theme.textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _controller,
              maxLength: _reflectionMaxLength,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              minLines: 2,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(hintText: l10n.journeyReflectionHint),
            ),
            Text(l10n.gratitudePrivacyNote, style: theme.textTheme.bodySmall),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: _saving ? null : _finish,
              child: Text(l10n.journeyFinishDay(widget.day)),
            ),
          ],
        );
      },
    );
  }
}
