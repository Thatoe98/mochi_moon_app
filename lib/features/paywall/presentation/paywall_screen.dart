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
  bool get _forReport => widget.source == 'compat_report';

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

  Future<void> _buyReport() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _buying = true);
    final result = await ref.read(purchaseCatalogProvider).buyReportCredit();
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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.paywallWelcome)));
        context.pop();
      }
    });
    // A bought report credit also closes the paywall: she goes back to the
    // reading she came for.
    ref.listen(reportCreditsProvider, (previous, next) {
      if (_forReport && next > (previous ?? 0) && context.canPop()) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.paywallReportAdded)));
        context.pop();
      }
    });
    final reportPrice = _forReport
        ? ref.watch(reportCreditPriceProvider).value
        : null;
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
      final price = priceOf(plan);
      return Expanded(
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
              width: selected ? 2 : 1,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => setState(() => _selected = plan),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  Icon(
                    selected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: selected ? theme.colorScheme.primary : null,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(title, style: theme.textTheme.titleSmall),
                        if (price != null)
                          Text(price, style: theme.textTheme.bodySmall),
                        if (note != null)
                          Text(
                            note,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                ),
                children: [
                  SizedBox(
                    height: 110,
                    child: MochiIllustration(
                      asset: AppIllustrations.onboardingWelcome,
                      semanticLabel: l10n.paywallTitle,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.paywallTitle,
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  for (final benefit in [
                    l10n.paywallBenefitCards,
                    l10n.paywallBenefitJourneys,
                    l10n.paywallBenefitLetter,
                  ])
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.xs,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.favorite_rounded,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              benefit,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: AppSpacing.sm),
                  Semantics(
                    header: true,
                    child: Text(
                      l10n.paywallAlsoTitle,
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.xs,
                    children: [
                      for (final benefit in [
                        l10n.paywallAlsoOwnCards,
                        l10n.paywallAlsoLetters,
                        l10n.paywallAlsoMood,
                        l10n.paywallAlsoQuests,
                        l10n.paywallAlsoCosmic,
                        l10n.paywallAlsoChart,
                        l10n.paywallAlsoCompat,
                        l10n.paywallAlsoRetro,
                      ])
                        Chip(
                          avatar: const Icon(Icons.check_rounded, size: 16),
                          label: Text(
                            benefit,
                            style: theme.textTheme.bodySmall,
                          ),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                    ],
                  ),
                  if (_forReport) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.paywallReportNote,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    OutlinedButton(
                      onPressed:
                          reportPrice != null && !_buying ? _buyReport : null,
                      child: Text(
                        l10n.paywallReportButton(reportPrice ?? '…'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.xs,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        planTile(
                          PremiumPlan.yearly,
                          l10n.paywallYearly,
                          l10n.paywallTrial,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        planTile(
                          PremiumPlan.monthly,
                          l10n.paywallMonthly,
                          null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: canPurchase && !_buying ? _buy : null,
                      child: Text(
                        _selected.hasTrial
                            ? l10n.paywallStartTrial
                            : l10n.paywallSubscribe,
                      ),
                    ),
                  ),
                  if (!canPurchase)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Text(
                        l10n.paywallUnavailable,
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: TextButton(
                          onPressed: _restoring ? null : _restore,
                          child: Text(
                            l10n.paywallRestore,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Flexible(
                        child: TextButton(
                          onPressed: _manage,
                          child: Text(
                            l10n.paywallManage,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    l10n.paywallFinePrint,
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
