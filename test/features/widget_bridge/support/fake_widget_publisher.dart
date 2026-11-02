import 'package:mochi_moon/features/widget_bridge/domain/widget_day.dart';
import 'package:mochi_moon/features/widget_bridge/domain/widget_theme.dart';

/// Records what would be shown on the home-screen widget.
class FakeWidgetPublisher implements WidgetPublisher {
  final List<List<WidgetDay>> published = [];
  final List<WidgetTheme> themes = [];

  @override
  Future<void> publish(
    List<WidgetDay> days, {
    WidgetTheme theme = WidgetTheme.cream,
  }) async {
    published.add(days);
    themes.add(theme);
  }
}
