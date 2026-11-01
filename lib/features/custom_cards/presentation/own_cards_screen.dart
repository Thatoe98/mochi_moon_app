import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/custom_cards/application/own_card_providers.dart';
import 'package:mochi_moon/features/custom_cards/domain/own_card.dart';
import 'package:mochi_moon/features/custom_cards/presentation/own_card_editor.dart';

/// Me → My own cards (PRD §6.17): the cards she wrote, a button to write
/// another, and a gentle note once the free three are used.
class OwnCardsScreen extends ConsumerWidget {
  const OwnCardsScreen({super.key});

  Future<void> _write(BuildContext context, WidgetRef ref) async {
    final slots = ref.read(ownCardSlotsLeftProvider);
    if (slots != null && slots <= 0) {
      await _showLimit(context);
      return;
    }
    if (!context.mounted) return;
    await showOwnCardEditor(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cards = ref.watch(ownCardsProvider);
    final slots = ref.watch(ownCardSlotsLeftProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.ownCardsTitle)),
      body: cards.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) =>
            ErrorView(onRetry: () => ref.invalidate(ownCardsProvider)),
        data: (list) => ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            if (list.isEmpty)
              _Empty(l10n: l10n)
            else
              for (final card in list) _CardTile(card: card),
            const SizedBox(height: AppSpacing.md),
            if (slots != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Text(
                  l10n.ownCardsSlotsLeft(slots),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            FilledButton.icon(
              onPressed: () => _write(context, ref),
              icon: const Icon(Icons.edit_rounded),
              label: Text(l10n.ownCardsWrite),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.ownCardsPrivacyNote,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// Tells her the free cards are used. There is no paywall screen yet, so this
/// explains the choice; deleting a card makes room.
Future<void> _showLimit(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.ownCardsLimitTitle),
      content: Text(l10n.ownCardsLimitBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.ownCardsLimitOk),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            unawaited(context.push('${AppRoutes.paywall}?source=own_cards'));
          },
          child: Text(l10n.paywallSeePremium),
        ),
      ],
    ),
  );
}

class _Empty extends StatelessWidget {
  const _Empty({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
    child: Column(
      children: [
        SizedBox.square(
          dimension: 160,
          child: MochiIllustration(
            asset: AppIllustrations.emptyDeck,
            semanticLabel: l10n.illustrationEmptyDeck,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.ownCardsEmptyTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.ownCardsEmptyBody,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    ),
  );
}

class _CardTile extends StatelessWidget {
  const _CardTile({required this.card});

  final OwnCard card;

  @override
  Widget build(BuildContext context) {
    final asset = AppIllustrations.forCard('self_love', card.illustrationId);
    return Card(
      child: ListTile(
        minTileHeight: AppSpacing.minTouchTarget + AppSpacing.md,
        leading: SizedBox.square(
          dimension: AppSpacing.minTouchTarget + AppSpacing.sm,
          child: ClipRRect(
            borderRadius: AppRadii.chipRadius,
            child: ExcludeSemantics(
              child: Image.asset(asset, fit: BoxFit.cover),
            ),
          ),
        ),
        title: Text(card.body, maxLines: 3, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => showOwnCardEditor(context, card: card),
      ),
    );
  }
}
