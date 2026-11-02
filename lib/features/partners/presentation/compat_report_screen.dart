import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/cosmic/report/presentation/natal_report_screen.dart';
import 'package:mochi_moon/features/cosmic/unlock/presentation/cosmic_locked_view.dart';
import 'package:mochi_moon/features/partners/application/compat_report_providers.dart';
import 'package:mochi_moon/features/partners/application/compatibility_providers.dart';

/// The Premium compatibility report: a longer, gentle read about how the two
/// charts meet, shown part by part as the server writes it (PRD §6.12).
class CompatReportScreen extends ConsumerWidget {
  const CompatReportScreen({this.partnerId, super.key});

  final String? partnerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final id = partnerId;
    final lang = Localizations.localeOf(context).languageCode;
    final Widget body;
    if (id == null) {
      body = EmptyState(title: l10n.partnersNotFound);
    } else {
      final provider = compatReportProvider(id, lang);
      final report = ref.watch(provider);
      void retry() => ref.invalidate(provider);
      final shown = report.value;
      if (shown != null) {
        body = ReportView(
          report: shown,
          interrupted: report.hasError,
          onRetry: retry,
        );
      } else if (report.hasError) {
        body = report.error is PartnerNotFound
            ? EmptyState(title: l10n.partnersNotFound)
            : ReportFailureView(error: report.error!, onRetry: retry);
      } else if (report.hasValue) {
        body = CosmicLockedView(
          title: l10n.compatNeedsBirthDateTitle,
          body: l10n.compatNeedsBirthDateBody,
        );
      } else {
        body = EmptyState(
          title: l10n.reportPreparingTitle,
          body: l10n.reportPreparingBody,
          action: const CircularProgressIndicator(),
        );
      }
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.compatReportTitle)),
      body: body,
    );
  }
}
