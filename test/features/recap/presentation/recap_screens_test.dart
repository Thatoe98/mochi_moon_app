import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';
import 'package:mochi_moon/features/recap/application/recap_providers.dart';
import 'package:mochi_moon/features/recap/domain/monthly_recap.dart';
import 'package:mochi_moon/features/recap/presentation/recap_content.dart';
import 'package:mochi_moon/features/recap/presentation/recap_image.dart';
import 'package:mochi_moon/features/recap/presentation/recap_screen.dart';
import 'package:mochi_moon/features/recap/presentation/recap_today_card.dart';

final _active = RecapView(
  recap: MonthlyRecap(
    month: DateTime(2026, 10),
    daysShownUp: 12,
    daysInMonth: 31,
    topMood: Mood.calm,
    favouriteQuoteId: 'q1',
  ),
  favourite: const Quote(
    id: 'q1',
    text: {'en': 'I am gentle with myself.'},
    category: 'calm',
  ),
);

final _empty = RecapView(
  recap: MonthlyRecap(
    month: DateTime(2026, 10),
    daysShownUp: 0,
    daysInMonth: 31,
  ),
);

Widget _app(Widget child, RecapView view, DateTime now) => ProviderScope(
  overrides: [
    lastMonthRecapProvider.overrideWith((ref) async => view),
    clockProvider.overrideWithValue(() => now),
  ],
  child: MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  ),
);

Set<String> _texts(WidgetTester tester) => {
  for (final t in tester.widgetList<Text>(find.byType(Text)))
    if (t.data != null) t.data!,
};

void main() {
  testWidgets('the recap shows days, top mood and the favourite card', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 2400);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      _app(const RecapScreen(), _active, DateTime(2026, 11, 2)),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('12'), findsOneWidget);
    expect(find.text('Your October glow'), findsOneWidget);
    expect(find.text('days you showed up'), findsOneWidget);
    expect(find.text('Most often you felt Calm'), findsOneWidget);
    expect(find.text('I am gentle with myself.'), findsOneWidget);
    expect(find.text('Share your glow'), findsOneWidget);
  });

  testWidgets('a month with no days shows welcome back and no share', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 2400);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      _app(const RecapScreen(), _empty, DateTime(2026, 11, 2)),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Share your glow'), findsNothing);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('the image holds only app words, numbers and the bundled card', (
    tester,
  ) async {
    late BuildContext captured;
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) {
            captured = context;
            return buildRecapImage(context, _active);
          },
        ),
        _active,
        DateTime(2026, 11, 2),
      ),
    );

    expect(buildRecapImage(captured, _active), isA<RecapImage>());
    expect(_texts(tester), {
      'Your October glow',
      '12',
      'days you showed up',
      '😌',
      'Most often you felt Calm',
      'A card you loved',
      'I am gentle with myself.',
      'Mochi Moon',
    });
  });

  testWidgets('Today offers the recap on the first days only', (tester) async {
    await tester.pumpWidget(
      _app(const RecapTodayCard(), _active, DateTime(2026, 11, 2)),
    );
    await tester.pump();
    await tester.pump();
    expect(find.text('Your October glow is ready'), findsOneWidget);

    await tester.pumpWidget(
      _app(const RecapTodayCard(), _active, DateTime(2026, 11, 9)),
    );
    await tester.pump();
    expect(find.byType(Card), findsNothing);
  });

  testWidgets('Today offers nothing to someone with no history', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const RecapTodayCard(), _empty, DateTime(2026, 11, 2)),
    );
    await tester.pump();
    await tester.pump();

    expect(find.byType(Card), findsNothing);
  });
}
