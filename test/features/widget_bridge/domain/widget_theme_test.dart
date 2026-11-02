import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/widget_bridge/domain/widget_theme.dart';

void main() {
  test('only cream is free', () {
    expect(WidgetTheme.values.where((t) => !t.premium), [WidgetTheme.cream]);
  });

  test('fromId reads every id and falls back to cream', () {
    for (final theme in WidgetTheme.values) {
      expect(WidgetTheme.fromId(theme.id), theme);
    }
    expect(WidgetTheme.fromId(null), WidgetTheme.cream);
    expect(WidgetTheme.fromId('neon'), WidgetTheme.cream);
  });

  test('a Premium theme falls back to cream without Premium', () {
    expect(
      WidgetTheme.midnight.effective(hasPremium: false),
      WidgetTheme.cream,
    );
    expect(
      WidgetTheme.midnight.effective(hasPremium: true),
      WidgetTheme.midnight,
    );
    expect(WidgetTheme.cream.effective(hasPremium: false), WidgetTheme.cream);
  });
}
