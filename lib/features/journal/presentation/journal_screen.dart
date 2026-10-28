import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/deck/presentation/category_label.dart';
import 'package:mochi_moon/features/deck/presentation/quote_card.dart';
import 'package:mochi_moon/features/deck/presentation/share_quote.dart';
import 'package:mochi_moon/features/journal/application/journal_providers.dart';

/// Saved cards, newest first, filterable by category (PRD §6.3).
class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  /// Null shows every category.
  String? _category;

  Future<void> _open(JournalItem item) {
    final lang = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context);
    return showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Flexible lets the card shrink on short (landscape) screens.
              Flexible(
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: QuoteCard(
                    text: item.quote.textFor(lang),
                    categoryLabel: categoryLabel(l10n, item.quote.category),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () => shareQuote(this.context, ref, item.quote),
                    icon: const Icon(Icons.ios_share_rounded),
                    label: Text(l10n.deckActionShare),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.journalClose),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmRemove(JournalItem item) async {
    final l10n = AppLocalizations.of(context);
    final remove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.journalRemoveTitle),
        content: Text(l10n.journalRemoveBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.journalKeep),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.journalRemoveConfirm),
          ),
        ],
      ),
    );
    if (remove ?? false) {
      await ref.read(journalProvider.notifier).remove(item.quote.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final journal = ref.watch(journalProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.journalTitle)),
      body: journal.when(
        loading: () => const LoadingView(),
        error: (_, _) => ErrorView(
          onRetry: () => ref
            ..invalidate(quotesProvider)
            ..invalidate(journalProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              title: l10n.journalEmptyTitle,
              body: l10n.journalEmptyBody,
              illustration: AppIllustrations.emptyDeck,
              illustrationLabel: l10n.illustrationEmptyDeck,
            );
          }
          final categories = {for (final i in items) i.quote.category}.toList();
          // The last card of a category may have just been removed.
          final selected = categories.contains(_category) ? _category : null;
          final shown = [
            for (final i in items)
              if (selected == null || i.quote.category == selected) i,
          ];
          return Column(
            children: [
              if (categories.length > 1)
                _CategoryFilter(
                  categories: categories,
                  selected: selected,
                  onSelected: (category) =>
                      setState(() => _category = category),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: shown.length,
                  itemBuilder: (context, index) => _JournalTile(
                    item: shown[index],
                    onTap: () => _open(shown[index]),
                    onLongPress: () => _confirmRemove(shown[index]),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<String> categories;
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          ChoiceChip(
            label: Text(l10n.journalFilterAll),
            selected: selected == null,
            onSelected: (_) => onSelected(null),
          ),
          for (final category in categories) ...[
            const SizedBox(width: AppSpacing.sm),
            ChoiceChip(
              label: Text(categoryLabel(l10n, category) ?? category),
              selected: selected == category,
              onSelected: (_) => onSelected(category),
            ),
          ],
        ],
      ),
    );
  }
}

class _JournalTile extends StatelessWidget {
  const _JournalTile({
    required this.item,
    required this.onTap,
    required this.onLongPress,
  });

  final JournalItem item;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    return ListTile(
      minTileHeight: AppSpacing.minTouchTarget + AppSpacing.md,
      leading: const SizedBox.square(
        dimension: AppSpacing.minTouchTarget + AppSpacing.sm,
        child: ClipRRect(
          borderRadius: AppRadii.chipRadius,
          child: IllustrationPlaceholder(iconSize: AppSpacing.lg),
        ),
      ),
      title: Text(
        item.quote.textFor(lang),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        categoryLabel(l10n, item.quote.category) ?? item.quote.category,
      ),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
