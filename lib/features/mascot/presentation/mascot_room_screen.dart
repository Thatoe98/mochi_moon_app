import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/journey.dart';
import 'package:mochi_moon/core/content/mascot_item.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/mascot/application/mascot_providers.dart';
import 'package:mochi_moon/features/mascot/domain/mascot_state.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';

/// The slots in the order the room shows them.
const List<String> _slotOrder = [
  outfitSlot,
  'floor',
  'shelf',
  'window',
  'wall',
];

/// Me → Mochi's room (PRD §6.23): Mochi, what she wears, and every gift with
/// how to earn it. One item per slot, no dragging. Nothing here is ever
/// taken away or made to look sad.
class MascotRoomScreen extends ConsumerWidget {
  const MascotRoomScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final items = ref.watch(mascotItemsProvider);
    final state = ref.watch(mascotStateProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.mascotRoomTitle)),
      body: switch ((items, state)) {
        (AsyncData(value: final items), AsyncData(value: final state)) => _Room(
          items: items,
          state: state,
        ),
        (AsyncError(), _) || (_, AsyncError()) => ErrorView(
          onRetry: () {
            ref
              ..invalidate(mascotItemsProvider)
              ..invalidate(mascotStateProvider);
          },
        ),
        _ => const LoadingView(),
      },
    );
  }
}

class _Room extends ConsumerWidget {
  const _Room({required this.items, required this.state});

  final List<MascotItem> items;
  final MascotState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final premium = ref.watch(hasPremiumProvider);
    final journeys = ref.watch(journeysProvider).value ?? const <Journey>[];

    String slotLabel(String slot) => switch (slot) {
      outfitSlot => l10n.mascotSlotOutfit,
      'floor' => l10n.mascotSlotFloor,
      'shelf' => l10n.mascotSlotShelf,
      'window' => l10n.mascotSlotWindow,
      'wall' => l10n.mascotSlotWall,
      _ => l10n.mascotSlotOther,
    };

    String lockedHint(MascotItem item) {
      final value = item.unlock.value;
      if (item.unlock.type == 'streak' && value is int) {
        return l10n.mascotItemLockedStreak(value);
      }
      if (item.unlock.type == 'journey' && value is String) {
        for (final journey in journeys) {
          if (journey.id == value) {
            return l10n.mascotItemLockedJourney(journey.titleFor(lang));
          }
        }
      }
      return l10n.mascotItemLockedOther;
    }

    final slots = <String>{
      ..._slotOrder,
      for (final item in items)
        if (!_slotOrder.contains(item.slot)) item.slot,
    };

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              width: 200,
              height: 200,
              child: MochiIllustration(
                asset: AppIllustrations.onboardingWelcome,
                semanticLabel: l10n.mascotRoomTitle,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(l10n.mascotRoomIntro, style: theme.textTheme.bodyLarge),
        if (state.owned.isEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          EmptyState(
            title: l10n.mascotRoomEmptyTitle,
            body: l10n.mascotRoomEmptyBody,
          ),
        ],
        for (final slot in slots)
          if (items.any((i) => i.slot == slot)) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(slotLabel(slot), style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            for (final item in items.where((i) => i.slot == slot))
              _ItemTile(
                item: item,
                name: item.nameFor(lang),
                owned: state.owns(item.id),
                worn: state.equipped[item.slot] == item.id,
                premiumLocked: item.premium && !premium,
                lockedHint: lockedHint(item),
                onTap: () async {
                  if (state.equipped[item.slot] == item.id) {
                    await ref.read(unequipMascotSlotProvider)(item.slot);
                  } else {
                    await ref.read(equipMascotItemProvider)(item);
                  }
                },
              ),
          ],
      ],
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.item,
    required this.name,
    required this.owned,
    required this.worn,
    required this.premiumLocked,
    required this.lockedHint,
    required this.onTap,
  });

  final MascotItem item;
  final String name;
  final bool owned;
  final bool worn;
  final bool premiumLocked;
  final String lockedHint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final status = !owned
        ? lockedHint
        : worn
        ? l10n.mascotItemOn
        : premiumLocked
        ? l10n.mascotPremiumNote
        : l10n.mascotItemTapToUse;
    final tappable = owned && (worn || !premiumLocked);
    return Semantics(
      container: true,
      button: tappable,
      selected: worn,
      label: l10n.mascotItemSemantics(name, status),
      excludeSemantics: true,
      onTap: tappable ? onTap : null,
      child: Card(
        color: worn ? scheme.primaryContainer : null,
        child: ListTile(
          minTileHeight: AppSpacing.minTouchTarget,
          enabled: owned,
          leading: Icon(
            !owned
                ? Icons.lock_outline_rounded
                : worn
                ? Icons.check_circle_rounded
                : item.isOutfit
                ? Icons.checkroom_rounded
                : Icons.chair_alt_rounded,
          ),
          title: Text(owned ? name : '?'),
          subtitle: Text(status),
          trailing: item.premium
              ? Chip(label: Text(l10n.mascotPremiumTag))
              : null,
          onTap: tappable ? onTap : null,
        ),
      ),
    );
  }
}
