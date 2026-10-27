import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';

/// Placeholder until the swipe deck lands (PRD M1).
class DeckScreen extends ConsumerWidget {
  const DeckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final quotes = ref.watch(quotesProvider);
    final lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.deckPlaceholderTitle)),
      body: quotes.when(
        loading: () => const LoadingView(),
        error: (_, _) =>
            ErrorView(onRetry: () => ref.invalidate(quotesProvider)),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              title: l10n.stateEmptyTitle,
              body: l10n.deckPlaceholderBody,
            );
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    items.first.textFor(lang),
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
