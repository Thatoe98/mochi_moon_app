import 'package:mochi_moon/core/network/network_providers.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/cosmic/report/data/drift_natal_report_cache.dart';
import 'package:mochi_moon/features/cosmic/report/domain/natal_report.dart';
import 'package:mochi_moon/features/partners/application/compatibility_providers.dart';
import 'package:mochi_moon/features/partners/data/api_compat_report_repository.dart';
import 'package:mochi_moon/features/partners/domain/compat_report_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compat_report_providers.g.dart';

/// The Readings API with the device cache in front, or a stand-in that says
/// the report is unavailable when the build has no server.
@Riverpod(keepAlive: true)
CompatReportRepository compatReportRepository(Ref ref) {
  final api = ref.watch(readingsApiProvider);
  if (api == null) return const UnavailableCompatReportRepository();
  return ApiCompatReportRepository(
    api: api,
    cache: DriftNatalReportCache(ref.watch(appDatabaseProvider)),
  );
}

/// The Premium compatibility report for [partnerId] in [lang] as it is
/// written: each value has more parts than the one before. Null while the user
/// has no birth date. Only asked for when she opens the report.
@riverpod
Stream<NatalReport?> compatReport(
  Ref ref,
  String partnerId,
  String lang,
) async* {
  final compat = await ref.watch(compatibilityProvider(partnerId).future);
  if (compat == null) {
    yield null;
    return;
  }
  yield* ref
      .watch(compatReportRepositoryProvider)
      .report(
        partnerId: partnerId,
        you: compat.you,
        them: compat.them,
        synastry: compat.synastry,
        lang: lang,
      );
}
