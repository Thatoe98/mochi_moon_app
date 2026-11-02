import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/network/network_providers.dart';
import 'package:mochi_moon/core/utils/url_opener.dart';
import 'package:mochi_moon/features/settings/presentation/about_screen.dart';

Widget _app({
  double textScale = 1,
  Locale? locale,
  String baseUrl = '',
  UrlOpener? opener,
}) => ProviderScope(
  overrides: [
    readingsApiBaseUrlProvider.overrideWithValue(baseUrl),
    if (opener != null) urlOpenerProvider.overrideWithValue(opener),
  ],
  child: MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(textScale)),
      child: child!,
    ),
    home: const AboutScreen(),
  ),
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

  group('legal links', () {
    void tall(WidgetTester tester) {
      tester.view
        ..physicalSize = const Size(800, 3000)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
    }

    testWidgets('are hidden when the build has no server address', (
      tester,
    ) async {
      tall(tester);
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      expect(find.text('Privacy policy'), findsNothing);
      expect(find.text('Terms of use'), findsNothing);
    });

    testWidgets('open the privacy policy and terms on the server', (
      tester,
    ) async {
      tall(tester);
      final opened = <Uri>[];
      await tester.pumpWidget(
        _app(
          baseUrl: 'https://api.example.com/v1/',
          opener: (url) async {
            opened.add(url);
            return true;
          },
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Privacy policy'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Terms of use'));
      await tester.pumpAndSettle();

      expect(opened, [
        Uri.parse('https://api.example.com/privacy'),
        Uri.parse('https://api.example.com/terms'),
      ]);
    });

    testWidgets('say so when the page cannot be opened', (tester) async {
      tall(tester);
      await tester.pumpWidget(
        _app(baseUrl: 'https://api.example.com', opener: (_) async => false),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Privacy policy'));
      await tester.pumpAndSettle();

      expect(find.textContaining('could not open that page'), findsOneWidget);
    });
  });
}
