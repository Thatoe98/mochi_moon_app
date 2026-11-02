import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/breathe/presentation/breathe_screen.dart';

import '../../paywall/support/expect_no_paywall.dart';

Widget _app({bool reduceMotion = false}) => ProviderScope(
  child: MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: reduceMotion),
      child: child!,
    ),
    home: Builder(
      builder: (context) => Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const BreatheScreen()),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    ),
  ),
);

Future<void> _open(WidgetTester tester, {bool reduceMotion = false}) async {
  await tester.pumpWidget(_app(reduceMotion: reduceMotion));
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

double _mochiScale(WidgetTester tester) => tester
    .widget<Transform>(find.byKey(const Key('breathe-mochi')))
    .transform
    .storage[0];

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized().platformDispatcher.views.first
      ..physicalSize = const Size(1170, 2532)
      ..devicePixelRatio = 3;
  });
  tearDown(() {
    TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
      ..resetPhysicalSize()
      ..resetDevicePixelRatio();
  });

  testWidgets('shows no paywall, lock or upsell', (tester) async {
    await _open(tester);
    expectNoPaywall(tester);
    await tester.tap(find.text('Begin'));
    await tester.pump(const Duration(seconds: 2));
    expectNoPaywall(tester);
  });

  testWidgets('shows the intro, then the cues in order', (tester) async {
    await _open(tester);
    expect(
      find.textContaining('One minute, just you and Mochi'),
      findsOneWidget,
    );

    await tester.tap(find.text('Begin'));
    await tester.pump();
    expect(find.text('Breathe in'), findsOneWidget);
    expect(find.text('Round 1 of 4'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4, milliseconds: 100));
    expect(find.text('Hold'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    expect(find.text('Breathe out'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    expect(find.text('Hold'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    expect(find.text('Breathe in'), findsOneWidget);
    expect(find.text('Round 2 of 4'), findsOneWidget);

    // Leave early so no animation is left running.
    await tester.tap(find.text('Stop for now'));
    await tester.pumpAndSettle();
  });

  testWidgets('Mochi grows and shrinks with the breath', (tester) async {
    await _open(tester);
    await tester.tap(find.text('Begin'));
    await tester.pump();
    final small = _mochiScale(tester);

    await tester.pump(const Duration(seconds: 4));
    final big = _mochiScale(tester);
    expect(big, greaterThan(small));

    await tester.pump(const Duration(seconds: 8));
    expect(_mochiScale(tester), lessThan(big));

    await tester.tap(find.text('Stop for now'));
    await tester.pumpAndSettle();
  });

  testWidgets('with reduce motion Mochi stays still but the cue moves', (
    tester,
  ) async {
    await _open(tester, reduceMotion: true);
    await tester.tap(find.text('Begin'));
    await tester.pump();
    final first = _mochiScale(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    expect(_mochiScale(tester), first);
    expect(find.text('Hold'), findsOneWidget);
    final ring = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );
    expect(ring.value, isNonZero);

    await tester.tap(find.text('Stop for now'));
    await tester.pumpAndSettle();
  });

  testWidgets('finishes with a gentle line and a next step', (tester) async {
    await _open(tester);
    await tester.tap(find.text('Begin'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 65));
    await tester.pump();

    expect(find.text('Well done, lovely'), findsOneWidget);
    expect(find.text('Breathe again'), findsOneWidget);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('open'), findsOneWidget);
  });

  testWidgets('leaving early goes back without a fuss', (tester) async {
    await _open(tester);
    await tester.tap(find.text('Begin'));
    await tester.pump(const Duration(seconds: 6));

    await tester.tap(find.text('Stop for now'));
    await tester.pumpAndSettle();

    expect(find.text('open'), findsOneWidget);
  });
}
