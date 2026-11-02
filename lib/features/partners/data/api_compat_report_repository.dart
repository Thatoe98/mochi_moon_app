import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/network/readings_api.dart';
import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/astro/synastry.dart';
import 'package:mochi_moon/features/cosmic/report/data/api_natal_report_repository.dart';
import 'package:mochi_moon/features/cosmic/report/data/drift_natal_report_cache.dart';
import 'package:mochi_moon/features/cosmic/report/data/natal_report_codec.dart';
import 'package:mochi_moon/features/cosmic/report/domain/natal_report.dart';
import 'package:mochi_moon/features/partners/data/compat_report_codec.dart';
import 'package:mochi_moon/features/partners/domain/compat_report_repository.dart';

/// How many answers in a row may fail before the wait is given up.
const _maxMissedPolls = 5;

/// The compatibility report from the Readings API (PRD §6.12, §8.2): placements
/// and scores go out, never birth data. A finished report is saved on the
/// device, per partner, and then needs no network at all.
class ApiCompatReportRepository implements CompatReportRepository {
  ApiCompatReportRepository({
    required this.api,
    required this.cache,
    this.pollEvery = natalReportPollEvery,
    this.wait = _wait,
  });

  final ReadingsApi api;
  final DriftNatalReportCache cache;
  final Duration pollEvery;

  /// Replaced in tests so polling does not take real time.
  final Future<void> Function(Duration) wait;

  static Future<void> _wait(Duration duration) => Future.delayed(duration);

  @override
  Stream<NatalReport> report({
    required String partnerId,
    required NatalChart you,
    required NatalChart them,
    required Synastry synastry,
    required String lang,
  }) async* {
    final request = compatReportRequest(
      partnerId: partnerId,
      you: you,
      them: them,
      synastry: synastry,
      lang: lang,
    );
    final key = compatReportKey(request);
    final saved = await cache.find(lang: lang, key: key, partnerId: partnerId);
    if (saved != null && saved.isReady) {
      yield saved;
      return;
    }

    var current = natalReportFromJson(
      await api.postJson('reports/compatibility', request),
    );
    yield current;
    var missed = 0;
    while (current.isGenerating) {
      await wait(pollEvery);
      try {
        current = natalReportFromJson(
          await api.getJson('reports/compatibility/${current.reportId}'),
        );
        missed = 0;
      } on NetworkFailure {
        // A bad moment on the road must not lose a report being written.
        if (++missed >= _maxMissedPolls) rethrow;
        continue;
      }
      yield current;
    }
    if (current.isReady) {
      await cache.put(key: key, report: current, partnerId: partnerId);
    }
  }
}

/// Used while the build has no Readings API: the report cannot be written.
class UnavailableCompatReportRepository implements CompatReportRepository {
  const UnavailableCompatReportRepository();

  @override
  Stream<NatalReport> report({
    required String partnerId,
    required NatalChart you,
    required NatalChart them,
    required Synastry synastry,
    required String lang,
  }) => Stream.error(const UnavailableFailure());
}
