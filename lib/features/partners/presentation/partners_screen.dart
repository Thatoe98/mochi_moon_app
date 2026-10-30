import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/utils/english_dates.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/chart/presentation/chart_glyphs.dart';
import 'package:mochi_moon/features/cosmic/presentation/zodiac_labels.dart';
import 'package:mochi_moon/features/partners/application/partner_chart.dart';
import 'package:mochi_moon/features/partners/application/partner_providers.dart';
import 'package:mochi_moon/features/partners/domain/partner.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';

/// The people the user compares charts with (PRD §6.12): add, edit and delete.
class PartnersScreen extends ConsumerWidget {
  const PartnersScreen({super.key});

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Partner partner,
  ) async {
    final l10n = AppLocalizations.of(context);
    final delete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.partnersDeleteTitle(partner.nickname)),
        content: Text(l10n.partnersDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.journalKeep),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.partnersDeleteConfirm),
          ),
        ],
      ),
    );
    if (delete ?? false) {
      await ref.read(partnersProvider.notifier).remove(partner.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final partners = ref.watch(partnersProvider);
    final canAdd = ref.watch(canAddPartnerProvider);
    final hasPremium = ref.watch(hasPremiumProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.partnersTitle)),
      body: partners.when(
        loading: () => const LoadingView(),
        error: (_, _) =>
            ErrorView(onRetry: () => ref.invalidate(partnersProvider)),
        data: (items) => Column(
          children: [
            Expanded(
              child: items.isEmpty
                  ? EmptyState(
                      title: l10n.partnersEmptyTitle,
                      body: l10n.partnersEmptyBody,
                      illustration: AppIllustrations.emptyDeck,
                      illustrationLabel: l10n.illustrationEmptyDeck,
                    )
                  : ListView(
                      children: [
                        for (final partner in items)
                          _PartnerTile(
                            partner: partner,
                            onDelete: () =>
                                _confirmDelete(context, ref, partner),
                          ),
                      ],
                    ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!canAdd)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Text(
                          hasPremium
                              ? l10n.partnersLimitPremium(premiumPartnerLimit)
                              : l10n.partnersLimitFree(
                                  freePartnerLimit,
                                  premiumPartnerLimit,
                                ),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    FilledButton.icon(
                      onPressed: canAdd
                          ? () => context.push(AppRoutes.partnerEdit)
                          : null,
                      icon: const Icon(Icons.add_rounded),
                      label: Text(l10n.partnersAdd),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PartnerTile extends StatelessWidget {
  const _PartnerTile({required this.partner, required this.onDelete});

  final Partner partner;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sign = chartOfPartner(partner).placementOf(Body.sun).sign;
    return ListTile(
      minTileHeight: AppSpacing.minTouchTarget,
      leading: ExcludeSemantics(
        child: Text(
          signGlyph(sign),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      title: Text(partner.nickname),
      subtitle: Text(
        l10n.partnersTileSubtitle(
          zodiacSignLabel(l10n, sign),
          englishDates.formatShortDate(partner.birthDate),
        ),
      ),
      trailing: IconButton(
        constraints: const BoxConstraints(
          minWidth: AppSpacing.minTouchTarget,
          minHeight: AppSpacing.minTouchTarget,
        ),
        tooltip: l10n.partnersDeleteTooltip(partner.nickname),
        icon: const Icon(Icons.delete_outline_rounded),
        onPressed: onDelete,
      ),
      onTap: () => context.push(
        Uri(
          path: AppRoutes.partnerEdit,
          queryParameters: {'id': partner.id},
        ).toString(),
      ),
    );
  }
}
