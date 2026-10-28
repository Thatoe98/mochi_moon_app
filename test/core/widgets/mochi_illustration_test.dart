import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';

Widget host(Widget child, {double textScale = 1}) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context)
        .copyWith(textScaler: TextScaler.linear(textScale)),
    child: child!,
  ),
  home: Scaffold(body: child),
);

void main() {
  test('every named illustration exists on disk', () {
    for (final asset in AppIllustrations.all) {
      expect(File(asset).existsSync(), isTrue, reason: asset);
    }
  });

  testWidgets('empty state shows the art with its label', (tester) async {
    await tester.pumpWidget(
      host(
        const EmptyState(
          title: 'Nothing saved yet',
          illustration: AppIllustrations.emptyDeck,
          illustrationLabel: 'Mochi on a moon',
        ),
      ),
    );
    await tester.pump();

    final image = tester.widget<Image>(find.byType(Image));
    expect(image.semanticLabel, 'Mochi on a moon');
    expect(find.text('Nothing saved yet'), findsOneWidget);
  });

  testWidgets('empty state without art keeps the icon', (tester) async {
    await tester.pumpWidget(host(const EmptyState(title: 'Nothing here')));

    expect(find.byType(Image), findsNothing);
    expect(find.byIcon(Icons.nightlight_round), findsOneWidget);
  });

  testWidgets('empty state with art fits a small screen at 1.3x text', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(600, 900)
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      host(
        const EmptyState(
          title: 'Nothing saved yet',
          body: 'Swipe right on the cards you love and they will live here.',
          illustration: AppIllustrations.emptyDeck,
          illustrationLabel: 'Mochi on a moon',
        ),
        textScale: 1.3,
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
