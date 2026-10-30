import 'package:mochi_moon/core/network/network_providers.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/cosmic/chart/application/chart_providers.dart';
import 'package:mochi_moon/features/cosmic/report/data/api_natal_report_repository.dart';
import 'package:mochi_moon/features/cosmic/report/data/drift_natal_report_cache.dart';
import 'package:mochi_moon/features/cosmic/report/domain/natal_report.dart';
import 'package:mochi_moon/features/cosmic/report/domain/natal_report_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'natal_report_providers.g.dart';

/// The Readings API with the device cache in front, or a stand-in that says
/// the report is unavailable when the build has no server.
@Riverpod(keepAlive: true)
NatalReportRepository natalReportRepository(Ref ref) {
  final api = ref.watch(readingsApiProvider);
  if (api == null) return const UnavailableNatalReportRepository();
  return ApiNatalReportRepository(
    api: api,
    cache: DriftNatalReportCache(ref.watch(appDatabaseProvider)),
  );
}

/// The Premium natal report in [lang] as it is written: each value has more
/// parts than the one before. Null while there is no birth date. The server
/// keeps writing if the screen is left, and opening it again picks it up.
@riverpod
Stream<NatalReport?> natalReport(Ref ref, String lang) async* {
  final chart = await ref.watch(natalChartProvider.future);
  if (chart == null) {
    yield null;
    return;
  }
  yield* ref
      .watch(natalReportRepositoryProvider)
      .report(chart: chart, lang: lang);
}
