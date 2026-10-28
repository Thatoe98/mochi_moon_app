import 'dart:convert';

import 'package:home_widget/home_widget.dart';
import 'package:mochi_moon/features/widget_bridge/data/widget_thumbnail.dart';
import 'package:mochi_moon/features/widget_bridge/domain/widget_day.dart';

/// Fully qualified names of the Android providers (2x2 and 4x2).
const widgetProviders = [
  'com.mochimoon.mochi_moon.CardWidgetSmall',
  'com.mochimoon.mochi_moon.CardWidgetWide',
];

const _daysKey = 'days';
const _signatureKey = 'days_signature';

/// Renders the thumbnail for [key] and returns the saved file's path.
typedef ThumbnailRenderer = Future<String> Function(String key);

Future<String> _renderWithHomeWidget(String key) =>
    HomeWidget.renderFlutterWidget(
      const WidgetThumbnail(),
      key: key,
      logicalSize: widgetThumbnailSize,
      pixelRatio: widgetThumbnailPixelRatio,
    );

/// Hands the widget its data through `home_widget`: one JSON list under
/// [_daysKey] (`date`, `text`, `image`) that the Kotlin providers read by
/// local date.
class HomeWidgetPublisher implements WidgetPublisher {
  HomeWidgetPublisher({ThumbnailRenderer? renderThumbnail})
    : _renderThumbnail = renderThumbnail ?? _renderWithHomeWidget;

  final ThumbnailRenderer _renderThumbnail;

  @override
  Future<void> publish(List<WidgetDay> days) async {
    // Nothing to show, or nothing new since the last run: leave it be.
    final signature = jsonEncode([
      for (final day in days) [_isoDate(day.date), day.quoteId, day.text],
    ]);
    if (await HomeWidget.getWidgetData<String>(_signatureKey) == signature) {
      return;
    }

    final images = <String, String>{};
    for (final day in days) {
      images[day.quoteId] ??= await _renderThumbnail(
        'thumb_${_safeKey(day.quoteId)}',
      );
    }

    await HomeWidget.saveWidgetData<String>(
      _daysKey,
      jsonEncode([
        for (final day in days)
          {
            'date': _isoDate(day.date),
            'text': day.text,
            'image': images[day.quoteId],
          },
      ]),
    );
    await HomeWidget.saveWidgetData<String>(_signatureKey, signature);

    for (final provider in widgetProviders) {
      await HomeWidget.scheduleWidgetUpdates([
        for (final day in days.skip(1)) day.date,
      ], qualifiedAndroidName: provider);
      await HomeWidget.updateWidget(qualifiedAndroidName: provider);
    }
  }
}

String _isoDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

/// `home_widget` keys become file names, so keep them to safe characters.
String _safeKey(String id) => id.replaceAll(RegExp('[^A-Za-z0-9_-]'), '_');
