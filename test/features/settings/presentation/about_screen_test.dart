import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/settings/presentation/about_screen.dart';

Widget _app({double textScale = 1, Locale? locale}) => MaterialApp(
  locale: locale,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context)
        .copyWith(textScaler: TextScaler.linear(textScale)),
    child: child!,
  ),
  home: const AboutScreen(),
);

void main() {
  testWidgets('explains the readings and keeps the entertainment note', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(800, 3000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.text('About'), findsOneWidget);
    expect(find.text('About readings'), findsOneWidget);
    expect(find.textContaining('Western tropical zodiac'), findsOneWidget);
    expect(find.textContaining('There is no chat'), findsOneWidget);
    expect(find.text('For entertainment and self-reflection'), findsOneWidget);
  });

  testWidgets('opens the open-source licenses', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Open-source licenses'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Open-source licenses'));
    await tester.pumpAndSettle();

    expect(find.byType(LicensePage), findsOneWidget);
  });

  testWidgets('reads in Burmese', (tester) async {
    await tester.pumpWidget(_app(locale: const Locale('my')));
    await tester.pumpAndSettle();

    expect(find.text('အကြောင်း'), findsOneWidget);
  });

  testWidgets('fits at 1.3x text size on a small phone', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app(textScale: 1.3));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('About readings'), findsOneWidget);
  });
}
