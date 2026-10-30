import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/synastry.dart';
import 'package:mochi_moon/features/cosmic/presentation/zodiac_labels.dart';
import 'package:mochi_moon/features/partners/application/compatibility_providers.dart';
import 'package:mochi_moon/features/partners/domain/compatibility_band.dart';
import 'package:mochi_moon/features/partners/presentation/compatibility_labels.dart';
import 'package:mochi_moon/features/partners/presentation/compatibility_meter.dart';

/// How the user's chart and a partner's meet (PRD §6.12), worked out on the
/// device.
class PartnerResultScreen extends ConsumerWidget {
  const PartnerResultScreen({this.partnerId, super.key});

  final String? partnerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final id = partnerId;
    if (id == null) {
      return _shell(l10n, EmptyState(title: l10n.partnersNotFound));
    }
    final result = ref.watch(compatibilityProvider(id));
    return _shell(
      l10n,
      result.when(
        loading: () => const LoadingView(),
        error: (error, _) => error is PartnerNotFound
            ? EmptyState(title: l10n.partnersNotFound)
            : ErrorView(
                onRetry: () => ref.invalidate(compatibilityProvider(id)),
              ),
        data: (compat) => compat == null
            ? EmptyState(
                title: l10n.compatNeedsBirthDateTitle,
                body: l10n.compatNeedsBirthDateBody,
              )
            : _Result(compat: compat),
      ),
      editId: id,
    );
  }

  Widget _shell(AppLocalizations l10n, Widget body, {String? editId}) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.compatTitle),
        actions: [
          if (editId != null)
            Builder(
              builder: (context) => IconButton(
                constraints: const BoxConstraints(
                  minWidth: AppSpacing.minTouchTarget,
                  minHeight: AppSpacing.minTouchTarget,
                ),
                tooltip: l10n.partnersEditTitle,
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.push(
                  Uri(
                    path: AppRoutes.partnerEdit,
                    queryParameters: {'id': editId},
                  ).toString(),
                ),
              ),
            ),
        ],
      ),
      body: body,
    );
  }
}

class _Result extends StatelessWidget {
  const _Result({required this.compat});

  final Compatibility compat;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final synastry = compat.synastry;
    final name = compat.partner.nickname;
    final yourSign = zodiacSignLabel(
      l10n,
      compat.you.placementOf(Body.sun).sign,
    );
    final theirSign = zodiacSignLabel(
      l10n,
      compat.them.placementOf(Body.sun).sign,
    );
    final supportive = compat.topSupportive;
    final growth = compat.topGrowth;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text(
          l10n.compatHeader(yourSign, name, theirSign),
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(child: CompatibilityMeter(score: synastry.overall)),
        const SizedBox(height: AppSpacing.md),
        Text(
          compatibilitySummary(l10n, CompatibilityBand.of(synastry.overall)),
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        if (synastry.light) ...[
          const SizedBox(height: AppSpacing.md),
          Center(child: Chip(label: Text(l10n.compatLightLabel))),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.compatLightBody,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        for (final themeKind in SynastryTheme.values)
          _ThemeBar(
            label: synastryThemeLabel(l10n, themeKind),
            score: synastry.scoreOf(themeKind),
          ),
        if (supportive.isEmpty && growth.isEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.compatQuiet, style: theme.textTheme.bodyMedium),
        ],
        if (supportive.isNotEmpty)
          _AspectSection(
            title: l10n.compatFlowTitle,
            aspects: supportive,
            name: name,
          ),
        if (growth.isNotEmpty)
          _AspectSection(
            title: l10n.compatGrowTitle,
            aspects: growth,
            name: name,
          ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.cosmicDisclaimer,
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ThemeBar extends StatelessWidget {
  const _ThemeBar({required this.label, required this.score});

  final String label;
  final int score;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Semantics(
      label: l10n.compatThemeScore(label, score),
      child: ExcludeSemantics(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label, style: theme.textTheme.titleSmall),
                  Text('$score%', style: theme.textTheme.titleSmall),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              ClipRRect(
                borderRadius: AppRadii.chipRadius,
                child: LinearProgressIndicator(
                  value: score / 100,
                  minHeight: AppSpacing.sm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AspectSection extends StatelessWidget {
  const _AspectSection({
    required this.title,
    required this.aspects,
    required this.name,
  });

  final String title;
  final List<SynastryAspect> aspects;
  final String name;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          for (final aspect in aspects)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.compatAspectPair(
                        synastryPointLabel(l10n, aspect.fromA),
                        name,
                        synastryPointLabel(l10n, aspect.fromB),
                      ),
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      aspectText(l10n, aspect.type),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
