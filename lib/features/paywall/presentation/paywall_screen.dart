import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/core/analytics/analytics_event.dart';
import 'package:mochi_moon/core/analytics/analytics_providers.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/utils/url_opener.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:mochi_moon/features/paywall/application/purchase_providers.dart';
import 'package:mochi_moon/features/paywall/domain/play_links.dart';
import 'package:mochi_moon/features/paywall/domain/purchase_catalog.dart';

/// Premium offer (PRD §6.13). The close button is there from the first frame;
/// prices come from the store; the yearly plan is preselected.
class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({this.source = 'unknown', super.key});

  /// Where she came from, for the one analytics event (no personal data).
  final String source;

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  PremiumPlan _selected = PremiumPlan.yearly;
  bool _restoring = false;
  bool _buying = false;

  @override
  void initState() {
    super.initState();
    unawaited(
      ref
          .read(analyticsLoggerProvider)
          .log(AnalyticsEvent.paywallViewed, params: {'source': widget.source}),
    );
  }

  Future<void> _restore() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final catalog = ref.read(purchaseCatalogProvider);
    setState(() => _restoring = true);
    final found = await catalog.restore();
    if (!mounted) return;
    setState(() => _restoring = false);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          found ? l10n.paywallRestoreFound : l10n.paywallRestoreNone,
        ),
      ),
    );
  }

  Future<void> _buy() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _buying = true);
    final result = await ref.read(purchaseCatalogProvider).buy(_selected);
    if (!mounted) return;
    setState(() => _buying = false);
    if (result != BuyResult.started) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.paywallBuyFailed)));
    }
  }

  Future<void> _manage() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final opened = await ref.read(urlOpenerProvider)(manageSubscriptionUrl);
    if (!mounted || opened) return;
    messenger.showSnackBar(SnackBar(content: Text(l10n.paywallManageFailed)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    // The purchase finishes on the server; the paywall closes when the
    // entitlement says she has Premium.
    ref.listen(hasPremiumProvider, (previous, next) {
      if (next && previous == false && context.canPop()) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.paywallWelcome)));
        context.pop();
      }
    });
    final offers = ref.watch(planOffersProvider).value ?? const <PlanOffer>[];
    final canPurchase = ref.watch(purchaseCatalogProvider).canPurchase;

    String? priceOf(PremiumPlan plan) {
      for (final offer in offers) {
        if (offer.plan == plan) return offer.price;
      }
      return null;
    }

    Widget planTile(PremiumPlan plan, String title, String? note) {
      final selected = _selected == plan;
      final detail = [?note, ?priceOf(plan)].join(' · ');
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: ListTile(
          selected: selected,
          minTileHeight: 64,
          onTap: () => setState(() => _selected = plan),
          leading: Icon(
            selected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_unchecked_rounded,
          ),
          title: Text(title),
          subtitle: detail.isEmpty ? null : Text(detail),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: l10n.paywallClose,
            icon: const Icon(Icons.close_rounded),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          SizedBox(
            height: 180,
            child: MochiIllustration(
              asset: AppIllustrations.onboardingWelcome,
              semanticLabel: l10n.paywallTitle,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.paywallTitle,
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          for (final benefit in [
            l10n.paywallBenefitJourneys,
            l10n.paywallBenefitLetter,
            l10n.paywallBenefitCards,
          ])
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.favorite_rounded),
              title: Text(benefit),
            ),
          const SizedBox(height: AppSpacing.sm),
          planTile(PremiumPlan.yearly, l10n.paywallYearly, l10n.paywallTrial),
          planTile(PremiumPlan.monthly, l10n.paywallMonthly, null),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: canPurchase && !_buying ? _buy : null,
            child: Text(
              _selected.hasTrial
                  ? l10n.paywallStartTrial
                  : l10n.paywallSubscribe,
            ),
          ),
          if (!canPurchase) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.paywallUnavailable,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
          TextButton(
            onPressed: _restoring ? null : _restore,
            child: Text(l10n.paywallRestore),
          ),
          TextButton(
            onPressed: _manage,
            child: Text(l10n.paywallManage),
          ),
          Text(
            l10n.paywallFinePrint,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
