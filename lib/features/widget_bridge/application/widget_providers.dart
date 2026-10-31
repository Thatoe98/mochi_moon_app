import 'package:flutter/foundation.dart';
import 'package:mochi_moon/features/custom_cards/application/own_card_providers.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';
import 'package:mochi_moon/features/widget_bridge/data/home_widget_publisher.dart';
import 'package:mochi_moon/features/widget_bridge/domain/widget_day.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'widget_providers.g.dart';

@Riverpod(keepAlive: true)
WidgetPublisher widgetPublisher(Ref ref) => HomeWidgetPublisher();

/// Restocks the home-screen widget with the next two weeks of cards. Watched
/// from the app root, so it runs each time the app opens. The widget is a
/// bonus: a failure here is logged and never reaches the user.
@Riverpod(keepAlive: true)
Future<void> widgetSync(Ref ref) async {
  try {
    final quotes = await ref.watch(cardPoolProvider.future);
    final days = planWidgetDays(
      now: ref.read(clockProvider)(),
      quotes: quotes,
      lang: ref.watch(reminderLanguageProvider),
    );
    if (days.isEmpty) return;
    await ref.read(widgetPublisherProvider).publish(days);
  } on Exception catch (error, stackTrace) {
    debugPrint('Home-screen widget sync failed: $error\n$stackTrace');
  }
}
