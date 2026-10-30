import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/report/domain/natal_report.dart';

/// Where the Premium natal report comes from (PRD §6.11).
abstract interface class NatalReportRepository {
  /// The report for [chart] in [lang]. A finished report saved on the device
  /// comes at once and alone. Otherwise the report is asked for and the stream
  /// emits it again as parts arrive, ending when it is ready or has failed.
  ///
  /// Errors on the stream: an `AppFailure` (no network, not available in this
  /// build) or a `ReadingsApiException`.
  Stream<NatalReport> report({required NatalChart chart, required String lang});
}
