import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/widgets/timer_ring.dart';

Widget host(Widget child) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('calls onCompleted once, only after the duration', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      host(
        TimerRing(
          duration: const Duration(seconds: 3),
          onCompleted: () => calls++,
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 2900));
    expect(calls, 0);
    expect(find.byIcon(Icons.check_rounded), findsNothing);

    await tester.pump(const Duration(milliseconds: 200));
    expect(calls, 1);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    expect(calls, 1);
  });

  testWidgets('a completed ring starts full and stays silent', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      host(
        TimerRing(
          duration: const Duration(seconds: 3),
          completed: true,
          onCompleted: () => calls++,
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 5));

    expect(calls, 0);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });

  testWidgets('announces itself to screen readers', (tester) async {
    await tester.pumpWidget(
      host(TimerRing(duration: const Duration(seconds: 3), onCompleted: () {})),
    );

    expect(find.bySemanticsLabel('Read-aloud timer'), findsOneWidget);
    await tester.pumpAndSettle();
  });
}
