import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/settings/application/theme_mode_providers.dart';
import 'package:mochi_moon/features/settings/domain/theme_mode_setting.dart';
import 'package:mochi_moon/features/settings/presentation/theme_mode_section.dart';

class _FakeThemeRepo implements ThemeModeSettingRepository {
  _FakeThemeRepo(this.value);
  AppThemeChoice value;

  @override
  Future<AppThemeChoice> load() async => value;

  @override
  Future<void> save(AppThemeChoice choice) async => value = choice;
}

void main() {
  testWidgets('picking Dark saves it and switches the app theme mode', (
    tester,
  ) async {
    final repo = _FakeThemeRepo(AppThemeChoice.system);
    final container = ProviderContainer(
      overrides: [themeModeSettingRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: ThemeModeSection()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(container.read(appThemeModeProvider), ThemeMode.system);

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(repo.value, AppThemeChoice.dark);
    expect(container.read(appThemeModeProvider), ThemeMode.dark);

    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();
    expect(container.read(appThemeModeProvider), ThemeMode.light);
  });

  testWidgets('a saved choice is shown on start', (tester) async {
    final repo = _FakeThemeRepo(AppThemeChoice.light);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [themeModeSettingRepositoryProvider.overrideWithValue(repo)],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: ThemeModeSection()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final button = tester.widget<SegmentedButton<AppThemeChoice>>(
      find.byType(SegmentedButton<AppThemeChoice>),
    );
    expect(button.selected, {AppThemeChoice.light});
  });
}
