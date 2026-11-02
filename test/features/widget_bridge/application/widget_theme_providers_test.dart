import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:mochi_moon/features/widget_bridge/application/widget_theme_providers.dart';
import 'package:mochi_moon/features/widget_bridge/domain/widget_theme.dart';

class FakeWidgetThemeRepository implements WidgetThemeRepository {
  FakeWidgetThemeRepository([this.saved = WidgetTheme.cream]);

  WidgetTheme saved;

  @override
  Future<WidgetTheme> load() async => saved;

  @override
  Future<void> save(WidgetTheme theme) async => saved = theme;
}

ProviderContainer _container(
  FakeWidgetThemeRepository repo, {
  required bool premium,
}) {
  final container = ProviderContainer(
    overrides: [
      widgetThemeRepositoryProvider.overrideWithValue(repo),
      hasPremiumProvider.overrideWithValue(premium),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('setting a theme saves it', () async {
    final repo = FakeWidgetThemeRepository();
    final container = _container(repo, premium: true);
    await container.read(widgetThemeControllerProvider.future);

    await container
        .read(widgetThemeControllerProvider.notifier)
        .set(WidgetTheme.peach);

    expect(repo.saved, WidgetTheme.peach);
    expect(container.read(effectiveWidgetThemeProvider), WidgetTheme.peach);
  });

  test('a lapsed Premium theme shows as cream but is kept', () async {
    final repo = FakeWidgetThemeRepository(WidgetTheme.midnight);
    final container = _container(repo, premium: false);
    await container.read(widgetThemeControllerProvider.future);

    expect(container.read(effectiveWidgetThemeProvider), WidgetTheme.cream);
    expect(repo.saved, WidgetTheme.midnight);
  });
}
