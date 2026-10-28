import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/widget_bridge/data/home_widget_publisher.dart';
import 'package:mochi_moon/features/widget_bridge/domain/widget_day.dart';

final _days = [
  WidgetDay(
    date: DateTime(2026, 10, 28),
    quoteId: 'q_a',
    category: 'calm',
    text: 'First.',
  ),
  WidgetDay(
    date: DateTime(2026, 10, 29),
    quoteId: 'q b',
    category: 'healing',
    text: 'Second.',
  ),
  WidgetDay(
    date: DateTime(2026, 10, 30),
    quoteId: 'q_a',
    category: 'calm',
    text: 'First.',
  ),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('home_widget');
  late Map<String, Object?> stored;
  late List<MethodCall> calls;
  late List<String> rendered;

  Future<String> render(String key, String category) async {
    rendered.add(key);
    return '/files/$key.png';
  }

  setUp(() {
    stored = {};
    calls = [];
    rendered = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          final args = call.arguments as Map<Object?, Object?>?;
          switch (call.method) {
            case 'saveWidgetData':
              stored[args!['id']! as String] = args['data'];
              return true;
            case 'getWidgetData':
              return stored[args!['id']! as String];
            default:
              return true;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  List<MethodCall> named(String method) =>
      calls.where((c) => c.method == method).toList();

  test('stores each day with its text and thumbnail', () async {
    await HomeWidgetPublisher(renderThumbnail: render).publish(_days);

    final saved = jsonDecode(stored['days']! as String) as List<dynamic>;
    expect(saved, hasLength(3));
    expect(saved[0], {
      'date': '2026-10-28',
      'text': 'First.',
      'image': '/files/thumb_q_a.png',
    });
    // Ids are made safe for use as file names.
    expect((saved[1] as Map<String, dynamic>)['image'], '/files/thumb_q_b.png');
  });

  test('renders one thumbnail per card', () async {
    await HomeWidgetPublisher(renderThumbnail: render).publish(_days);

    expect(rendered, ['thumb_q_a', 'thumb_q_b']);
  });

  test('refreshes both widgets and schedules the later midnights', () async {
    await HomeWidgetPublisher(renderThumbnail: render).publish(_days);

    final updated = named('updateWidget').map(
      (c) => (c.arguments as Map<Object?, Object?>)['qualifiedAndroidName'],
    );
    expect(updated, widgetProviders);

    final scheduled = named('scheduleWidgetUpdates');
    expect(scheduled, hasLength(widgetProviders.length));
    expect(
      (scheduled.first.arguments as Map<Object?, Object?>)['updateTimes'],
      [
        DateTime(2026, 10, 29).millisecondsSinceEpoch,
        DateTime(2026, 10, 30).millisecondsSinceEpoch,
      ],
    );
  });

  test('does nothing when the days have not changed', () async {
    final publisher = HomeWidgetPublisher(renderThumbnail: render);
    await publisher.publish(_days);
    calls.clear();
    rendered.clear();

    await publisher.publish(_days);

    expect(rendered, isEmpty);
    expect(named('saveWidgetData'), isEmpty);
    expect(named('updateWidget'), isEmpty);
  });
}
