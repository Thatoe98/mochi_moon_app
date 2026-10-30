import 'package:flutter/foundation.dart';
import 'package:mochi_moon/core/analytics/analytics_event.dart';
import 'package:mochi_moon/core/analytics/analytics_sink.dart';

/// Logs events only while the user has allowed analytics (CLAUDE.md §9). Until
/// they answer, or after they decline, every call is a no-op.
class AnalyticsLogger {
  AnalyticsLogger(this._sink, this._consented);

  final AnalyticsSink _sink;
  final bool Function() _consented;

  Future<void> log(
    AnalyticsEvent event, {
    Map<String, String> params = const {},
  }) async {
    if (!_consented()) return;
    final allowed = {
      for (final entry in params.entries)
        if (event.allowedParams.contains(entry.key)) entry.key: entry.value,
    };
    try {
      await _sink.record(event.eventName, allowed);
    } on Object catch (error) {
      // Analytics must never break the app; log only the type, not the data.
      debugPrint('Analytics event dropped: ${error.runtimeType}');
    }
  }
}
