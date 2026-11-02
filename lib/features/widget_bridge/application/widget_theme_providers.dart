import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:mochi_moon/features/widget_bridge/data/prefs_widget_theme_repository.dart';
import 'package:mochi_moon/features/widget_bridge/domain/widget_theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'widget_theme_providers.g.dart';

@Riverpod(keepAlive: true)
WidgetThemeRepository widgetThemeRepository(Ref ref) =>
    PrefsWidgetThemeRepository(SharedPreferencesAsync());

/// The theme she picked, kept in sync with what is saved. It may be a Premium
/// one she no longer has; see [effectiveWidgetTheme].
@Riverpod(keepAlive: true)
class WidgetThemeController extends _$WidgetThemeController {
  @override
  Future<WidgetTheme> build() =>
      ref.watch(widgetThemeRepositoryProvider).load();

  Future<void> set(WidgetTheme theme) async {
    await ref.read(widgetThemeRepositoryProvider).save(theme);
    state = AsyncData(theme);
  }
}

/// The theme the widget shows now.
@Riverpod(keepAlive: true)
WidgetTheme effectiveWidgetTheme(Ref ref) {
  final chosen = ref.watch(widgetThemeControllerProvider).value;
  return (chosen ?? WidgetTheme.cream).effective(
    hasPremium: ref.watch(hasPremiumProvider),
  );
}
