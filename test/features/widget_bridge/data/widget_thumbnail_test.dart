import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/widget_bridge/data/widget_thumbnail.dart';

void main() {
  // The thumbnail is rendered outside the app's widget tree, so it must build
  // with nothing above it.
  testWidgets('builds on its own', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: WidgetThumbnail(category: 'calm')),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(WidgetThumbnail)), widgetThumbnailSize);
  });
}
