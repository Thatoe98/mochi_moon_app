import 'package:mochi_moon/core/analytics/analytics_consent_repository.dart';
import 'package:mochi_moon/core/analytics/analytics_logger.dart';
import 'package:mochi_moon/core/analytics/analytics_sink.dart';
import 'package:mochi_moon/core/analytics/prefs_analytics_consent_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'analytics_providers.g.dart';

@Riverpod(keepAlive: true)
AnalyticsConsentRepository analyticsConsentRepository(Ref ref) =>
    PrefsAnalyticsConsentRepository(SharedPreferencesAsync());

/// The analytics service. Nothing is attached yet, so nothing is sent.
@Riverpod(keepAlive: true)
AnalyticsSink analyticsSink(Ref ref) => const NoopAnalyticsSink();

/// The user's analytics answer: null until they answer, then true or false.
@Riverpod(keepAlive: true)
class AnalyticsConsentController extends _$AnalyticsConsentController {
  @override
  Future<bool?> build() => ref.watch(analyticsConsentRepositoryProvider).load();

  Future<void> set({required bool granted}) async {
    await ref.read(analyticsConsentRepositoryProvider).save(granted: granted);
    state = AsyncData(granted);
  }
}

/// The one way to log an event; it checks consent on every call.
@Riverpod(keepAlive: true)
AnalyticsLogger analyticsLogger(Ref ref) => AnalyticsLogger(
  ref.watch(analyticsSinkProvider),
  () => ref.read(analyticsConsentControllerProvider).value ?? false,
);
