import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/network/readings_api.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/cosmic/report/application/natal_report_providers.dart';
import 'package:mochi_moon/features/cosmic/report/domain/natal_report.dart';

/// The Premium natal report: a long, gentle read about the user, shown part by
/// part as the server writes it (PRD §6.11).
class NatalReportScreen extends ConsumerWidget {
  const NatalReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final provider = natalReportProvider(lang);
    final report = ref.watch(provider);
    void retry() => ref.invalidate(provider);

    final Widget body;
    final shown = report.value;
    if (shown != null) {
      body = _ReportView(
        report: shown,
        interrupted: report.hasError,
        onRetry: retry,
      );
    } else if (report.hasError) {
      body = _FailureView(error: report.error!, onRetry: retry);
    } else if (report.hasValue) {
      // The stream gave null: there is no birth date to read from.
      body = EmptyState(
        title: l10n.chartNeedsBirthDateTitle,
        body: l10n.chartNeedsBirthDateBody,
      );
    } else {
      body = EmptyState(
        title: l10n.reportPreparingTitle,
        body: l10n.reportPreparingBody,
        action: const CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportTitle)),
      body: body,
    );
  }
}

/// Nothing to show yet and the report could not be asked for.
class _FailureView extends StatelessWidget {
  const _FailureView({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (title, body) = switch (error) {
      NetworkFailure() => (l10n.reportOfflineTitle, l10n.reportOfflineBody),
      UnavailableFailure() => (
        l10n.stateErrorTitle,
        l10n.reportUnavailableBody,
      ),
      ReadingsApiException(status: 429) => (
        l10n.stateErrorTitle,
        l10n.reportBusyBody,
      ),
      _ => (l10n.stateErrorTitle, l10n.stateErrorBody),
    };
    return EmptyState(
      title: title,
      body: body,
      action: error is UnavailableFailure
          ? null
          : FilledButton(onPressed: onRetry, child: Text(l10n.stateRetry)),
    );
  }
}

class _ReportView extends StatelessWidget {
  const _ReportView({
    required this.report,
    required this.interrupted,
    required this.onRetry,
  });

  final NatalReport report;

  /// The wait for the rest broke off, for example the phone went offline.
  final bool interrupted;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final stalled = report.isFailed || (interrupted && !report.isReady);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Semantics(
          liveRegion: true,
          child: Text(
            l10n.reportProgress(
              report.sections.length,
              report.total,
              report.readMinutes,
            ),
            style: theme.textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final section in report.sections) _SectionCard(section: section),
        if (stalled)
          _StalledCard(onRetry: onRetry)
        else if (report.isGenerating)
          const _WritingTile(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Text(
            l10n.cosmicDisclaimer,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

const _icons = <String, IconData>{
  'overview': Icons.auto_awesome_rounded,
  'core_self': Icons.wb_sunny_rounded,
  'emotions': Icons.nightlight_round,
  'first_impression': Icons.waving_hand_rounded,
  'mind': Icons.lightbulb_rounded,
  'love': Icons.favorite_rounded,
  'drive': Icons.bolt_rounded,
  'work': Icons.work_rounded,
  'money': Icons.savings_rounded,
  'friends_family': Icons.groups_rounded,
  'growth': Icons.spa_rounded,
  'gentle_edges': Icons.cloud_rounded,
  'self_love_ritual': Icons.self_improvement_rounded,
};

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.section});

  final ReportSection section;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: colors.surfaceContainerHighest,
        borderRadius: AppRadii.cardRadius,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ExcludeSemantics(
                      child: Icon(
                        _icons[section.key] ?? Icons.star_rounded,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Semantics(
                        header: true,
                        child: Text(
                          section.title,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(section.body, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shown under the parts while the server writes the next one.
class _WritingTile extends StatelessWidget {
  const _WritingTile();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              l10n.reportWriting,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

/// Some parts did not get written, or the wait broke off.
class _StalledCard extends StatelessWidget {
  const _StalledCard({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: colors.secondaryContainer,
        borderRadius: AppRadii.cardRadius,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.reportFailedTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.onSecondaryContainer,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.reportFailedBody,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSecondaryContainer,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                FilledButton(onPressed: onRetry, child: Text(l10n.stateRetry)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
