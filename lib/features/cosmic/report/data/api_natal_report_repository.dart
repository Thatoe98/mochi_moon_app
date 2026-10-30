import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/network/readings_api.dart';
import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/report/data/drift_natal_report_cache.dart';
import 'package:mochi_moon/features/cosmic/report/data/natal_report_codec.dart';
import 'package:mochi_moon/features/cosmic/report/domain/natal_report.dart';
import 'package:mochi_moon/features/cosmic/report/domain/natal_report_repository.dart';

/// How often the server is asked how far the report is.
const natalReportPollEvery = Duration(seconds: 3);

/// How many answers in a row may fail before the wait is given up.
const _maxMissedPolls = 5;

/// The natal report from the Readings API (PRD §6.11, §8.2): computed
/// placements go out, never birth data. A finished report is saved on the
/// device and then needs no network at all.
class ApiNatalReportRepository implements NatalReportRepository {
  ApiNatalReportRepository({
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
    required NatalChart chart,
    required String lang,
  }) async* {
    final request = natalReportRequest(chart, lang);
    final key = natalReportKey(request);
    final saved = await cache.find(lang: lang, key: key);
    if (saved != null && saved.isReady) {
      yield saved;
      return;
    }

    var current = natalReportFromJson(
      await api.postJson('reports/natal', request),
    );
    yield current;
    var missed = 0;
    while (current.isGenerating) {
      await wait(pollEvery);
      try {
        current = natalReportFromJson(
          await api.getJson('reports/natal/${current.reportId}'),
        );
        missed = 0;
      } on NetworkFailure {
        // A bad moment on the road must not lose a report being written.
        if (++missed >= _maxMissedPolls) rethrow;
        continue;
      }
      yield current;
    }
    if (current.isReady) await cache.put(key: key, report: current);
  }
}

/// Used while the build has no Readings API: the report cannot be written.
class UnavailableNatalReportRepository implements NatalReportRepository {
  const UnavailableNatalReportRepository();

  @override
  Stream<NatalReport> report({
    required NatalChart chart,
    required String lang,
  }) => Stream.error(const UnavailableFailure());
}
