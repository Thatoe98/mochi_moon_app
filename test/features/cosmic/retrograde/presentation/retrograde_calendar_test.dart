import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_theme.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/retrograde/domain/retrograde_status.dart';
import 'package:mochi_moon/features/cosmic/retrograde/presentation/retrograde_calendar.dart';

import '../support/periods.dart';

final _overview = RetrogradeOverview(
  now: DateTime(2026, 10, 29, 12),
  periods: {
    Body.mercury: [
      period(
        Body.mercury,
        start: DateTime(2026, 10, 9, 12).toUtc(),
        end: DateTime(2026, 11, 13, 12).toUtc(),
      ),
    ],
    Body.venus: [
      period(
        Body.venus,
        start: DateTime(2026, 10, 20, 12).toUtc(),
        end: DateTime(2026, 12, 1, 12).toUtc(),
      ),
    ],
  },
);

Widget _host({double textScale = 1}) => MaterialApp(
  theme: AppTheme.light,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context)
        .copyWith(textScaler: TextScaler.linear(textScale)),
    child: child!,
  ),
  home: Scaffold(
    body: SingleChildScrollView(child: RetrogradeCalendar(overview: _overview)),
  ),
);

Finder _day(Pattern label) => find.bySemanticsLabel(label);

void main() {
  testWidgets('opens on the current month', (tester) async {
    await tester.pumpWidget(_host());

    expect(find.text('October 2026'), findsOneWidget);
    expect(find.text('Retrograde calendar'), findsOneWidget);
  });

  testWidgets('names the planets that are retrograde on a day', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(_host());

    expect(
      _day(RegExp('October 15, 2026.*Mercury retrograde')),
      findsOneWidget,
    );
    expect(
      _day(RegExp('October 25, 2026.*Mercury, Venus retrograde')),
      findsOneWidget,
    );
    expect(_day(RegExp(r'October 5, 2026$')), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('pages to the next and previous month', (tester) async {
    await tester.pumpWidget(_host());

    await tester.tap(find.byTooltip('Next month'));
    await tester.pump();
    expect(find.text('November 2026'), findsOneWidget);

    await tester.tap(find.byTooltip('Previous month'));
    await tester.pump();
    expect(find.text('October 2026'), findsOneWidget);
  });

  testWidgets('stops at January this year and December next year', (
    tester,
  ) async {
    await tester.pumpWidget(_host());

    for (var i = 0; i < 9; i++) {
      await tester.tap(find.byTooltip('Previous month'));
      await tester.pump();
    }
    expect(find.text('January 2026'), findsOneWidget);
    expect(
      tester
          .widget<IconButton>(
            find.widgetWithIcon(IconButton, Icons.chevron_left_rounded),
          )
          .onPressed,
      isNull,
    );

    for (var i = 0; i < 23; i++) {
      await tester.tap(find.byTooltip('Next month'));
      await tester.pump();
    }
    expect(find.text('December 2027'), findsOneWidget);
    expect(
      tester
          .widget<IconButton>(
            find.widgetWithIcon(IconButton, Icons.chevron_right_rounded),
          )
          .onPressed,
      isNull,
    );
  });

  testWidgets('lists every planet in the color key', (tester) async {
    await tester.pumpWidget(_host());

    for (final name in ['Mercury', 'Venus', 'Mars', 'Jupiter', 'Saturn']) {
      expect(find.text(name), findsOneWidget);
    }
  });

  testWidgets('survives 1.3x text without overflow', (tester) async {
    await tester.pumpWidget(_host(textScale: 1.3));

    expect(tester.takeException(), isNull);
  });
}
