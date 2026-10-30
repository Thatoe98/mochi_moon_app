import 'package:mochi_moon/core/analytics/analytics_consent_repository.dart';
import 'package:mochi_moon/core/analytics/analytics_sink.dart';

/// [saved] is null until the user answers, like the real repository.
class FakeAnalyticsConsentRepository implements AnalyticsConsentRepository {
  FakeAnalyticsConsentRepository({this.saved});

  bool? saved;

  @override
  Future<bool?> load() async => saved;

  @override
  Future<void> save({required bool granted}) async => saved = granted;
}

class RecordingAnalyticsSink implements AnalyticsSink {
  RecordingAnalyticsSink({this.failWith});

  final Exception? failWith;
  final recorded = <(String, Map<String, String>)>[];

  @override
  Future<void> record(String name, Map<String, String> params) async {
    final error = failWith;
    if (error != null) throw error;
    recorded.add((name, params));
  }
}
