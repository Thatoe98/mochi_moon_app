import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/retrograde/domain/retrograde_alerts.dart';

class FakeRetrogradeAlertSettingsRepository
    implements RetrogradeAlertSettingsRepository {
  FakeRetrogradeAlertSettingsRepository([this.saved]);

  Set<Body>? saved;

  @override
  Future<Set<Body>> load() async => saved ?? defaultRetrogradeAlertPlanets;

  @override
  Future<void> save(Set<Body> planets) async => saved = {...planets};
}

class FakeRetrogradeAlertScheduler implements RetrogradeAlertScheduler {
  List<PlannedRetrogradeAlert>? scheduled;
  RetrogradeAlertTexts? texts;
  int cancels = 0;

  @override
  Future<void> schedule(
    List<PlannedRetrogradeAlert> alerts,
    RetrogradeAlertTexts texts,
  ) async {
    scheduled = alerts;
    this.texts = texts;
  }

  @override
  Future<void> cancelAll() async {
    cancels++;
    scheduled = null;
  }
}
