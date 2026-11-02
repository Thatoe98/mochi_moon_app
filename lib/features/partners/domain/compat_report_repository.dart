import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/astro/synastry.dart';
import 'package:mochi_moon/features/cosmic/report/domain/natal_report.dart';

/// Where the Premium compatibility report comes from (PRD §6.12). It has the
/// same shape as the natal report: parts arrive as the server writes them.
abstract interface class CompatReportRepository {
  /// The report for [you] and [them] in [lang]. A finished report saved on the
  /// device comes at once and alone. Otherwise it is asked for and the stream
  /// emits it again as parts arrive, ending when it is ready or has failed.
  ///
  /// Errors on the stream: an `AppFailure` or a `ReadingsApiException`
  /// (402 when she is not Premium).
  Stream<NatalReport> report({
    required String partnerId,
    required NatalChart you,
    required NatalChart them,
    required Synastry synastry,
    required String lang,
  });
}
