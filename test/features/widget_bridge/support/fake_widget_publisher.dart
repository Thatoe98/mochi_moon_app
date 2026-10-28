import 'package:mochi_moon/features/widget_bridge/domain/widget_day.dart';

/// Records what would be shown on the home-screen widget.
class FakeWidgetPublisher implements WidgetPublisher {
  final List<List<WidgetDay>> published = [];

  @override
  Future<void> publish(List<WidgetDay> days) async => published.add(days);
}
